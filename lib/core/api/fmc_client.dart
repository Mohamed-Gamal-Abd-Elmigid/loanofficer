import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/api_text.dart';
import 'package:loanofficer/core/api/fmc_platform_client_web.dart'
    if (dart.library.io) 'package:loanofficer/core/api/fmc_platform_client_io.dart';
import 'package:loanofficer/core/api/fmc_session.dart';
import 'package:loanofficer/core/config/fmc_config.dart';

/// Speaks the Fusion HTTP envelope: headers, `result`, and `errors[].msg`.
class FmcClient {
  FmcClient({http.Client? httpClient, FmcSession? session})
    : _http = httpClient ?? createFmcPlatformClient(),
      _session = session ?? FmcSession.instance;

  final http.Client _http;
  final FmcSession _session;

  Future<dynamic> get(String path, {Map<String, String>? query}) {
    return _send('GET', path, query: query);
  }

  Future<dynamic> post(String path, Object? body) {
    return _send('POST', path, body: body);
  }

  Future<dynamic> put(String path, Object? body) {
    return _send('PUT', path, body: body);
  }

  Future<dynamic> delete(String path) {
    return _send('DELETE', path);
  }

  Future<dynamic> _send(
    String method,
    String path, {
    Object? body,
    Map<String, String>? query,
  }) async {
    final request = http.Request(method, _uri(path, query));
    request.headers.addAll(_headers);
    if (body != null) {
      request.body = jsonEncode(body);
    }
    final streamed = await _http.send(request);
    final response = await http.Response.fromStream(streamed);
    return _decode(response);
  }

  Map<String, String> get _headers {
    final token = _session.token;
    final role = _session.roleId;
    return {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
      'mcCode': _session.mcCode ?? '1',
      'x-current-lang': 'AR',
      'Authorization': token == null || token.isEmpty
          ? 'null'
          : 'Bearer $token',
      'x-current-role': role == null || role.isEmpty ? 'null' : role,
    };
  }

  Uri _uri(String path, Map<String, String>? query) {
    final uri = Uri.parse(FmcConfig.apiRoot).resolve(path);
    if (query == null || query.isEmpty) return uri;
    return uri.replace(queryParameters: {...uri.queryParameters, ...query});
  }

  dynamic _decode(http.Response response) {
    final text = decodeApiText(utf8.decode(response.bodyBytes));
    Map<String, dynamic>? json;
    if (text.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(text);
        if (decoded is Map<String, dynamic>) {
          json = decoded;
        } else if (decoded is Map) {
          json = Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}
    }

    if (response.statusCode == 307) {
      throw AuthApiException('يجب تغيير كلمة المرور');
    }

    if (json != null) {
      final status = '${json['status'] ?? ''}'.toUpperCase();
      final failedStatus =
          status == 'UNAUTHORIZED' ||
          status == 'EXCEPTION' ||
          status == 'ERROR' ||
          status == 'FAILED' ||
          status == 'FAIL';
      final errors = json['errors'];
      final hasErrors = errors is List && errors.isNotEmpty;
      if (response.statusCode >= 400 || failedStatus || hasErrors) {
        throw AuthApiException(
          _errorMessage(json) ??
              (status == 'UNAUTHORIZED'
                  ? 'بيانات الدخول غير صحيحة'
                  : 'تعذر إكمال الطلب'),
        );
      }
      return json['result'];
    }

    if (response.statusCode >= 400) {
      throw AuthApiException(
        response.statusCode == 401
            ? 'بيانات الدخول غير صحيحة'
            : 'تعذر إكمال الطلب',
      );
    }
    return null;
  }

  String? _errorMessage(Map<String, dynamic> json) {
    final errors = json['errors'];
    if (errors is List) {
      for (final error in errors) {
        if (error is Map) {
          final msg = error['msg'];
          if (msg is String && msg.trim().isNotEmpty) {
            return decodeApiText(msg.trim());
          }
        }
      }
    }
    final messages = json['messages'];
    if (messages is List && messages.isNotEmpty) {
      final first = messages.first;
      if (first is String && first.trim().isNotEmpty) {
        return decodeApiText(first.trim());
      }
    }
    return null;
  }
}
