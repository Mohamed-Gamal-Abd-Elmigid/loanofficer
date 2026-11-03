import 'dart:convert';
import 'dart:typed_data';

import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fmc_client.dart';
import 'package:loanofficer/core/api/fmc_session.dart';
import 'package:loanofficer/core/components/app_loading.dart';
import 'package:loanofficer/presenter/fund_track/model/personal_fund_documents_bundle.dart';

/// Personal fund view/edit APIs (Fusion `fund-personal` screen).
class PersonalFundApi {
  PersonalFundApi({FmcClient? client, FmcSession? session})
    : _client = client ?? FmcClient(),
      _session = session ?? FmcSession.instance;

  final FmcClient _client;
  final FmcSession _session;

  Future<Map<String, dynamic>> fundByServiceId(String serviceId) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      final result = await _client.get(
        'query/service/getByServiceId/${serviceId.trim()}',
      );
      return _asMap(result);
    });
  }

  Future<Map<String, dynamic>> stepAuthority({
    required String wfCode,
    required String stepId,
  }) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      final result = await _client.get(
        'wf/${Uri.encodeComponent(wfCode)}/step/${Uri.encodeComponent(stepId)}/authority',
      );
      return _asMap(result);
    });
  }

  Future<List<Map<String, dynamic>>> personalGrantors(String serviceId) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      final result = await _client.get(
        'wf/grantors/${serviceId.trim()}',
      );
      return _dataList(result);
    });
  }

  Future<List<Map<String, dynamic>>> inkindGuarantees(String custno) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      final result = await _client.get(
        'wf/guarantees/${custno.trim()}',
      );
      return _dataList(result);
    });
  }

  Future<PersonalFundDocumentsBundle> stageDocuments({
    required String serviceId,
    required String loanType,
    required String prodType,
    required String stepId,
  }) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      final result = await _client.get(
        'wf/micofin/documents/allDocs',
        query: {
          'serviceId': serviceId,
          'loanType': loanType,
          'prodType': prodType,
          'seq': stepId,
        },
      );
      return PersonalFundDocumentsBundle.fromDynamic(result);
    });
  }

  Future<void> updateGrantors({
    required String serviceId,
    required List<Map<String, dynamic>> data,
  }) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      await _client.put('wf/grantors', {
        'serviceId': serviceId,
        'data': data,
      });
    });
  }

  Future<void> updateRejection({
    required String ticketId,
    required List<Map<String, dynamic>> data,
  }) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      await _client.put('wf/rejection', {
        'ticketId': ticketId,
        'data': data,
      });
    });
  }

  Future<List<Map<String, dynamic>>> rejectionReasons(String ticketId) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      final result = await _client.get(
        'wf/rejection/${ticketId.trim()}',
      );
      if (result is List) {
        return result
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
      return const [];
    });
  }

  Future<Map<String, dynamic>> followUp(String serviceId) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      final result = await _client.get(
        'wf/additionalData',
        query: {'serviceId': serviceId.trim()},
      );
      return _asMap(result);
    });
  }

  Future<Map<String, dynamic>> personalFieldVisit({
    required String custno,
    required String serviceId,
  }) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      final result = await _client.get(
        'wf/micro/visits/cust',
        query: {'custno': custno, 'serviceId': serviceId},
      );
      return _asMap(result);
    });
  }

  Future<Map<String, dynamic>> grantorVisits(String serviceId) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      final result = await _client.get(
        'wf/micro/visits/grantors',
        query: {'serviceId': serviceId.trim()},
      );
      return _asMap(result);
    });
  }

  Future<Map<String, dynamic>> segmentation(String serviceId) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      final result = await _client.get(
        'fundSegments/micro/segments/${serviceId.trim()}',
      );
      return _asMap(result);
    });
  }

  /// Web `wf/micofin/request/save` (constructPayload + saveOnly).
  Future<void> savePersonalRequest(Map<String, dynamic> payload) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      await _client.post('wf/micofin/request/save', payload);
    });
  }

  Future<void> wfActionSave(Map<String, dynamic> payload) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      await _client.post('wf/action/save', payload);
    });
  }

  Future<void> wfActionApprove(Map<String, dynamic> payload) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      await _client.post('wf/action/approve', payload);
    });
  }

  Future<void> wfActionRefuse(Map<String, dynamic> payload) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      await _client.post('wf/action/refuse', payload);
    });
  }

  Future<void> wfActionReject(Map<String, dynamic> payload) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      await _client.post('wf/action/reject', payload);
    });
  }

  Future<void> wfActionCancel(Map<String, dynamic> payload) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      await _client.post('wf/action/cancel', payload);
    });
  }

  /// Web «تحويل الطلب لمرحلة معينة» (`wf/action/refusedSteps`).
  Future<void> wfRefusedSteps(Map<String, dynamic> payload) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      await _client.post('wf/action/refusedSteps', payload);
    });
  }

  Future<void> updateGuarantees({
    required String custno,
    required List<Map<String, dynamic>> data,
  }) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      await _client.put('wf/guarantees', {
        'custno': custno,
        'data': data,
      });
    });
  }

  /// Web `cifService.getOrganizationByIdno` — list of orgs for applicant.
  Future<List<Map<String, dynamic>>> organizationsByIdno(String idno) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      final result = await _client.get(
        'cif/organizations',
        query: {'idno': idno.trim()},
      );
      if (result is Map) {
        final nested = result['result'];
        if (nested is List) return _dataList({'data': nested});
      }
      return _dataList(result);
    });
  }

  /// Create-request flow — orgs linked to national ID
  /// (`GET cif/organizations/cust/{idNo}`).
  Future<List<Map<String, dynamic>>> organizationsByCustNationalId(
    String nationalId,
  ) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      final id = nationalId.trim();
      final result = await _client.get('cif/organizations/cust/$id');
      if (result is Map) {
        final nested = result['result'];
        if (nested is List) return _dataList({'data': nested});
      }
      return _dataList(result);
    });
  }

  /// Web org modal — full organization record (`GET cif/organizations/{orgId}`).
  Future<Map<String, dynamic>> organizationById(String orgId) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      final id = orgId.trim();
      final result = await _client.get('cif/organizations/$id');
      if (result is Map<String, dynamic>) return result;
      if (result is Map) return Map<String, dynamic>.from(result);
      return const {};
    });
  }

  /// Partners tab — try dedicated endpoint, else use `cifCustOrgPartners` on detail.
  Future<List<Map<String, dynamic>>> organizationPartners(String orgId) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      final id = orgId.trim();
      try {
        final result = await _client.get(
          'cif/cifCustOrgPartners',
          query: {'orgId': id},
        );
        final list = _dataList(result);
        if (list.isNotEmpty) return list;
      } catch (_) {}
      return const [];
    });
  }

  /// Web org edit modal — `PUT cif/organizations`.
  Future<void> saveOrganization({
    required Map<String, String> values,
    required List<Map<String, String>> partners,
  }) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      final body = organizationSaveBody(values: values, partners: partners);
      await _client.put('cif/organizations', body);
    });
  }

  /// Payload shape matching Fusion org edit (`PUT cif/organizations`).
  static Map<String, dynamic> organizationSaveBody({
    required Map<String, String> values,
    required List<Map<String, String>> partners,
  }) {
    Object? code(String? raw) {
      final text = (raw ?? '').trim();
      if (text.isEmpty) return null;
      return int.tryParse(text) ?? text;
    }

    String? textOrNull(String? raw) {
      final text = (raw ?? '').trim();
      return text.isEmpty ? null : text;
    }

    Object? nationCodeFor(String? raw) {
      final text = (raw ?? '').trim();
      if (text.isEmpty || text == 'مصري' || text == 'مصرى') return 1;
      return code(text) ?? 1;
    }

    final addTxt = textOrNull(values['addTxt'] ?? values['address']);
    final street = textOrNull(values['street']);
    final building = textOrNull(values['buildingNo']);
    final floor = code(values['floorNo']);
    final flat = code(values['flatno']);

    return {
      'ticketId': -99,
      'address': {
        'addMark': textOrNull(values['addMark']),
        'addTxt': addTxt,
        'buildingNo': building,
        'regionId': code(values['regionId']) ?? 1,
        'cityCode': code(values['cityCode']),
        'countryCode': code(values['countryCode']) ?? 1,
        'flatno': flat,
        'floorNo': floor,
        'postCode': textOrNull(values['postCode']),
        'stateCode': code(values['stateCode']),
        'street': street,
        'villageCode': code(values['villageCode']),
      },
      'cifCustOrgPartners': [
        for (final partner in partners)
          if ((partner['partnerName'] ?? '').trim().isNotEmpty ||
              (partner['partnerId'] ?? '').trim().isNotEmpty)
            {
              'idno': textOrNull(partner['partnerId']),
              'name': textOrNull(partner['partnerName']),
              'nationCode': nationCodeFor(partner['partnerNationality']),
              'orgId': null,
              'partnerRatio': code(partner['partnerShare']),
              'partnerAmt': code(partner['partnerValue']),
              'role': textOrNull(partner['partnerRole']),
              'bod': textOrNull(partner['partnerBirth']),
            },
      ],
      'contactName': textOrNull(values['contactName']),
      'contactPhone': textOrNull(
        (values['contactPhone'] ?? '').trim().isNotEmpty
            ? values['contactPhone']
            : values['phone'],
      ),
      'countEmployees': code(values['countEmployees']) ?? 0,
      'custIdno': textOrNull(values['custIdno']),
      'placeType': textOrNull(values['placeType']) ??
          textOrNull(values['placeTypeCode']),
      'placeOwnership': textOrNull(values['placeOwnership']) ??
          textOrNull(values['placeOwnershipCode']),
      'placeNoOfYears': textOrNull(values['placeNoOfYears']),
      'econCode1': code(values['econCode1']),
      'econCode2': code(values['econCode2']),
      'econCode3': code(values['econCode3']),
      'orgCapital': code(values['orgCapital']) ?? 0,
      'orgId': code(values['orgId']),
      'orgName': textOrNull(values['name'] ?? values['orgName']),
      'orgDescr': textOrNull(values['orgDescr'] ?? values['activity']),
      'contactEmail': textOrNull(values['contactEmail']),
      'orgType': code(values['orgType']) ?? 1,
      'phone1': textOrNull(values['phone1']),
      'phone2': textOrNull(values['phone2']),
      'practiceStartDate': textOrNull(
        (values['practiceStartDate'] ?? '').trim().isNotEmpty
            ? values['practiceStartDate']
            : values['foundingDate'],
      ),
      'regExpDate': textOrNull(values['regExpDate']),
      'regIssueDate': textOrNull(values['regIssueDate']),
      'regNo': textOrNull(
        (values['regNo'] ?? '').trim().isNotEmpty
            ? values['regNo']
            : values['registerNumber'],
      ),
      'taxFileNo': textOrNull(values['taxFileNo']),
      'companyCategory': textOrNull(values['companyCategory']),
      'email': textOrNull(values['email']),
    };
  }

  /// Inquiry org VIEW: parallel fetch (list + detail + partners).
  /// FMC modal (`showOrgModal`) loads via `FinancialPoliciesService.getOneOrg`
  /// (`GET cif/organizations/{orgId}`) with partners on the same payload; extra
  /// calls mirror common network traces and keep list data available if needed.
  ///
  /// Org APIs often return raw codes (`orgType: 1`, `econCode1: 3`, …). The web
  /// maps those through lookups into Arabic labels — we enrich the same way.
  Future<OrganizationInquiryBundle> organizationInquiry({
    required String idno,
    required String orgId,
  }) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      final id = orgId.trim();
      final idnoTrim = idno.trim();
      final results = await Future.wait<dynamic>([
        _client.get('cif/organizations', query: {'idno': idnoTrim}),
        _client.get('cif/organizations/$id'),
        _client.get('cif/cifCustOrgPartners', query: {'orgId': id}).catchError(
          (_) => null,
        ),
      ]);
      final list = _dataList(results[0]);
      final detailRaw = results[1];
      var detail = detailRaw is Map
          ? Map<String, dynamic>.from(detailRaw)
          : <String, dynamic>{};
      if (detail.isNotEmpty) {
        detail = await _enrichOrganizationLabels(detail);
      }
      var partners = _dataList(results[2]);
      if (partners.isEmpty) {
        final embedded = detail['cifCustOrgPartners'];
        if (embedded is List) {
          partners = [
            for (final item in embedded)
              if (item is Map) Map<String, dynamic>.from(item),
          ];
        }
      }
      return OrganizationInquiryBundle(
        organizations: list,
        detail: detail,
        partners: partners,
      );
    });
  }

  /// Resolve code fields to Arabic `*Descr` / `*Name` keys (web dropdown labels).
  Future<Map<String, dynamic>> _enrichOrganizationLabels(
    Map<String, dynamic> detail,
  ) async {
    final out = Map<String, dynamic>.from(detail);
    final orgType = _text(detail['orgType']);
    final placeType = _text(detail['placeType']);
    final placeOwnership = _text(detail['placeOwnership']);
    final econCode3 = _text(detail['econCode3']);
    final address = detail['address'] is Map
        ? Map<String, dynamic>.from(detail['address'] as Map)
        : <String, dynamic>{};

    final futures = <Future<void>>[
      if (orgType.isNotEmpty && _text(detail['orgTypeDescr']).isEmpty)
        _domainName('CIF_ORG_TYPE', orgType).then((name) {
          if (name.isNotEmpty) out['orgTypeDescr'] = name;
        }),
      if (placeType.isNotEmpty && _text(detail['placeTypeDescr']).isEmpty)
        _domainName('CIF_ORG_PLACE_TYPE', placeType).then((name) {
          if (name.isNotEmpty) out['placeTypeDescr'] = name;
        }),
      if (placeOwnership.isNotEmpty &&
          _text(detail['placeOwnershipDescr']).isEmpty)
        _domainName('CIF_ORG_PLACE_OWNERSHIP', placeOwnership).then((name) {
          if (name.isNotEmpty) out['placeOwnershipDescr'] = name;
        }),
      if (econCode3.isNotEmpty)
        _economyLabels(econCode3).then((labels) {
          if (labels.$1.isNotEmpty && _text(out['econCode1Descr']).isEmpty) {
            out['econCode1Descr'] = labels.$1;
          }
          if (labels.$2.isNotEmpty && _text(out['econCode2Descr']).isEmpty) {
            out['econCode2Descr'] = labels.$2;
          }
          if (labels.$3.isNotEmpty && _text(out['econCode3Descr']).isEmpty) {
            out['econCode3Descr'] = labels.$3;
          }
        }),
      if (address.isNotEmpty) _enrichAddressNames(address),
    ];
    await Future.wait(futures);
    if (address.isNotEmpty) out['address'] = address;
    return out;
  }

  Future<String> _domainName(String catId, String code) async {
    try {
      final result = await _client.get(
        'adminController/domainsUserData/byCatId/$catId',
      );
      final list = result is List ? result : const [];
      for (final item in list) {
        if (item is! Map) continue;
        final id = _text(item['codeId'] ?? item['code'] ?? item['id']);
        if (id != code) continue;
        final name = _text(item['nameAr'] ?? item['nameEn'] ?? item['name']);
        if (name.isNotEmpty) return name;
      }
    } catch (_) {}
    return '';
  }

  /// Web: `economy/economy3/enhanced?codeId3=` → parent sector names.
  Future<(String, String, String)> _economyLabels(String codeId3) async {
    try {
      final result = await _client.get(
        'adminController/economy/economy3/enhanced',
        query: {'codeId3': codeId3},
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
      return (
        _text(map['codeId1NameAr'] ?? map['codeId1NameEn']),
        _text(map['codeId2NameAr'] ?? map['codeId2NameEn']),
        _text(
          map['codeId3NameAr'] ??
              map['codeId_3NameAr'] ??
              map['nameAr'] ??
              map['codeId3NameEn'],
        ),
      );
    } catch (_) {
      return ('', '', '');
    }
  }

  Future<void> _enrichAddressNames(Map<String, dynamic> address) async {
    final stateCode = _text(address['stateCode'] ?? address['stateId']);
    final cityCode = _text(address['cityCode'] ?? address['cityId']);
    final villageCode = _text(address['villageCode'] ?? address['villageId']);
    final regionId = _text(address['regionId']);
    final countryId = _text(address['countryCode'] ?? address['countryId']);
    final country = countryId.isEmpty ? '1' : countryId;

    if (stateCode.isNotEmpty && _text(address['stateName']).isEmpty) {
      try {
        final states = await _client.get(
          'adminController/address/state',
          query: {'countryId': country},
        );
        final name = _placeName(states, stateCode, const ['stateId', 'id']);
        if (name.isNotEmpty) address['stateName'] = name;
      } catch (_) {}
    }

    if (cityCode.isNotEmpty &&
        stateCode.isNotEmpty &&
        _text(address['cityName']).isEmpty) {
      try {
        final cities = await _client.get(
          'adminController/address/city',
          query: {
            'regionId': regionId,
            'countryId': country,
            'stateId': stateCode,
          },
        );
        final name = _placeName(cities, cityCode, const ['cityId', 'id']);
        if (name.isNotEmpty) address['cityName'] = name;
      } catch (_) {}
    }

    if (villageCode.isNotEmpty && _text(address['villageName']).isEmpty) {
      try {
        final one = await _client.get(
          'adminController/address/village/$villageCode',
        );
        if (one is Map) {
          final name = _text(one['nameAr'] ?? one['nameEn'] ?? one['name']);
          if (name.isNotEmpty) address['villageName'] = name;
        } else if (cityCode.isNotEmpty && stateCode.isNotEmpty) {
          final villages = await _client.get(
            'adminController/address/village',
            query: {
              'regionId': regionId,
              'countryId': country,
              'stateId': stateCode,
              'cityId': cityCode,
            },
          );
          final name = _placeName(
            villages,
            villageCode,
            const ['villageId', 'id', 'seqId'],
          );
          if (name.isNotEmpty) address['villageName'] = name;
        }
      } catch (_) {}
    }
  }

  static String _placeName(
    dynamic list,
    String code,
    List<String> idKeys,
  ) {
    if (list is! List) return '';
    for (final item in list) {
      if (item is! Map) continue;
      for (final key in idKeys) {
        if (_text(item[key]) != code) continue;
        return _text(item['nameAr'] ?? item['nameEn'] ?? item['name']);
      }
    }
    return '';
  }

  static String _text(dynamic value) {
    if (value == null) return '';
    final text = '$value'.trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return '';
    return text;
  }

  /// Fusion returns base64 PDF in top-level `result` (string), not a map.
  Future<Uint8List> downloadDocumentBytes(Map<String, dynamic> payload) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      final result = await _client.post('wf/documents/download', payload);
      final base64 = documentDownloadBase64(result);
      if (base64 == null || base64.isEmpty) {
        throw AuthApiException('لا يوجد ملف للعرض');
      }
      try {
        return Uint8List.fromList(base64Decode(normalizeDocumentBase64(base64)));
      } on FormatException {
        throw AuthApiException('تعذر قراءة الملف');
      }
    });
  }

  /// Parses `wf/documents/download` `result` (string or `{fileContent}` map).
  static String? documentDownloadBase64(dynamic result) {
    if (result is String && result.trim().isNotEmpty) {
      return result.trim();
    }
    if (result is Map) {
      for (final key in ['fileContent', 'content', 'file', 'data', 'base64']) {
        final value = result[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }
    return null;
  }

  static String normalizeDocumentBase64(String input) {
    final trimmed = input.replaceAll('\n', '').replaceAll('\r', '').trim();
    if (trimmed.startsWith('data:')) {
      final comma = trimmed.indexOf(',');
      if (comma >= 0) return trimmed.substring(comma + 1);
    }
    return trimmed;
  }

  Future<void> deleteDocument(Map<String, dynamic> params) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      final query = <String, String>{};
      for (final entry in params.entries) {
        if (entry.value == null) continue;
        final text = '${entry.value}'.trim();
        if (text.isNotEmpty) query[entry.key] = text;
      }
      await _client.delete('wf/documents/all', query: query);
    });
  }

  Future<void> uploadDocument({
    required int docId,
    required String fileBase64,
    required String fileName,
    required String idno,
    required String serviceId,
    required String ticketId,
    String notes = '',
    String? orgId,
    String? fileContentType,
  }) {
    return AppLoading.watch(() async {
      _ensureSignedIn();
      await _client.post('wf/documents', {
        'docId': docId,
        'fileContent': fileBase64,
        'fileContentType':
            fileContentType ?? contentTypeForFileName(fileName),
        'fileName': fileName,
        'idno': idno,
        'notes': notes,
        'orgId': orgId,
        'serviceId': serviceId,
        'ticketId': ticketId,
        'uploadDate': _uploadTimestamp(),
      });
    });
  }

  static String _uploadTimestamp() {
    final n = DateTime.now();
    String p(int v) => v.toString().padLeft(2, '0');
    return '${p(n.day)}/${p(n.month)}/${n.year} ${p(n.hour)}:${p(n.minute)}:${p(n.second)}';
  }

  static String bytesToBase64(List<int> bytes) => base64Encode(bytes);

  static String contentTypeForFileName(String fileName) {
    final ext = fileName.contains('.')
        ? fileName.split('.').last.toLowerCase()
        : '';
    return switch (ext) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      _ => 'application/pdf',
    };
  }

  void _ensureSignedIn() {
    if (!_session.isSignedIn) {
      throw AuthApiException('بيانات الدخول غير صحيحة');
    }
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    return const {};
  }

  static List<Map<String, dynamic>> _dataList(dynamic value) {
    if (value is Map) {
      final data = value['data'];
      if (data is List) {
        return data
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    }
    if (value is List) {
      return value
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return const [];
  }
}

class OrganizationInquiryBundle {
  const OrganizationInquiryBundle({
    required this.organizations,
    required this.detail,
    required this.partners,
  });

  final List<Map<String, dynamic>> organizations;
  final Map<String, dynamic> detail;
  final List<Map<String, dynamic>> partners;
}
