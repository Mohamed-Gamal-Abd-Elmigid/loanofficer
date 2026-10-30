import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fmc_client.dart';
import 'package:loanofficer/core/api/fmc_session.dart';
import 'package:loanofficer/core/components/app_loading.dart';

class ClientProfile {
  const ClientProfile({
    required this.id,
    required this.existed,
    required this.values,
  });

  final String id;
  final bool existed;
  final Map<String, String> values;
}

class ClientApi {
  ClientApi({FmcClient? client, FmcSession? session})
    : _client = client ?? FmcClient(),
      _session = session ?? FmcSession.instance;

  final FmcClient _client;
  final FmcSession _session;
  final Map<String, Map<String, dynamic>> _cache = {};

  Future<ClientProfile> openByNationalId(String nationalId) {
    final id = nationalId.trim();
    return AppLoading.watch(() async {
      if (!_session.isSignedIn) {
        throw AuthApiException('بيانات الدخول غير صحيحة');
      }
      final result = await _client.get('query/customer', query: {'idno': id});
      final row = _firstRow(result);
      final flat = row == null ? null : _flat(row);
      final existingId = flat == null ? '' : _text(flat['custno']);
      if (flat == null || existingId.isEmpty) {
        final created = await _client.post('cif/customers', {'idNumber': id});
        final createdRow = _firstRow(created) ?? {'idNumber': id};
        final clientId = _idOf(created) ?? _text(createdRow['custno']);
        if (clientId.isEmpty) {
          throw AuthApiException('تعذر إنشاء العميل');
        }
        createdRow['custno'] = clientId;
        createdRow['idNumber'] = id;
        _cache[clientId] = createdRow;
        return ClientProfile(
          id: clientId,
          existed: false,
          values: {'nationalId': id},
        );
      }
      final clientId = existingId;
      _cache[clientId] = flat;
      return ClientProfile(
        id: clientId,
        existed: true,
        values: _values(id, flat),
      );
    });
  }

  Future<void> updateNationalId({
    required String clientId,
    required String nationalId,
  }) {
    return _save(clientId, {'idNumber': nationalId.trim()});
  }

  Future<void> saveBasic({
    required String clientId,
    required Map<String, String> values,
  }) {
    final fullName = _joinedName(values);
    return _save(clientId, {
      'fullname': fullName,
      'nickname': _orNull(values['nickname']),
      'idIssueDate': _orNull(values['issue']),
      'idExpDate': _orNull(values['expiry']),
      'birthdate': _orNull(values['birth']),
      'genderDescr': _orNull(values['gender']),
      'healthDescr': _orNull(values['health']),
      'workPlace': _orNull(values['job']),
      'religionDescr': _orNull(values['religion']),
      'nationDescr': _orNull(values['nationality']),
      'socialDescr': _orNull(values['marital']),
      'noOfChildren': _orNull(values['children']),
      'qualification': _orNull(values['education']),
    }, basic: true);
  }

  Future<void> saveResidence({
    required String clientId,
    required Map<String, String> values,
  }) {
    return _save(clientId, {
      'homeStateName': _orNull(values['resGovernorate']),
      'homeCityName': _orNull(values['resCity']),
      'homeVillageName': _orNull(values['resDistrict']),
      'homeStreet': _orNull(values['resStreet']),
      'homeBuildingNo': _orNull(values['resBuilding']),
      'homeFloorNo': _orNull(values['resFloor']),
      'homeFlatNo': _orNull(values['resApartment']),
      'homeMark': _orNull(values['resLandmark']),
    });
  }

  Future<void> saveCardAddress({
    required String clientId,
    required Map<String, String> values,
  }) {
    return _save(clientId, {
      'idStateName': _orNull(values['cardGovernorate']),
      'idCityName': _orNull(values['cardCity']),
      'idVillageName': _orNull(values['cardDistrict']),
      'idStreet': _orNull(values['cardStreet']),
      'idBuildingNo': _orNull(values['cardBuilding']),
      'idFloorNo': _orNull(values['cardFloor']),
      'idFlatNo': _orNull(values['cardApartment']),
      'idAdd': _orNull(values['cardLandmark']),
    });
  }

  Future<void> saveContact({
    required String clientId,
    required Map<String, String> values,
  }) {
    return _save(clientId, {
      'phoneNo1': _orNull(values['phone1']),
      'phoneNo2': _orNull(values['phone2']),
      'eMail': _orNull(values['email']),
    });
  }

  Future<void> _save(
    String clientId,
    Map<String, dynamic> fields, {
    bool basic = false,
  }) {
    return AppLoading.watch(() async {
      final body = Map<String, dynamic>.from(_cache[clientId] ?? {});
      body.addAll(fields);
      body['custno'] = clientId;
      await _client.put('cif/customers', body);
      if (basic) {
        await _client.put('cif/customersBasic', {
          'custno': clientId,
          'idNumber': body['idNumber'],
          ...fields,
        });
      }
      _cache[clientId] = body;
    });
  }

  Map<String, String> _values(String nationalId, Map<String, dynamic> row) {
    final fullName = _text(row['fullname']);
    final parts = fullName
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    String part(int index) => index < parts.length ? parts[index] : '';
    return {
      'nationalId': _text(row['idNumber']).isEmpty
          ? nationalId
          : _text(row['idNumber']),
      'clientNumber': _text(row['custno']),
      'fullName': fullName,
      'first': part(0),
      'second': part(1),
      'third': part(2),
      'fourth': part(3),
      'nickname': _text(row['nickname']),
      'birth': _text(row['birthdate']),
      'issue': _text(row['idIssueDate']),
      'expiry': _text(row['idExpDate']),
      'gender': _text(row['genderDescr']),
      'health': _text(row['healthDescr']),
      'job': _text(row['workPlace']).isEmpty
          ? _text(row['code1Name'])
          : _text(row['workPlace']),
      'religion': _text(row['religionDescr']),
      'nationality': _text(row['nationDescr']),
      'marital': _text(row['socialDescr']),
      'children': _text(row['noOfChildren']),
      'education': _text(row['qualification']),
      'resGovernorate': _text(row['homeStateName']),
      'resCity': _text(row['homeCityName']),
      'resDistrict': _text(row['homeVillageName']),
      'resStreet': _text(row['homeStreet']),
      'resBuilding': _text(row['homeBuildingNo']),
      'resFloor': _text(row['homeFloorNo']),
      'resApartment': _text(row['homeFlatNo']),
      'resLandmark': _text(row['homeMark']),
      'resPostal': '',
      'cardGovernorate': _text(row['idStateName']),
      'cardCity': _text(row['idCityName']),
      'cardDistrict': _text(row['idVillageName']),
      'cardStreet': _text(row['idStreet']),
      'cardBuilding': _text(row['idBuildingNo']),
      'cardFloor': _text(row['idFloorNo']),
      'cardApartment': _text(row['idFlatNo']),
      'cardLandmark': _text(row['idAdd']),
      'cardPostal': '',
      'phone1': _text(row['phoneNo1']),
      'phone2': _text(row['phoneNo2']),
      'email': _text(row['eMail']),
    };
  }

  Map<String, dynamic> _flat(Map<String, dynamic> row) {
    final out = Map<String, dynamic>.from(row);
    for (final key in const [
      'customerInformation',
      'idAddressInformation',
      'addressInformation',
      'contactInformation',
      'workplaceInformation',
    ]) {
      final value = row[key];
      if (value is Map) out.addAll(Map<String, dynamic>.from(value));
    }
    return out;
  }

  Map<String, dynamic>? _firstRow(dynamic result) {
    if (result is List) {
      if (result.isEmpty) return null;
      final first = result.first;
      if (first is Map) return Map<String, dynamic>.from(first);
      return null;
    }
    if (result is Map) {
      if (result['content'] is List) return _firstRow(result['content']);
      return Map<String, dynamic>.from(result);
    }
    return null;
  }

  String? _idOf(dynamic result) {
    if (result is Map) {
      final id = _text(result['custno']);
      if (id.isNotEmpty) return id;
      final nested = result['result'];
      if (nested != null) return _idOf(nested);
    }
    if (result is List && result.isNotEmpty) return _idOf(result.first);
    if (result is num || result is String) {
      final id = '$result'.trim();
      return id.isEmpty ? null : id;
    }
    return null;
  }

  String? _joinedName(Map<String, String> values) {
    final full = _orNull(values['fullName']);
    if (full != null) return full;
    final parts = [
      values['first'],
      values['second'],
      values['third'],
      values['fourth'],
    ].map(_orNull).whereType<String>().toList();
    if (parts.isEmpty) return null;
    return parts.join(' ');
  }

  String _text(dynamic value) => value == null ? '' : '$value'.trim();

  String? _orNull(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? null : text;
  }
}
