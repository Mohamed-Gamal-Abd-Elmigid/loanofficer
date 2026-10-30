import 'dart:convert';

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
class FmcSession {
  FmcSession._();

  static final instance = FmcSession._();
  static const _key = 'fmc_session';

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
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_key);
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return;
      token = _text(decoded['token']);
      mcCode = _text(decoded['mcCode']);
      roleId = _text(decoded['roleId']);
      userId = _text(decoded['userId']);
    } catch (_) {}
  }

  Future<void> save() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _key,
      jsonEncode({
        'token': token,
        'mcCode': mcCode,
        'roleId': roleId,
        'userId': userId,
      }),
    );
  }

  Future<void> clear() async {
    token = null;
    mcCode = null;
    roleId = null;
    userId = null;
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_key);
  }

  String? _text(dynamic value) {
    if (value == null) return null;
    final text = '$value'.trim();
    return text.isEmpty ? null : text;
  }
}
