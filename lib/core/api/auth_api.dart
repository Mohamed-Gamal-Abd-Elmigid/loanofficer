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
  /// Returns the roles the user still has to choose. An empty list means the
  /// only role was selected already.
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
    final roles = _roles(data['availableRoleAndScreens']);
    if (roles.isEmpty) {
      throw AuthApiException('هذا المستخدم ليس لديه أي صلاحيات');
    }
    _session
      ..token = token
      ..mcCode = data['mcCode'] == null ? '1' : '${data['mcCode']}'
      ..userId = userId
      ..roleId = null;
    await _session.save();
    if (roles.length == 1) {
      await _selectRole(roles.first);
      return const [];
    }
    return roles;
  }

  Future<void> selectRole(FmcRole role) {
    return AppLoading.watch(() => _selectRole(role));
  }

  Future<void> _selectRole(FmcRole role) async {
    await _client.get('lookups/users/treeOfpages', query: {'roleId': role.id});
    _session.roleId = role.id;
    await _session.save();
    await _loadOfficer();
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

  Future<void> _loadOfficer() async {
    final userId = _session.userId ?? '';
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
    final employee = _firstText(profile, const ['userId']);
    try {
      await _officerStore.save(
        SignedInOfficer(
          fullName: name,
          employeeId: employee.isEmpty ? userId : employee,
          email: email,
        ),
      );
    } catch (_) {}
  }

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
