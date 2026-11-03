import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fmc_client.dart';
import 'package:loanofficer/core/api/fmc_session.dart';

/// Fusion application lookups used on fund-personal tabs.
class FundLookupsApi {
  FundLookupsApi({FmcClient? client, FmcSession? session})
    : _client = client ?? FmcClient(),
      _session = session ?? FmcSession.instance;

  final FmcClient _client;
  final FmcSession _session;

  Future<List<FundLookupItem>> grantorRelations() =>
      _lookupList('adminController/domainsUserData/byCatId/CUST_RELATION_TYPE');

  Future<List<FundLookupItem>> grantorOrderSeq() =>
      _lookupList('lookups/domainsSysData/SEQ');

  Future<List<FundLookupItem>> refuseReasons() =>
      _lookupList('lookups/domainsSysData/WF_ITEMS_REJECTED');

  Future<List<FundLookupItem>> refuseStatus() =>
      _lookupList('lookups/domainsSysData/WF_REJECT_STATUS');

  Future<List<FundLookupItem>> productsDocs({
    required String layerCode,
    required String loanType,
    required String prodType,
  }) async {
    if (!_session.isSignedIn) throw AuthApiException('بيانات الدخول غير صحيحة');
    final result = await _client.get(
      'lookups/productsDocs',
      query: {
        'layerCode': layerCode,
        'loanType': loanType,
        'prodType': prodType,
      },
    );
    return _parseItems(result);
  }

  Future<List<FundLookupItem>> _lookupList(String path) async {
    if (!_session.isSignedIn) throw AuthApiException('بيانات الدخول غير صحيحة');
    final result = await _client.get(path);
    return _parseItems(result);
  }

  static List<FundLookupItem> _parseItems(dynamic result) {
    if (result is! List) return const [];
    return result
        .whereType<Map>()
        .map((e) => FundLookupItem.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }
}

class FundLookupItem {
  const FundLookupItem({required this.code, required this.nameAr});

  final String code;
  final String nameAr;

  factory FundLookupItem.fromMap(Map<String, dynamic> map) {
    final code = '${map['codeId'] ?? map['code'] ?? map['id'] ?? ''}'.trim();
    final name = '${map['nameAr'] ?? map['nameEn'] ?? map['name'] ?? code}'
        .trim();
    return FundLookupItem(code: code, nameAr: name.isEmpty ? code : name);
  }
}
