import 'package:loanofficer/core/api/fmc_client.dart';
import 'package:loanofficer/core/api/fmc_session.dart';

class OrgLookupItem {
  const OrgLookupItem({required this.code, required this.nameAr});

  final String code;
  final String nameAr;

  String get label => nameAr.isEmpty ? code : nameAr;
}

class EconomyParents {
  const EconomyParents({
    required this.code1,
    required this.name1,
    required this.code2,
    required this.name2,
    required this.code3,
    required this.name3,
  });

  final String code1;
  final String name1;
  final String code2;
  final String name2;
  final String code3;
  final String name3;
}

/// Fusion admin lookups used by add/edit organization (web org modal).
class OrganizationLookupsApi {
  OrganizationLookupsApi({FmcClient? client, FmcSession? session})
    : _client = client ?? FmcClient(),
      _session = session ?? FmcSession.instance;

  final FmcClient _client;
  final FmcSession _session;

  Future<List<OrgLookupItem>> orgTypes() =>
      _domain('CIF_ORG_TYPE');

  Future<List<OrgLookupItem>> placeTypes() =>
      _domain('CIF_ORG_PLACE_TYPE');

  Future<List<OrgLookupItem>> placeOwnerships() =>
      _domain('CIF_ORG_PLACE_OWNERSHIP');

  Future<List<OrgLookupItem>> companyCategories() =>
      _domain('COMPANY_CATEGORY');

  /// All sub-sectors (`GET adminController/economy/economy3`).
  Future<List<OrgLookupItem>> economy3() async {
    _ensureSignedIn();
    final result = await _client.get('adminController/economy/economy3');
    final list = _asList(result);
    final items = <OrgLookupItem>[];
    for (final item in list) {
      if (item is! Map) continue;
      final code = _text(
        item['codeId'] ?? item['codeId3'] ?? item['code'] ?? item['id'],
      );
      final name = _text(item['nameAr'] ?? item['nameEn'] ?? item['name']);
      if (code.isEmpty && name.isEmpty) continue;
      items.add(OrgLookupItem(code: code.isEmpty ? name : code, nameAr: name));
    }
    return items;
  }

  /// Parent sectors for a sub-sector (`economy3/enhanced?codeId3=`).
  Future<EconomyParents?> economy3Enhanced(String codeId3) async {
    _ensureSignedIn();
    final id = codeId3.trim();
    if (id.isEmpty) return null;
    final result = await _client.get(
      'adminController/economy/economy3/enhanced',
      query: {'codeId3': id},
    );
    Map<String, dynamic> map = const {};
    if (result is Map) {
      final nested = result['result'];
      if (nested is Map) {
        map = Map<String, dynamic>.from(nested);
      } else {
        map = Map<String, dynamic>.from(result);
      }
    }
    final code1 = _text(map['codeId1']);
    final code2 = _text(map['codeId2']);
    final code3 = _text(map['codeId3'] ?? map['codeId'] ?? id);
    if (code1.isEmpty && code2.isEmpty) return null;
    return EconomyParents(
      code1: code1,
      name1: _text(map['codeId1NameAr'] ?? map['codeId1NameEn']),
      code2: code2,
      name2: _text(map['codeId2NameAr'] ?? map['codeId2NameEn']),
      code3: code3,
      name3: _text(
        map['codeId3NameAr'] ??
            map['codeId_3NameAr'] ??
            map['nameAr'] ??
            map['codeId3NameEn'],
      ),
    );
  }

  Future<List<OrgLookupItem>> _domain(String catId) async {
    _ensureSignedIn();
    final result = await _client.get(
      'adminController/domainsUserData/byCatId/$catId',
    );
    final list = result is List ? result : const [];
    final items = <OrgLookupItem>[];
    for (final item in list) {
      if (item is! Map) continue;
      final code = _text(item['codeId'] ?? item['code'] ?? item['id']);
      final name = _text(item['nameAr'] ?? item['nameEn'] ?? item['name']);
      if (code.isEmpty && name.isEmpty) continue;
      items.add(OrgLookupItem(code: code.isEmpty ? name : code, nameAr: name));
    }
    return items;
  }

  void _ensureSignedIn() {
    if (!_session.isSignedIn) {
      throw StateError('بيانات الدخول غير صحيحة');
    }
  }

  static List<dynamic> _asList(dynamic result) {
    if (result is List) return result;
    if (result is Map) {
      for (final key in const ['result', 'data', 'content']) {
        final value = result[key];
        if (value is List) return value;
      }
    }
    return const [];
  }

  static String _text(dynamic value) => value == null ? '' : '$value'.trim();
}
