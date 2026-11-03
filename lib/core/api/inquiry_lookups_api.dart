import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fund_lookups_api.dart';
import 'package:loanofficer/core/api/fund_track_api.dart';
import 'package:loanofficer/core/api/fmc_client.dart';
import 'package:loanofficer/core/api/fmc_session.dart';

class InquiryOption<T> {
  const InquiryOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// Lookups for استعلام تمويل فردي advanced filter (FMC service-query modal).
class InquiryLookupsApi {
  InquiryLookupsApi({FmcClient? client, FmcSession? session})
    : _client = client ?? FmcClient(),
      _session = session ?? FmcSession.instance;

  final FmcClient _client;
  final FmcSession _session;

  Future<List<FundLookupItem>> fundStatuses() async {
    final list = await _getList('lookups/domainsSysData/SRV_STATUS');
    return [
      for (final map in list) FundLookupItem.fromMap(map),
    ];
  }

  Future<List<InquiryOption<String>>> productTypes() async {
    final list = await _getList('lookups/productsTypes');
    return [
      for (final map in list)
        InquiryOption<String>(
          value: '${map['prodType'] ?? ''}'.trim(),
          label: _name(map),
        ),
    ].where((e) => e.value.isNotEmpty).toList();
  }

  Future<List<InquiryOption<String>>> loanTypesByProduct(String prodType) async {
    if (prodType.trim().isEmpty) return const [];
    final list = await _getList('lookups/productsTypes/$prodType');
    return [
      for (final map in list)
        InquiryOption<String>(
          value: '${map['loanType'] ?? ''}'.trim(),
          label: _name(map),
        ),
    ].where((e) => e.value.isNotEmpty).toList();
  }

  Future<List<InquiryOption<int>>> branches() async {
    final list = await _getList('lookups/branch/getLovBranch');
    return [
      for (final map in list)
        InquiryOption<int>(
          value: _int(map['brcode'] ?? map['brCode']),
          label: _name(map, fallback: '${map['brcode']}'),
        ),
    ].where((e) => e.value > 0).toList();
  }

  Future<List<InquiryOption<String>>> regionalAreas() async {
    final result = await _client.get(
      'adminController/address/state',
      query: {'countryId': '1'},
    );
    final list = _asMaps(result);
    return [
      for (final map in list)
        InquiryOption<String>(
          value: '${map['stateId'] ?? map['id'] ?? ''}'.trim(),
          label: _name(map),
        ),
    ].where((e) => e.value.isNotEmpty).toList();
  }

  Future<List<BranchUser>> loanOfficersByBranch(int brcode) {
    return FundTrackApi(client: _client, session: _session)
        .usersByBranch(brcode);
  }

  Future<List<InquiryOption<String>>> yesNo() async => const [
    InquiryOption(value: 'Y', label: 'نعم'),
    InquiryOption(value: 'N', label: 'لا'),
  ];

  Future<List<Map<String, dynamic>>> _getList(String path) async {
    if (!_session.isSignedIn) throw AuthApiException('بيانات الدخول غير صحيحة');
    final result = await _client.get(path);
    return _asMaps(result);
  }

  static List<Map<String, dynamic>> _asMaps(dynamic result) {
    if (result is! List) return const [];
    return [
      for (final item in result)
        if (item is Map) Map<String, dynamic>.from(item),
    ];
  }

  static String _name(Map<String, dynamic> map, {String fallback = ''}) {
    final name =
        '${map['nameAr'] ?? map['nameEn'] ?? map['descrAr'] ?? map['descr'] ?? fallback}'
            .trim();
    return name.isEmpty ? fallback : name;
  }

  static int _int(dynamic raw) {
    if (raw is num) return raw.toInt();
    return int.tryParse('$raw') ?? 0;
  }
}
