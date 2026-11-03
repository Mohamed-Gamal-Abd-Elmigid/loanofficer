import 'dart:convert';

import 'package:loanofficer/core/storage/fmc_secure_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FmcRole {
  const FmcRole({required this.id, required this.nameAr, required this.nameEn});

  final String id;
  final String nameAr;
  final String nameEn;

  String get label {
    if (nameAr.trim().isNotEmpty) return nameAr.trim();
    if (nameEn.trim().isNotEmpty) return nameEn.trim();
    return id;
  }
}

/// Token and selected role sent on every FMC request.
///
/// The token, the login body, and the privilege tree are stored in the
/// device keychain, not in plain preferences.
class FmcSession {
  FmcSession._({FmcSecureStore? store})
    : _store = store ?? FmcSecureStore.instance;

  static final instance = FmcSession._();
  static const _legacyKey = 'fmc_session';

  final FmcSecureStore _store;

  String? token;
  String? mcCode;
  String? roleId;
  String? userId;

  bool get isSignedIn =>
      token != null &&
      token!.isNotEmpty &&
      roleId != null &&
      roleId!.isNotEmpty;

  Future<void> restore() async {
    var cache = await _store.readQuiet();
    if (cache['session'] is! Map) {
      final moved = await _moveLegacySession();
      if (moved != null) cache = moved;
    }
    final session = cache['session'];
    if (session is! Map) return;
    token = _text(session['token']);
    mcCode = _text(session['mcCode']);
    roleId = _text(session['roleId']);
    userId = _text(session['userId']);
  }

  Future<void> save() {
    return _store.update((cache) {
      cache['session'] = {
        'token': token,
        'mcCode': mcCode,
        'roleId': roleId,
        'userId': userId,
      };
    });
  }

  /// Replaces the cached login body and clears a previous privilege choice.
  Future<void> saveLogin(Map<String, dynamic> login) {
    return _store.update((cache) {
      cache['login'] = login;
      cache.remove('treeApi');
      cache.remove('roleTree');
      cache.remove('selectedRoleId');
      cache['session'] = {
        'token': token,
        'mcCode': mcCode,
        'roleId': roleId,
        'userId': userId,
      };
    });
  }

  Future<Map<String, dynamic>?> readLogin() async {
    final login = (await _store.read())['login'];
    if (login is Map) return Map<String, dynamic>.from(login);
    return null;
  }

  /// Caches the tree call and the role tree Fusion keeps after a privilege
  /// is chosen.
  Future<void> saveRoleSelection({
    required String roleId,
    required dynamic treeApi,
    required Map<String, dynamic> roleTree,
  }) {
    this.roleId = roleId;
    return _store.update((cache) {
      cache['treeApi'] = _encodable(treeApi);
      cache['roleTree'] = roleTree;
      cache['selectedRoleId'] = roleId;
      cache['session'] = {
        'token': token,
        'mcCode': mcCode,
        'roleId': roleId,
        'userId': userId,
      };
    });
  }

  Future<void> clear() async {
    token = null;
    mcCode = null;
    roleId = null;
    userId = null;
    try {
      await _store.clear();
    } catch (_) {}
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_legacyKey);
  }

  Future<Map<String, dynamic>?> _moveLegacySession() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_legacyKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      final cache = {'session': Map<String, dynamic>.from(decoded)};
      await _store.update((data) => data.addAll(cache));
      await preferences.remove(_legacyKey);
      return cache;
    } catch (_) {
      return null;
    }
  }

  dynamic _encodable(dynamic value) {
    if (value == null || value is String || value is num || value is bool) {
      return value;
    }
    try {
      return jsonDecode(jsonEncode(value));
    } catch (_) {
      return '$value';
    }
  }

  String? _text(dynamic value) {
    if (value == null) return null;
    final text = '$value'.trim();
    return text.isEmpty ? null : text;
  }
}
