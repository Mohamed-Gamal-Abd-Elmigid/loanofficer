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

class NationalIdCheck {
  const NationalIdCheck({
    required this.accepted,
    required this.genderCode,
    required this.birth,
    this.message = '',
  });

  final bool accepted;
  final String genderCode;
  final String birth;
  final String message;
}

class AddressPlace {
  const AddressPlace({
    required this.name,
    this.regionId = '',
    this.stateId = '',
    this.cityId = '',
  });

  final String name;
  final String regionId;
  final String stateId;
  final String cityId;
}

class ClientLookups {
  const ClientLookups({
    required this.genders,
    required this.health,
    required this.religions,
    required this.nations,
    required this.social,
    required this.qualifications,
    required this.jobs,
    required this.states,
    required this.genderNames,
    this.religionNames = const {},
    this.socialNames = const {},
    this.healthNames = const {},
    this.nationNames = const {},
    this.qualificationNames = const {},
    this.jobNames = const {},
  });

  final List<String> genders;
  final List<String> health;
  final List<String> religions;
  final List<String> nations;
  final List<String> social;
  final List<String> qualifications;
  final List<String> jobs;
  final List<AddressPlace> states;

  /// Domain code → Arabic name maps (UI shows name; API needs code).
  final Map<String, String> genderNames;
  final Map<String, String> religionNames;
  final Map<String, String> socialNames;
  final Map<String, String> healthNames;
  final Map<String, String> nationNames;
  final Map<String, String> qualificationNames;
  final Map<String, String> jobNames;

  String genderName(String code) => genderNames[code] ?? '';

  String? codeForName(Map<String, String> names, String name) {
    final text = name.trim();
    if (text.isEmpty) return null;
    for (final entry in names.entries) {
      if (entry.value == text) return entry.key;
    }
    if (names.containsKey(text)) return text;
    return null;
  }

  String? religionCode(String name) => codeForName(religionNames, name);

  String? socialCode(String name) => codeForName(socialNames, name);

  String? healthCode(String name) => codeForName(healthNames, name);

  String? nationCode(String name) => codeForName(nationNames, name);

  String? qualificationCode(String name) =>
      codeForName(qualificationNames, name);

  String? jobCode(String name) => codeForName(jobNames, name);

  String? genderCode(String name) => codeForName(genderNames, name);

  /// Resolve a stored code (or already-Arabic label) to the UI display name.
  /// Handles `jobCode: 2` → `موظف` via CIF_JOB_CODE (and padded codes like `02`).
  String labelFor(Map<String, String> names, String raw) {
    final text = raw.trim();
    if (text.isEmpty) return '';
    final byCode = names[text];
    if (byCode != null && byCode.isNotEmpty) return byCode;
    final asInt = int.tryParse(text);
    if (asInt != null) {
      final normalized = '$asInt';
      final byNormalized = names[normalized];
      if (byNormalized != null && byNormalized.isNotEmpty) return byNormalized;
      for (final entry in names.entries) {
        if (int.tryParse(entry.key) == asInt) return entry.value;
      }
    }
    for (final entry in names.entries) {
      if (entry.value == text) return text;
    }
    return text;
  }

  /// Also resolve gender letters used by checkIdno / customersBasic (`M`/`F`).
  String genderLabel(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return '';
    final fromMap = labelFor(genderNames, text);
    if (fromMap != text) return fromMap;
    switch (text.toUpperCase()) {
      case 'M':
      case '1':
        return genderNames['M'] ??
            genderNames['1'] ??
            genderNames['MALE'] ??
            'ذكر';
      case 'F':
      case '2':
        return genderNames['F'] ??
            genderNames['2'] ??
            genderNames['FEMALE'] ??
            'انثى';
      default:
        return fromMap;
    }
  }

  String jobLabel(String raw) => labelFor(jobNames, raw);

  String educationLabel(String raw) => labelFor(qualificationNames, raw);

  String healthLabel(String raw) => labelFor(healthNames, raw);

  String religionLabel(String raw) => labelFor(religionNames, raw);

  String socialLabel(String raw) => labelFor(socialNames, raw);

  String nationLabel(String raw) => labelFor(nationNames, raw);

  AddressPlace? stateNamed(String name) {
    for (final state in states) {
      if (state.name == name) return state;
    }
    return null;
  }
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
      // Web basic form loads `GET cif/customersBasic/{idno}` for indv.jobCode etc.
      final merged = await _mergeCustomersBasic(id, flat);
      _cache[clientId] = merged;
      return ClientProfile(
        id: clientId,
        existed: true,
        values: _values(id, merged),
      );
    });
  }

  /// Merge `cif/customersBasic/{idno}` (info / indv / address) into query row.
  Future<Map<String, dynamic>> _mergeCustomersBasic(
    String nationalId,
    Map<String, dynamic> flat,
  ) async {
    try {
      final basic = await _client.get('cif/customersBasic/$nationalId');
      final root = basic is Map
          ? Map<String, dynamic>.from(basic)
          : <String, dynamic>{};
      if (root.isEmpty) return flat;
      final out = Map<String, dynamic>.from(flat);
      out.addAll(_flat(root));
      // Prefer numeric/string codes from basic indv for domain fields.
      final indv = root['indv'];
      if (indv is Map) {
        final map = Map<String, dynamic>.from(indv);
        for (final key in const [
          'jobCode',
          'religion',
          'nationCode',
          'gender',
          'socialStatus',
          'noOfChildren',
          'qualificationId',
          'healthStatus',
        ]) {
          if (map[key] != null) out[key] = map[key];
        }
      }
      final info = root['info'];
      if (info is Map) {
        final map = Map<String, dynamic>.from(info);
        for (final key in const [
          'fullname',
          'nickname',
          'idNumber',
          'birthdate',
          'idIssueDate',
          'idExpDate',
          'phoneNo1',
          'phoneNo2',
          'email',
          'stName',
          'ndName',
          'rdName',
          'thName',
          'custno',
        ]) {
          final text = _text(map[key]);
          if (text.isNotEmpty) out[key] = map[key];
        }
        // Prefer structured name parts when present.
        if (_text(map['stName']).isNotEmpty) {
          out['stName'] = map['stName'];
          out['ndName'] = map['ndName'];
          out['rdName'] = map['rdName'];
          out['thName'] = map['thName'];
        }
      }
      // Keep city/village codes — PUT customersBasic requires them.
      _mergeBasicAddress(
        out,
        root['address'],
        stateName: 'homeStateName',
        cityName: 'homeCityName',
        villageName: 'homeVillageName',
        stateCode: 'homeStateCode',
        cityCode: 'homeCityCode',
        villageCode: 'homeVillageCode',
        street: 'homeStreet',
        building: 'homeBuildingNo',
        floor: 'homeFloorNo',
        flat: 'homeFlatNo',
        mark: 'homeMark',
        postal: 'homePostCode',
      );
      _mergeBasicAddress(
        out,
        root['addressInIdCard'],
        stateName: 'idStateName',
        cityName: 'idCityName',
        villageName: 'idVillageName',
        stateCode: 'idStateCode',
        cityCode: 'idCityCode',
        villageCode: 'idVillageCode',
        street: 'idStreet',
        building: 'idBuildingNo',
        floor: 'idFloorNo',
        flat: 'idFlatNo',
        mark: 'idAdd',
        postal: 'idPostCode',
      );
      return out;
    } catch (_) {
      return flat;
    }
  }

  void _mergeBasicAddress(
    Map<String, dynamic> out,
    dynamic raw, {
    required String stateName,
    required String cityName,
    required String villageName,
    required String stateCode,
    required String cityCode,
    required String villageCode,
    required String street,
    required String building,
    required String floor,
    required String flat,
    required String mark,
    required String postal,
  }) {
    if (raw is! Map) return;
    final map = Map<String, dynamic>.from(raw);
    void put(String key, List<String> sources) {
      if (_text(out[key]).isNotEmpty) return;
      for (final source in sources) {
        final text = _text(map[source]);
        if (text.isEmpty) continue;
        out[key] = map[source];
        return;
      }
    }

    put(stateCode, const ['stateCode', 'stateId']);
    put(cityCode, const ['cityCode', 'cityId']);
    put(villageCode, const ['villageCode', 'villageId']);
    put(stateName, const ['stateName', 'stateNameAr', 'nameAr']);
    put(cityName, const ['cityName', 'cityNameAr']);
    put(villageName, const ['villageName', 'villageNameAr']);
    put(street, const ['street']);
    put(building, const ['buildingNo']);
    put(floor, const ['floorNo']);
    put(flat, const ['flatno', 'flatNo']);
    put(mark, const ['addMark']);
    put(postal, const ['postCode']);
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

  /// Fusion saves the new-customer popup with `cif/customersBasic`.
  /// A new customer is created; an existing one is updated.
  Future<String?> saveCustomerForm({
    required Map<String, String> values,
    String? clientId,
    ClientLookups? lookups,
  }) {
    return AppLoading.watch(() async {
      final login = await _session.readLogin();
      final existing = clientId?.trim() ?? '';
      final resolved = await _resolveAddressCodes(values, lookups);
      final body = _customerBody(
        values: resolved,
        clientId: existing,
        lookups: lookups,
        login: login,
      );
      final result = existing.isEmpty
          ? await _client.post('cif/customersBasic', body)
          : await _client.put('cif/customersBasic', body);
      return _idOf(result) ?? (existing.isEmpty ? null : existing);
    });
  }

  /// Fill city/village ids when the form has names but no codes (common after
  /// loading query/customer names without re-picking the dropdowns).
  Future<Map<String, String>> _resolveAddressCodes(
    Map<String, String> values,
    ClientLookups? lookups,
  ) async {
    final out = Map<String, String>.from(values);
    await _fillAddressCodes(out, 'res', lookups);
    await _fillAddressCodes(out, 'card', lookups);
    return out;
  }

  Future<void> _fillAddressCodes(
    Map<String, String> values,
    String prefix,
    ClientLookups? lookups,
  ) async {
    final stateName = (values['${prefix}Governorate'] ?? '').trim();
    final cityName = (values['${prefix}City'] ?? '').trim();
    final villageName = (values['${prefix}District'] ?? '').trim();
    var stateId = (values['${prefix}StateId'] ?? '').trim();
    var cityId = (values['${prefix}CityId'] ?? '').trim();
    var villageId = (values['${prefix}VillageId'] ?? '').trim();

    AddressPlace? matchedState;
    if (lookups != null) {
      if (stateName.isNotEmpty) matchedState = lookups.stateNamed(stateName);
      if (matchedState == null && stateId.isNotEmpty) {
        for (final item in lookups.states) {
          if (item.stateId == stateId) {
            matchedState = item;
            break;
          }
        }
      }
    }
    if (matchedState == null) return;
    var state = matchedState;
    if (stateId.isEmpty) {
      stateId = state.stateId;
      values['${prefix}StateId'] = stateId;
    }
    if (stateId.isEmpty) return;

    if (cityId.isEmpty && cityName.isNotEmpty) {
      try {
        final cities = await this.cities(state);
        for (final city in cities) {
          if (city.name != cityName) continue;
          cityId = city.cityId;
          values['${prefix}CityId'] = cityId;
          state = AddressPlace(
            name: city.name,
            regionId: city.regionId.isEmpty ? state.regionId : city.regionId,
            stateId: city.stateId.isEmpty ? state.stateId : city.stateId,
            cityId: city.cityId,
          );
          break;
        }
      } catch (_) {}
    }

    if (villageId.isEmpty &&
        villageName.isNotEmpty &&
        cityId.isNotEmpty) {
      try {
        final city = AddressPlace(
          name: cityName,
          regionId: state.regionId,
          stateId: state.stateId,
          cityId: cityId,
        );
        final villages = await this.villages(state: state, city: city);
        for (final village in villages) {
          if (village.name != villageName) continue;
          villageId = village.cityId;
          values['${prefix}VillageId'] = villageId;
          break;
        }
      } catch (_) {}
    }
  }

  Map<String, dynamic> _customerBody({
    required Map<String, String> values,
    required String clientId,
    required ClientLookups? lookups,
    required Map<String, dynamic>? login,
  }) {
    final custno = clientId.isEmpty ? null : clientId;
    Object? domainCode(String? Function(String name)? resolve, String raw) {
      final text = raw.trim();
      if (text.isEmpty) return null;
      final resolved = resolve?.call(text) ?? text;
      return _code(resolved);
    }

    Object? placeCode(String key) => _code(values[key]);
    final homeState = lookups?.stateNamed(values['resGovernorate'] ?? '');
    final cardState = lookups?.stateNamed(values['cardGovernorate'] ?? '');
    String line(String prefix) {
      final building = values['${prefix}Building'] ?? '';
      final street = values['${prefix}Street'] ?? '';
      final village = values['${prefix}District'] ?? '';
      final city = values['${prefix}City'] ?? '';
      final state = values['${prefix}Governorate'] ?? '';
      return '$building  $street - $village - $city - $state'.trim();
    }

    Map<String, dynamic> address(String prefix, AddressPlace? state) {
      return {
        'countryCode': _code('${login?['countryId'] ?? 1}'),
        'stateCode': _code(
          (values['${prefix}StateId'] ?? '').isNotEmpty
              ? values['${prefix}StateId']!
              : (state?.stateId ?? ''),
        ),
        'cityCode': placeCode('${prefix}CityId'),
        'villageCode': placeCode('${prefix}VillageId'),
        'street': _orNull(values['${prefix}Street']),
        'buildingNo': _orNull(values['${prefix}Building']),
        'floorNo': _orNull(values['${prefix}Floor']),
        'flatno': _orNull(values['${prefix}Apartment']),
        'addMark': _orNull(values['${prefix}Landmark']),
        'postCode': _orNull(values['${prefix}Postal']),
        'addTxt': line(prefix),
      };
    }

    return {
      'ticketId': -99,
      'custno': custno,
      'info': {
        'custno': custno,
        'brcode': login?['brCode'],
        'lang': login?['langCode'] ?? 'AR',
        'opendate': login?['appDate'],
        'idNumber': _orNull(values['nationalId']),
        'fullname': _orNull(
          (values['fullName'] ?? '').trim().isNotEmpty
              ? values['fullName']
              : [
                  values['first'],
                  values['second'],
                  values['third'],
                  values['fourth'],
                ]
                  .map((part) => (part ?? '').trim())
                  .where((part) => part.isNotEmpty)
                  .join(' '),
        ),
        'stName': _orNull(values['first']),
        'ndName': _orNull(values['second']),
        'rdName': _orNull(values['third']),
        'thName': _orNull(values['fourth']),
        'nickname': _orNull(values['nickname']),
        'birthdate': _orNull(values['birth']),
        'idIssueDate': _orNull(values['issue']),
        'idExpDate': _orNull(values['expiry']),
        'phoneNo1': _orNull(values['phone1']),
        'phoneNo2': _orNull(values['phone2']),
        'email': _orNull(values['email']),
        'status': 1,
        // Required by cif/customersBasic (active individual customer).
        'custStatus': 1,
        'custType': 1,
      },
      'indv': {
        'religion': domainCode(lookups?.religionCode, values['religion'] ?? ''),
        'nationCode':
            domainCode(lookups?.nationCode, values['nationality'] ?? '') ?? 1,
        'gender': domainCode(lookups?.genderCode, values['gender'] ?? ''),
        'socialStatus':
            domainCode(lookups?.socialCode, values['marital'] ?? ''),
        'noOfChildren': _code(values['children']),
        'qualificationId':
            domainCode(lookups?.qualificationCode, values['education'] ?? ''),
        'healthStatus':
            domainCode(lookups?.healthCode, values['health'] ?? ''),
        'jobCode': domainCode(lookups?.jobCode, values['job'] ?? ''),
      },
      'address': address('res', homeState),
      'addressInIdCard': address('card', cardState),
    };
  }

  Object? _code(String? raw) {
    final text = raw?.trim() ?? '';
    if (text.isEmpty) return null;
    return int.tryParse(text) ?? text;
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
    final fromParts = [
      _text(row['stName']),
      _text(row['ndName']),
      _text(row['rdName']),
      _text(row['thName']),
    ].where((part) => part.isNotEmpty).toList();
    final parts = fromParts.isNotEmpty
        ? fromParts
        : fullName
              .split(RegExp(r'\s+'))
              .where((part) => part.isNotEmpty)
              .toList();
    String part(int index) => index < parts.length ? parts[index] : '';
    final composed = parts.join(' ');
    return {
      'nationalId': _text(row['idNumber']).isEmpty
          ? nationalId
          : _text(row['idNumber']),
      'clientNumber': _text(row['custno']),
      'fullName': composed.isNotEmpty ? composed : fullName,
      'first': part(0),
      'second': part(1),
      'third': part(2),
      'fourth': part(3),
      'nickname': _text(row['nickname']),
      'birth': _text(row['birthdate']),
      'issue': _text(row['idIssueDate']),
      'expiry': _text(row['idExpDate']),
      'gender': _text(row['genderDescr']).isNotEmpty
          ? _text(row['genderDescr'])
          : _text(row['gender']),
      'health': _text(row['healthDescr']).isNotEmpty
          ? _text(row['healthDescr'])
          : _text(row['healthStatus']),
      // Web: indv.jobCode → CIF_JOB_CODE nameAr (e.g. 2 → موظف).
      'job': _firstNonEmpty(row, const [
        'jobDescr',
        'jobName',
        'jobCodeDescr',
        'jobCode',
      ]),
      'religion': _text(row['religionDescr']).isNotEmpty
          ? _text(row['religionDescr'])
          : _text(row['religion']),
      'nationality': _text(row['nationDescr']).isNotEmpty
          ? _text(row['nationDescr'])
          : _text(row['nationCode']),
      'marital': _text(row['socialDescr']).isNotEmpty
          ? _text(row['socialDescr'])
          : _text(row['socialStatus']),
      'children': _text(row['noOfChildren']),
      'education': _firstNonEmpty(row, const [
        'qualificationDescr',
        'qualification',
        'qualificationId',
      ]),
      'resGovernorate': _text(row['homeStateName']),
      'resCity': _text(row['homeCityName']),
      'resDistrict': _text(row['homeVillageName']),
      'resStreet': _text(row['homeStreet']),
      'resBuilding': _text(row['homeBuildingNo']),
      'resFloor': _text(row['homeFloorNo']),
      'resApartment': _text(row['homeFlatNo']),
      'resLandmark': _text(row['homeMark']),
      'resPostal': _text(row['homePostCode']),
      'resStateId': _firstNonEmpty(row, const [
        'homeStateCode',
        'homeStateId',
        'resStateId',
      ]),
      'resCityId': _firstNonEmpty(row, const [
        'homeCityCode',
        'homeCityId',
        'resCityId',
      ]),
      'resVillageId': _firstNonEmpty(row, const [
        'homeVillageCode',
        'homeVillageId',
        'resVillageId',
      ]),
      'cardGovernorate': _text(row['idStateName']),
      'cardCity': _text(row['idCityName']),
      'cardDistrict': _text(row['idVillageName']),
      'cardStreet': _text(row['idStreet']),
      'cardBuilding': _text(row['idBuildingNo']),
      'cardFloor': _text(row['idFloorNo']),
      'cardApartment': _text(row['idFlatNo']),
      'cardLandmark': _text(row['idAdd']),
      'cardPostal': _text(row['idPostCode']),
      'cardStateId': _firstNonEmpty(row, const [
        'idStateCode',
        'idStateId',
        'cardStateId',
      ]),
      'cardCityId': _firstNonEmpty(row, const [
        'idCityCode',
        'idCityId',
        'cardCityId',
      ]),
      'cardVillageId': _firstNonEmpty(row, const [
        'idVillageCode',
        'idVillageId',
        'cardVillageId',
      ]),
      'phone1': _text(row['phoneNo1']),
      'phone2': _text(row['phoneNo2']),
      // customersBasic uses `email`; query/customer often uses `eMail`.
      'email': _firstNonEmpty(row, const ['email', 'eMail']),
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
      'indv',
      'individualInformation',
      'info',
    ]) {
      final value = row[key];
      if (value is Map) out.addAll(Map<String, dynamic>.from(value));
    }
    return out;
  }

  String _firstNonEmpty(Map<String, dynamic> row, List<String> keys) {
    for (final key in keys) {
      final text = _text(row[key]);
      if (text.isNotEmpty && text.toLowerCase() != 'null') return text;
    }
    return '';
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

  /// Fusion `cif/customers/names`. An empty list means this national ID is new.
  Future<List<Map<String, String>>> customerNames(String nationalId) async {
    final result = await _client.get(
      'cif/customers/names',
      query: {'idNo': nationalId.trim()},
    );
    final list = _customerNamesList(result);
    final rows = <Map<String, String>>[];
    for (final item in list) {
      if (item is! Map) continue;
      final id = _firstText(item, const ['custno', 'custNo', 'id']);
      final name = _firstText(item, const [
        'fullname',
        'fullName',
        'nameAr',
        'custName',
      ]);
      rows.add({'id': id, 'fullName': name});
    }
    return rows;
  }

  static List<dynamic> _customerNamesList(dynamic result) {
    if (result is List) return result;
    if (result is Map) {
      for (final key in const ['data', 'content', 'result']) {
        final value = result[key];
        if (value is List) return value;
      }
      if (result.isNotEmpty) return [result];
    }
    return const [];
  }

  /// Fusion `cif/checkIdno`: reads gender and birth date out of a national ID.
  Future<NationalIdCheck> checkNationalId(String nationalId) async {
    final result = await _client.get(
      'cif/checkIdno',
      query: {'idNo': nationalId.trim()},
    );
    final row = result is Map ? result : const <String, dynamic>{};
    final code = row['P_ERR_CODE'];
    final birth = _text(row['P_BOD']).split(' ').first;
    return NationalIdCheck(
      accepted: code == 0 || '$code' == '0',
      genderCode: _text(row['P_GENDER']),
      birth: birth == 'null' ? '' : birth,
      message: _text(row['P_ERR_MSG']),
    );
  }

  /// Lists used by the new-customer form: lookups, governorates, and jobs.
  Future<ClientLookups> customerFormLookups() async {
    final results = await Future.wait<dynamic>([
      _client.get('cif/customers/lookups'),
      _client.get('adminController/address/state', query: {'countryId': '1'}),
      _client.get('adminController/domainsUserData/byCatId/CIF_JOB_CODE'),
    ]);
    final lookups = results[0] is Map ? results[0] as Map : const {};
    Map<String, String> codeNames(dynamic list) {
      final map = <String, String>{};
      if (list is! List) return map;
      for (final item in list) {
        if (item is! Map) continue;
        final code = _text(
          item['code'] ?? item['codeId'] ?? item['id'],
        );
        final name = _text(
          item['nameAr'] ?? item['nameEn'] ?? item['name'],
        );
        if (code.isNotEmpty && name.isNotEmpty) map[code] = name;
      }
      return map;
    }

    final genderNames = codeNames(lookups['CIF_GENDER']);
    final religionNames = codeNames(lookups['CIF_RELIGION']);
    final socialNames = codeNames(lookups['CIF_SOCIAL_STATUS']);
    final healthNames = codeNames(lookups['CIF_HEALTH_STATUS']);
    final nationNames = codeNames(lookups['CIF_NATION_CODE']);
    final qualificationNames = codeNames(lookups['CIF_QUALIFICATION_ID']);
    final jobNames = codeNames(results[2]);
    return ClientLookups(
      genders: genderNames.values.toList(),
      health: healthNames.values.toList(),
      religions: religionNames.values.toList(),
      nations: nationNames.values.toList(),
      social: socialNames.values.toList(),
      qualifications: qualificationNames.values.toList(),
      jobs: jobNames.values.toList(),
      states: _places(results[1], const ['stateId']),
      genderNames: genderNames,
      religionNames: religionNames,
      socialNames: socialNames,
      healthNames: healthNames,
      nationNames: nationNames,
      qualificationNames: qualificationNames,
      jobNames: jobNames,
    );
  }

  Future<List<AddressPlace>> cities(AddressPlace state) async {
    final result = await _client.get(
      'adminController/address/city',
      query: {
        'regionId': state.regionId,
        'countryId': '1',
        'stateId': state.stateId,
      },
    );
    return [
      for (final city in _places(result, const ['cityId', 'id']))
        AddressPlace(
          name: city.name,
          regionId: city.regionId.isEmpty ? state.regionId : city.regionId,
          stateId: city.stateId.isEmpty ? state.stateId : city.stateId,
          cityId: city.cityId,
        ),
    ];
  }

  Future<List<AddressPlace>> villages({
    required AddressPlace state,
    required AddressPlace city,
  }) async {
    final result = await _client.get(
      'adminController/address/village',
      query: {
        'regionId': city.regionId.isEmpty ? state.regionId : city.regionId,
        'countryId': '1',
        'stateId': city.stateId.isEmpty ? state.stateId : city.stateId,
        'cityId': city.cityId,
      },
    );
    return _places(result, const ['villageId', 'id']);
  }

  List<AddressPlace> _places(dynamic result, List<String> idKeys) {
    if (result is! List) return const [];
    final places = <AddressPlace>[];
    for (final item in result) {
      if (item is! Map) continue;
      final name = _text(item['nameAr']);
      if (name.isEmpty) continue;
      var id = '';
      for (final key in idKeys) {
        id = _text(item[key]);
        if (id.isNotEmpty) break;
      }
      places.add(
        AddressPlace(
          name: name,
          regionId: _text(item['regionId']),
          stateId: _text(item['stateId']),
          cityId: idKeys.contains('cityId') || idKeys.contains('villageId')
              ? id
              : _text(item['cityId']),
        ),
      );
    }
    return places;
  }

  String _firstText(Map item, List<String> keys) {
    for (final key in keys) {
      final text = _text(item[key]);
      if (text.isNotEmpty) return text;
    }
    return '';
  }
}
