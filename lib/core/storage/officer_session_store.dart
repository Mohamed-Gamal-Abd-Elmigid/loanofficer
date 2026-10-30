import 'dart:convert';

import 'package:loanofficer/core/models/signed_in_officer.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Officer profile from login, kept for offline UI (e.g. More screen).
class OfficerSessionStore {
  static const _profileKey = 'officer_profile';

  Future<void> save(SignedInOfficer officer) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_profileKey, jsonEncode(officer.toJson()));
  }

  Future<SignedInOfficer?> read() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_profileKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      return SignedInOfficer.fromJson(Map<String, dynamic>.from(decoded));
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_profileKey);
  }
}
