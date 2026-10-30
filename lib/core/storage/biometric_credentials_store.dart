import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loanofficer/core/api/api_exception.dart';

class BiometricCredentials {
  const BiometricCredentials({
    required this.employeeId,
    required this.password,
  });

  final String employeeId;
  final String password;
}

class BiometricCredentialsStore {
  BiometricCredentialsStore({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.unlocked_this_device,
            ),
          );

  static const _idKey = 'biometric_employee_id';
  static const _passwordKey = 'biometric_password';

  final FlutterSecureStorage _storage;

  Future<bool> hasCredentials() async {
    final credentials = await read();
    return credentials != null;
  }

  Future<void> save({required String employeeId, required String password}) {
    return _guard(() async {
      await _storage.write(key: _idKey, value: employeeId.trim());
      await _storage.write(key: _passwordKey, value: password);
    });
  }

  Future<BiometricCredentials?> read() {
    return _guard(() async {
      final employeeId = await _storage.read(key: _idKey);
      final password = await _storage.read(key: _passwordKey);
      if (employeeId == null ||
          employeeId.isEmpty ||
          password == null ||
          password.isEmpty) {
        return null;
      }
      return BiometricCredentials(employeeId: employeeId, password: password);
    });
  }

  Future<void> clear() {
    return _guard(() async {
      await _storage.delete(key: _idKey);
      await _storage.delete(key: _passwordKey);
    });
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on MissingPluginException {
      throw AuthApiException('أعد تشغيل التطبيق بالكامل لتفعيل البصمة');
    } on PlatformException {
      throw AuthApiException('تعذر حفظ بيانات البصمة');
    }
  }
}
