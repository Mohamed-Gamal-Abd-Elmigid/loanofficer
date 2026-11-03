// ignore_for_file: avoid_print
/// One-off UAT probe: login + findService + inquiry APIs for N rows.
/// Run: dart run tool/uat_inquiry_probe.dart
import 'dart:convert';
import 'dart:io';

const _root = 'https://fmc-api-uat.tanmeyah.lan/fmc/';
const _user = '21358';
const _pass = '123456';

Future<void> main() async {
  final client = HttpClient();
  client.badCertificateCallback = (_, __, ___) => true;

  print('=== Login ===');
  final loginEnv = await _post(client, 'fmc/auth/login', {
    'userId': _user,
    'password': _pass,
    'macIp': '',
  }, token: null, roleId: null);

  final login = loginEnv['result'] as Map<String, dynamic>? ?? loginEnv;
  final token = '${login['token']}';
  if (token.isEmpty || token == 'null') {
    print('Login failed: $loginEnv');
    exit(1);
  }
  final mcCode = '${login['mcCode'] ?? 1}';
  final roles = login['availableRoleAndScreens'] as List? ?? [];
  Map<String, dynamic>? role;
  if (roles.isNotEmpty && roles.first is Map) {
    role = Map<String, dynamic>.from(roles.first as Map);
  } else if (login['currentRole'] is Map) {
    role = Map<String, dynamic>.from(login['currentRole'] as Map);
  }
  final roleId = '${role?['roleId'] ?? ''}';
  print('Token OK, roleId=$roleId mcCode=$mcCode brCode=${login['brCode']}');

  final br = login['brCode'];
  final brNum = br is num ? br.toInt() : int.tryParse('$br') ?? 0;
  final brcode = brNum == 1 ? null : brNum;

  print('\n=== findService page 1 (10 rows) ===');
  final findEnv = await _post(client, 'query/service/findService', {
    if (brcode != null) 'brcode': brcode,
  }, token: token, roleId: roleId, mcCode: mcCode);

  final findResult = findEnv['result'];
  final rows = _asList(findResult);
  print('rows=${rows.length} totalHint=${_total(findEnv, findResult)}');

  final outDir = Directory('tool/uat_probe_output');
  if (!outDir.existsSync()) outDir.createSync(recursive: true);

  final maxOrders = rows.length < 10 ? rows.length : 10;
  for (var i = 0; i < maxOrders; i++) {
    final row = rows[i];
    if (row is! Map) continue;
    final map = Map<String, dynamic>.from(row);
    final serviceId = '${map['serviceId']}';
    final status = _int(map['status'] ?? map['srvStatus']);
    final custno = '${map['custno'] ?? map['custNo'] ?? ''}';
    final orgId = '${map['orgId'] ?? ''}';
    final prodType = '${map['prodType'] ?? ''}';
    final custId = '${map['custId'] ?? map['custIdno'] ?? map['idno'] ?? ''}';

    print('\n--- Order ${i + 1} serviceId=$serviceId status=$status ---');

    final summary = <String, dynamic>{
      'serviceId': serviceId,
      'status': status,
      'custno': custno,
      'orgId': orgId,
      'prodType': prodType,
      'custId': custId,
      'keys': map.keys.toList()..sort(),
    };

    summary['premiums'] = await _probeList(
      client,
      _premiumsPath(status),
      {'serviceId': serviceId},
      token,
      roleId,
      mcCode,
    );
    summary['penalty'] = await _probeList(
      client,
      _penaltyPath(status),
      {'serviceId': serviceId},
      token,
      roleId,
      mcCode,
    );
    summary['grantors'] = await _probeGrantors(
      client,
      status,
      serviceId,
      token,
      roleId,
      mcCode,
    );
    summary['docs'] = await _probeDocs(
      client,
      serviceId,
      token,
      roleId,
      mcCode,
    );
    if (custno.isNotEmpty && prodType.isNotEmpty) {
      summary['glStatement'] = await _probeGl(
        client,
        custno,
        prodType,
        token,
        roleId,
        mcCode,
      );
    }
    if (custno.isNotEmpty) {
      summary['microFinancialStudy'] = await _probeStudy(
        client,
        custno,
        serviceId,
        token,
        roleId,
        mcCode,
      );
    }
    if (custId.isNotEmpty) {
      summary['customerBasic'] = await _probeCustomerBasic(
        client,
        custId,
        token,
        roleId,
        mcCode,
      );
    }
    summary['wfReviews'] = await _probeWfReviews(
      client,
      serviceId,
      token,
      roleId,
      mcCode,
    );

    final file = File('${outDir.path}/order_${i + 1}_$serviceId.json');
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(summary),
    );
    print('  saved ${file.path}');
  }

  print('\nDone. Review tool/uat_probe_output/*.json');
  client.close();
}

Future<Map<String, dynamic>> _post(
  HttpClient client,
  String path,
  Map<String, dynamic> body, {
  required String? token,
  required String? roleId,
  String mcCode = '1',
}) async {
  final uri = Uri.parse(_root).resolve(path);
  final req = await client.postUrl(uri);
  req.headers.set('Content-Type', 'application/json; charset=utf-8');
  req.headers.set('Accept', 'application/json');
  req.headers.set('mcCode', mcCode);
  req.headers.set('x-current-lang', 'AR');
  req.headers.set(
    'Authorization',
    token == null || token.isEmpty ? 'null' : 'Bearer $token',
  );
  req.headers.set(
    'x-current-role',
    roleId == null || roleId.isEmpty ? 'null' : roleId,
  );
  req.write(jsonEncode(body));
  final res = await req.close();
  final text = await res.transform(utf8.decoder).join();
  try {
    return jsonDecode(text) as Map<String, dynamic>;
  } catch (_) {
    return {'raw': text, 'statusCode': res.statusCode};
  }
}

Future<Map<String, dynamic>> _get(
  HttpClient client,
  String path,
  Map<String, String> query, {
  required String token,
  required String roleId,
  required String mcCode,
}) async {
  final base = Uri.parse(_root).resolve(path);
  final uri = base.replace(
    queryParameters: {...base.queryParameters, ...query},
  );
  final req = await client.getUrl(uri);
  req.headers.set('Accept', 'application/json');
  req.headers.set('mcCode', mcCode);
  req.headers.set('x-current-lang', 'AR');
  req.headers.set('Authorization', 'Bearer $token');
  req.headers.set('x-current-role', roleId);
  final res = await req.close();
  final text = await res.transform(utf8.decoder).join();
  try {
    return jsonDecode(text) as Map<String, dynamic>;
  } catch (_) {
    return {'raw': text, 'statusCode': res.statusCode};
  }
}

Future<Map<String, dynamic>> _probeList(
  HttpClient client,
  String path,
  Map<String, String> query,
  String token,
  String roleId,
  String mcCode,
) async {
  final env = await _get(client, path, query, token: token, roleId: roleId, mcCode: mcCode);
  final list = _asList(env['result']);
  return {
    'path': path,
    'count': list.length,
    'sampleKeys': list.isNotEmpty && list.first is Map
        ? (list.first as Map).keys.toList()
        : [],
    'first': list.isNotEmpty ? list.first : null,
  };
}

Future<Map<String, dynamic>> _probeGrantors(
  HttpClient client,
  int status,
  String serviceId,
  String token,
  String roleId,
  String mcCode,
) async {
  final path = _grantorsPath(status);
  final env = await _get(
    client,
    path,
    {'serviceId': serviceId},
    token: token,
    roleId: roleId,
    mcCode: mcCode,
  );
  final result = env['result'];
  List list = const [];
  if (result is Map && result['data'] is List) {
    list = result['data'] as List;
  } else {
    list = _asList(result);
  }
  return {
    'path': path,
    'count': list.length,
    'sampleKeys': list.isNotEmpty && list.first is Map
        ? (list.first as Map).keys.toList()
        : [],
    'first': list.isNotEmpty ? list.first : null,
  };
}

Future<Map<String, dynamic>> _probeDocs(
  HttpClient client,
  String serviceId,
  String token,
  String roleId,
  String mcCode,
) async {
  final env = await _get(
    client,
    'query/docs/service',
    {'serviceId': serviceId},
    token: token,
    roleId: roleId,
    mcCode: mcCode,
  );
  final result = env['result'];
  final docs = result is Map ? result['docs'] : null;
  final list = docs is List ? docs : _asList(result);
  return {
    'count': list.length,
    'sampleKeys': list.isNotEmpty && list.first is Map
        ? (list.first as Map).keys.toList()
        : [],
    'first': list.isNotEmpty ? list.first : null,
  };
}

Future<Map<String, dynamic>> _probeGl(
  HttpClient client,
  String custNo,
  String prodType,
  String token,
  String roleId,
  String mcCode,
) async {
  final env = await _get(
    client,
    'query/glCustomerStatement',
    {'custNo': custNo, 'prodType': prodType},
    token: token,
    roleId: roleId,
    mcCode: mcCode,
  );
  final result = env['result'];
  final details = result is Map ? result['details'] : null;
  final list = details is List ? details : const [];
  return {
    'hasBalance': result is Map && result['curerntBalance'] != null,
    'detailsCount': list.length,
    'sampleDetailKeys': list.isNotEmpty && list.first is Map
        ? (list.first as Map).keys.toList()
        : [],
  };
}

Future<Map<String, dynamic>> _probeStudy(
  HttpClient client,
  String custNo,
  String serviceId,
  String token,
  String roleId,
  String mcCode,
) async {
  final env = await _get(
    client,
    'query/service/microFinancialStudy',
    {'custNo': custNo, 'serviceId': serviceId},
    token: token,
    roleId: roleId,
    mcCode: mcCode,
  );
  final list = _asList(env['result']);
  return {
    'count': list.length,
    'keys': list.isNotEmpty && list.first is Map
        ? (list.first as Map).keys.toList()
        : [],
  };
}

Future<Map<String, dynamic>> _probeCustomerBasic(
  HttpClient client,
  String idno,
  String token,
  String roleId,
  String mcCode,
) async {
  final env = await _get(
    client,
    'cif/customersBasic/$idno',
    {},
    token: token,
    roleId: roleId,
    mcCode: mcCode,
  );
  final result = env['result'];
  return {
    'ok': result is Map,
    'keyCount': result is Map ? result.keys.length : 0,
  };
}

Future<Map<String, dynamic>> _probeWfReviews(
  HttpClient client,
  String serviceId,
  String token,
  String roleId,
  String mcCode,
) async {
  final env = await _get(
    client,
    'query/service/wfReviews',
    {'serviceId': serviceId},
    token: token,
    roleId: roleId,
    mcCode: mcCode,
  );
  final result = env['result'];
  final reviews = result is Map ? result['wfReviews'] : null;
  final list = reviews is List ? reviews : const [];
  return {'reviewCount': list.length};
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

List _asList(dynamic result) {
  if (result is List) return result;
  if (result is Map) {
    for (final k in const ['data', 'content', 'rows', 'result']) {
      final v = result[k];
      if (v is List) return v;
    }
  }
  return const [];
}

int? _total(Map env, dynamic result) {
  for (final k in const [
    'totalCount',
    'totalRecords',
    'total',
    'rowTotalCount',
  ]) {
    final v = env[k] ?? (result is Map ? result[k] : null);
    if (v is num) return v.toInt();
  }
  return null;
}

int _int(dynamic v) {
  if (v is num) return v.toInt();
  return int.tryParse('$v') ?? 0;
}
