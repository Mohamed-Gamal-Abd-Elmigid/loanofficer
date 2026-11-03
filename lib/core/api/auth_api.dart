import 'package:flutter/material.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fmc_client.dart';
import 'package:loanofficer/core/api/fmc_session.dart';
import 'package:loanofficer/core/components/app_loading.dart';
import 'package:loanofficer/core/models/signed_in_officer.dart';
import 'package:loanofficer/core/storage/officer_session_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'package:loanofficer/core/api/api_exception.dart';
export 'package:loanofficer/core/api/fmc_session.dart' show FmcRole;
export 'package:loanofficer/core/models/signed_in_officer.dart';

class PasswordResetCode {
  const PasswordResetCode({required this.pin, this.recoveryToken});

  final String pin;
  final String? recoveryToken;
}

class AuthApi {
  AuthApi({
    FmcClient? client,
    FmcSession? session,
    OfficerSessionStore? officerStore,
  }) : _client = client ?? FmcClient(),
       _session = session ?? FmcSession.instance,
       _officerStore = officerStore ?? OfficerSessionStore();

  final FmcClient _client;
  final FmcSession _session;
  final OfficerSessionStore _officerStore;

  /// Signs in against `fmc/auth/login`.
  ///
  /// Returns every privilege from the login body. The caller shows the
  /// privileges screen; nothing is selected until [selectRole].
  Future<List<FmcRole>> login({
    required String employeeId,
    required String password,
  }) {
    return AppLoading.watch(
      () => _login(employeeId: employeeId, password: password),
    );
  }

  Future<List<FmcRole>> _login({
    required String employeeId,
    required String password,
  }) async {
    final userId = employeeId.trim();
    // Fusion sends Authorization and x-current-role as the literal "null"
    // on this call. A saved token makes the server reject the user.
    _session
      ..token = null
      ..roleId = null;
    try {
      await _session.save();
    } catch (_) {}
    final result = await _client.post('fmc/auth/login', {
      'userId': userId,
      'password': password,
      'macIp': '',
    });
    if (result is! Map) {
      throw AuthApiException('لم يتم استلام بيانات تسجيل الدخول');
    }
    final data = Map<String, dynamic>.from(result);
    final token = data['token'];
    if (token is! String || token.isEmpty) {
      throw AuthApiException('بيانات الدخول غير صحيحة');
    }
    var roles = _roles(data['availableRoleAndScreens']);
    if (roles.isEmpty) roles = _roles([data['currentRole']]);
    if (roles.isEmpty) {
      throw AuthApiException('هذا المستخدم ليس لديه أي صلاحيات');
    }
    _session
      ..token = token
      ..mcCode = data['mcCode'] == null ? '1' : '${data['mcCode']}'
      ..userId = _text(data['usrId']).isEmpty ? userId : _text(data['usrId'])
      ..roleId = null;
    await _session.saveLogin(data);
    await _saveOfficer(data, userId);
    return roles;
  }

  Future<void> selectRole(FmcRole role) {
    return AppLoading.watch(() => _selectRole(role));
  }

  Future<void> _selectRole(FmcRole role) async {
    final treeApi = await _client.get(
      'lookups/users/treeOfpages',
      query: {'roleId': role.id},
    );
    final roleTree = _roleTree(await _session.readLogin(), role.id);
    if (roleTree == null) {
      throw AuthApiException('تعذر تحميل صلاحيات الدور');
    }
    await _session.saveRoleSelection(
      roleId: role.id,
      treeApi: treeApi,
      roleTree: roleTree,
    );
    await _loadOfficer();
  }

  Map<String, dynamic>? _roleTree(Map<String, dynamic>? login, String roleId) {
    if (login == null) return null;
    final roles = login['availableRoleAndScreens'];
    if (roles is List) {
      for (final item in roles) {
        if (item is! Map) continue;
        if ('${item['roleId']}'.trim() != roleId) continue;
        final tree = item['treeResponse'];
        if (tree is Map) return Map<String, dynamic>.from(tree);
      }
    }
    final current = login['currentRole'];
    if (current is Map && '${current['roleId']}'.trim() == roleId) {
      final tree = current['treeResponse'];
      if (tree is Map) return Map<String, dynamic>.from(tree);
    }
    return null;
  }

  Future<SignedInOfficer?> cachedOfficer() => _officerStore.read();

  Future<PasswordResetCode> requestPasswordReset({
    required String email,
    required String employeeId,
  }) async {
    throw AuthApiException(
      'خادم FMC لا يرسل كود إعادة التعيين. غيّر كلمة المرور بعد تسجيل الدخول.',
    );
  }

  Future<void> verifyEmailCode({
    required String email,
    required String employeeId,
    required String code,
    String? recoveryToken,
  }) async {
    final userId = employeeId.trim();
    final pin = code.trim();
    if (pin.isEmpty) {
      throw AuthApiException('الكود غير صحيح أو انتهت صلاحيته');
    }
    await AppLoading.watch(() async {
      final result = await _client.post('fmc/auth/verify', {
        'userId': userId,
        'password': recoveryToken ?? '',
        'code': pin,
      });
      if (result is! Map) {
        throw AuthApiException('الكود غير صحيح أو انتهت صلاحيته');
      }
      final data = Map<String, dynamic>.from(result);
      final token = data['token'];
      if (token is! String || token.isEmpty) {
        throw AuthApiException('الكود غير صحيح أو انتهت صلاحيته');
      }
      _session
        ..token = token
        ..mcCode = data['mcCode'] == null
            ? _session.mcCode ?? '1'
            : '${data['mcCode']}'
        ..userId = userId;
      await _session.save();
    });
  }

  Future<void> signOut() {
    return AppLoading.watch(() async {
      try {
        await _client.put('auth/logout', const {});
      } catch (_) {}
      await _session.clear();
      await _clearUserCache();
    });
  }

  Future<void> _clearUserCache() async {
    await _officerStore.clear();
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    final images = PaintingBinding.instance.imageCache;
    images.clear();
    images.clearLiveImages();
  }

  /// FMC change-password body is `{userId, oldPw, newPw}`.
  Future<void> updatePassword(String password, {String? oldPassword}) async {
    final userId = _session.userId;
    if (userId == null || userId.isEmpty) {
      throw AuthApiException('سجّل الدخول أولاً لتغيير كلمة المرور');
    }
    await AppLoading.watch(() async {
      await _client.put('adminController/userPW/updatePassword', {
        'userId': userId,
        'oldPw': oldPassword ?? '',
        'newPw': password,
      });
      await _session.clear();
      await _officerStore.clear();
    });
  }

  Future<void> _saveOfficer(Map<String, dynamic> data, String userId) async {
    final employee = _text(data['usrId']);
    try {
      await _officerStore.save(
        SignedInOfficer(
          fullName: _firstText(data, const ['nameAr', 'nameEn']),
          employeeId: employee.isEmpty ? userId : employee,
          email: _firstText(data, const ['email', 'maskEmail']),
        ),
      );
    } catch (_) {}
  }

  Future<void> _loadOfficer() async {
    final userId = _session.userId ?? '';
    final existing = await _officerStore.read();
    Map<String, dynamic> profile = const {};
    try {
      final result = await _client.get(
        'adminController/users/employee/$userId',
      );
      profile = _firstMap(result) ?? const {};
    } catch (_) {}
    final name = _firstText(profile, const [
      'nameAr',
      'nameEn',
      'fullname',
      'fullName',
    ]);
    final email = _firstText(profile, const ['email', 'eMail', 'maskEmail']);
    final employee = _firstText(profile, const ['userId', 'usrId']);
    try {
      await _officerStore.save(
        SignedInOfficer(
          fullName: name.isEmpty ? (existing?.fullName ?? '') : name,
          employeeId: employee.isEmpty
              ? (existing?.employeeId ?? userId)
              : employee,
          email: email.isEmpty ? (existing?.email ?? '') : email,
        ),
      );
    } catch (_) {}
  }

  String _text(dynamic value) => value == null ? '' : '$value'.trim();

  List<FmcRole> _roles(dynamic value) {
    if (value is! List) return const [];
    final roles = <FmcRole>[];
    for (final item in value) {
      if (item is! Map) continue;
      final row = Map<String, dynamic>.from(item);
      final id = row['roleId'];
      if (id == null || '$id'.trim().isEmpty) continue;
      roles.add(
        FmcRole(
          id: '$id'.trim(),
          nameAr: '${row['roleNameAr'] ?? ''}',
          nameEn: '${row['roleNameEn'] ?? ''}',
        ),
      );
    }
    return roles;
  }

  Map<String, dynamic>? _firstMap(dynamic value) {
    if (value is List && value.isNotEmpty && value.first is Map) {
      return Map<String, dynamic>.from(value.first as Map);
    }
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  String _firstText(Map<String, dynamic> row, List<String> keys) {
    for (final key in keys) {
      final value = row[key];
      if (value == null) continue;
      final text = '$value'.trim();
      if (text.isNotEmpty) return text;
    }
    return '';
  }
}
