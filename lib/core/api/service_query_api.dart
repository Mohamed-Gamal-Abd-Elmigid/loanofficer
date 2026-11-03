import 'dart:convert';
import 'dart:typed_data';

import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fmc_client.dart';
import 'package:loanofficer/core/api/fmc_session.dart';
import 'package:loanofficer/core/api/personal_fund_api.dart';
import 'package:loanofficer/core/components/app_loading.dart';

/// Fusion «استعلام تمويل فردي» tiered-menu APIs (`ServiceQueryService` on web).
class ServiceQueryApi {
  ServiceQueryApi({FmcClient? client, FmcSession? session})
      : _client = client ?? FmcClient(),
        _session = session ?? FmcSession.instance;

  final FmcClient _client;
  final FmcSession _session;

  Future<List<Map<String, dynamic>>> premiums({
    required int status,
    required String serviceId,
  }) {
    return _getList(_premiumsPath(status), {'serviceId': serviceId.trim()});
  }

  Future<List<Map<String, dynamic>>> penalties({
    required int status,
    required String serviceId,
  }) {
    return _getList(_penaltyPath(status), {'serviceId': serviceId.trim()});
  }

  Future<List<Map<String, dynamic>>> grantors({
    required int status,
    required String serviceId,
  }) async {
    final result = await _get(_grantorsPath(status), {'serviceId': serviceId.trim()});
    if (result is Map && result['data'] is List) {
      return _maps(result['data']);
    }
    return _maps(result);
  }

  Future<Map<String, dynamic>> customerAccountStatement({
    required String custNo,
    required String prodType,
  }) async {
    return _getMap('query/glCustomerStatement', {
      'custNo': custNo.trim(),
      'prodType': prodType.trim(),
    });
  }

  Future<List<Map<String, dynamic>>> serviceDocuments({
    required String serviceId,
  }) async {
    final map = await _getMap('query/docs/service', {
      'serviceId': serviceId.trim(),
    });
    return _maps(map['docs']);
  }

  Future<Map<String, dynamic>> microFinancialStudy({
    required String custNo,
    required String serviceId,
  }) async {
    final list = await _getList('query/service/microFinancialStudy', {
      'custNo': custNo.trim(),
      'serviceId': serviceId.trim(),
    });
    if (list.isEmpty) return const {};
    return list.first;
  }

  Future<Map<String, dynamic>> customerBasic(String idno) async {
    final result = await _get('cif/customersBasic/${idno.trim()}', null);
    if (result is Map<String, dynamic>) return result;
    if (result is Map) return Map<String, dynamic>.from(result);
    final list = _maps(result);
    if (list.isNotEmpty) return list.first;
    return const {};
  }

  /// FMC guarantor / customer inquiry (`query/customer?idno=`).
  Future<dynamic> customerQuery(String idno) {
    return _get('query/customer', {'idno': idno.trim()});
  }

  Future<Uint8List> downloadServiceDocument(String seq) async {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      final result = await _client.get(
        'query/docs/service/getDoc',
        query: {'seq': seq.trim()},
      );
      final base64 = PersonalFundApi.documentDownloadBase64(result);
      if (base64 == null || base64.isEmpty) {
        throw AuthApiException('لا يوجد ملف للعرض');
      }
      try {
        return Uint8List.fromList(
          base64Decode(PersonalFundApi.normalizeDocumentBase64(base64)),
        );
      } on FormatException {
        throw AuthApiException('تعذر قراءة الملف');
      }
    });
  }

  String _premiumsPath(int status) {
    if ([70, 80, 81, 71].contains(status)) return 'query/writeOff/premiumsData';
    if ([50, 60, -1].contains(status)) return 'query/closed/premiumsData';
    return 'query/premiumsData';
  }

  String _penaltyPath(int status) {
    if ([70, 80, 81, 71].contains(status)) return 'query/writeOff/penalty';
    if ([50, 60, -1].contains(status)) return 'query/closed/penalty';
    return 'query/penalty';
  }

  String _grantorsPath(int status) {
    if ([70, 80, 81, 71].contains(status)) {
      return 'query/service/writeOff/grantors';
    }
    if ([50, 60, -1].contains(status)) {
      return 'query/service/closed/grantors';
    }
    return 'query/service/grantors';
  }

  Future<List<Map<String, dynamic>>> _getList(
    String path,
    Map<String, String>? query,
  ) async {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      final result = await _client.get(path, query: query);
      return _maps(result);
    });
  }

  Future<dynamic> _get(String path, Map<String, String>? query) async {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      return _client.get(path, query: query);
    });
  }

  Future<Map<String, dynamic>> _getMap(
    String path,
    Map<String, String>? query,
  ) async {
    final result = await _get(path, query);
    if (result is Map<String, dynamic>) return result;
    if (result is Map) return Map<String, dynamic>.from(result);
    return const {};
  }

  void _ensureSignedIn() {
    if (!_session.isSignedIn) {
      throw AuthApiException('بيانات الدخول غير صحيحة');
    }
  }

  static List<Map<String, dynamic>> _maps(dynamic raw) {
    if (raw is List) {
      return [
        for (final item in raw)
          if (item is Map) Map<String, dynamic>.from(item),
      ];
    }
    if (raw is Map) {
      for (final key in const ['data', 'content', 'result', 'rows']) {
        final nested = raw[key];
        if (nested is List) return _maps(nested);
      }
    }
    return const [];
  }
}
