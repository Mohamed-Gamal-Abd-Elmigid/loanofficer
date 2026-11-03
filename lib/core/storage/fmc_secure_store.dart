import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loanofficer/core/api/api_exception.dart';

/// Login session, selected privilege, and the Fusion responses, kept in
/// the device keychain.
class FmcSecureStore {
  FmcSecureStore({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.unlocked_this_device,
            ),
          );

  static final instance = FmcSecureStore();
  static const _key = 'fmc_auth_cache';

  final FlutterSecureStorage _storage;

  Future<Map<String, dynamic>> read() {
    return _guard(() async {
      final raw = await _storage.read(key: _key);
      return _decode(raw);
    });
  }

  /// Used at startup. A missing plugin must not block the splash screen.
  Future<Map<String, dynamic>> readQuiet() async {
    try {
      final raw = await _storage.read(key: _key);
      return _decode(raw);
    } catch (_) {
      return const {};
    }
  }

  Future<void> update(void Function(Map<String, dynamic> data) change) {
    return _guard(() async {
      final data = Map<String, dynamic>.from(
        _decode(await _storage.read(key: _key)),
      );
      change(data);
      await _storage.write(key: _key, value: jsonEncode(data));
    });
  }

  Future<void> clear() {
    return _guard(() => _storage.delete(key: _key));
  }

  Map<String, dynamic> _decode(String? raw) {
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return {};
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on MissingPluginException {
      throw AuthApiException('أعد تشغيل التطبيق بالكامل لحفظ الجلسة');
    } on PlatformException {
      throw AuthApiException('تعذر حفظ بيانات الدخول');
    }
  }
}
