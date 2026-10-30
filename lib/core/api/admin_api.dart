import 'package:loanofficer/core/api/auth_api.dart';
import 'package:loanofficer/core/api/fmc_client.dart';
import 'package:loanofficer/core/api/fmc_session.dart';
import 'package:loanofficer/core/components/app_loading.dart';
import 'package:loanofficer/core/validation/app_validators.dart';

class OfficerAccount {
  const OfficerAccount({
    required this.id,
    required this.employeeId,
    required this.email,
    required this.fullName,
  });

  final String id;
  final String employeeId;
  final String email;
  final String fullName;
}

class AdminApi {
  AdminApi({FmcClient? client, FmcSession? session})
    : _client = client ?? FmcClient(),
      _session = session ?? FmcSession.instance;

  final FmcClient _client;
  final FmcSession _session;

  Future<void> login({required String userId, required String password}) async {
    final roles = await AuthApi(
      client: _client,
      session: _session,
    ).login(employeeId: userId, password: password);
    if (roles.isEmpty) return;
    await AuthApi(client: _client, session: _session).selectRole(roles.first);
  }

  Future<bool> isCurrentUserAdmin() async {
    await _session.restore();
    return _session.isSignedIn;
  }

  Future<void> createOfficer({
    required String employeeId,
    required String email,
    required String fullName,
    required String password,
  }) async {
    if (!AppValidators.isTanmeyahEmail(email)) {
      throw AuthApiException(AppValidators.emailMessage);
    }
    await AppLoading.watch(() async {
      await _client.post('adminController/users', {
        'nameAr': fullName.trim(),
        'nameEn': fullName.trim(),
        'userId': employeeId.trim(),
        'email': email.trim(),
        'userType': 'EMP',
        'activeFlag': 'Y',
        'blocked': 'N',
        'superUser': 'N',
      });
    });
  }

  Future<void> updateOfficer({
    required String id,
    required String employeeId,
    required String email,
    required String fullName,
    String? password,
  }) async {
    if (!AppValidators.isTanmeyahEmail(email)) {
      throw AuthApiException(AppValidators.emailMessage);
    }
    await AppLoading.watch(() async {
      await _client.put('adminController/users', {
        'usrno': id,
        'userId': employeeId.trim(),
        'nameAr': fullName.trim(),
        'nameEn': fullName.trim(),
        'email': email.trim(),
        'userType': 'EMP',
      });
    });
  }

  Future<void> deleteOfficer(String id) {
    return AppLoading.watch(() => _client.delete('adminController/users/$id'));
  }

  Future<List<OfficerAccount>> listOfficers() {
    return AppLoading.watch(() async {
      final result = await _client.get(
        'adminController/users/allAdminUser',
        query: const {'size': '1000000'},
      );
      return _rows(result).map(_account).toList();
    });
  }

  Future<void> signOut() =>
      AuthApi(client: _client, session: _session).signOut();

  List<Map<String, dynamic>> _rows(dynamic result) {
    if (result is List) {
      return [
        for (final row in result)
          if (row is Map) Map<String, dynamic>.from(row),
      ];
    }
    if (result is Map) {
      for (final key in ['content', 'data', 'users', 'items', 'records']) {
        final value = result[key];
        if (value is List) return _rows(value);
      }
    }
    return const [];
  }

  OfficerAccount _account(Map<String, dynamic> row) {
    final nameAr = '${row['nameAr'] ?? ''}'.trim();
    final nameEn = '${row['nameEn'] ?? ''}'.trim();
    return OfficerAccount(
      id: '${row['usrno'] ?? row['id'] ?? ''}',
      employeeId: '${row['userId'] ?? row['employeeId'] ?? ''}',
      email: '${row['email'] ?? ''}',
      fullName: nameAr.isNotEmpty ? nameAr : nameEn,
    );
  }
}
