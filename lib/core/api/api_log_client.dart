import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:loanofficer/core/api/api_text.dart';

/// Prints one block per FMC call: url, status, headers, and response.
class ApiLogClient extends http.BaseClient {
  ApiLogClient([http.Client? inner]) : _inner = inner ?? http.Client();

  final http.Client _inner;
  static Future<void> _queue = Future<void>.value();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final requestBody = request is http.Request ? request.body : '';
    try {
      final response = await _inner.send(request);
      final bytes = await response.stream.toBytes();
      final responseBody = decodeApiText(
        utf8.decode(bytes, allowMalformed: true),
      );
      if (kDebugMode) {
        await _printSection(
          method: request.method,
          url: request.url,
          status: '${response.statusCode}',
          headers: request.headers,
          body: responseBody.isEmpty ? '<empty>' : responseBody,
          requestBody: requestBody,
        );
      }
      return http.StreamedResponse(
        http.ByteStream.fromBytes(bytes),
        response.statusCode,
        contentLength: bytes.length,
        request: request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    } catch (error) {
      if (kDebugMode) {
        await _printSection(
          method: request.method,
          url: request.url,
          status: 'failed',
          headers: request.headers,
          body: '$error',
          requestBody: requestBody,
        );
      }
      rethrow;
    }
  }

  Future<void> _printSection({
    required String method,
    required Uri url,
    required String status,
    required Map<String, String> headers,
    required String body,
    required String requestBody,
  }) {
    final lines = <String>[
      '──────── API',
      'url: $method $url',
      'status: $status',
      'headers: $headers',
      if (requestBody.isNotEmpty) 'request: $requestBody',
      ..._bodyLines(body),
      '────────',
    ];
    final done = _queue.then((_) {
      for (final line in lines) {
        debugPrint(line);
      }
    });
    _queue = done.catchError((_) {});
    return done;
  }

  List<String> _bodyLines(String body) {
    const size = 700;
    if (body.length <= size) return ['response: $body'];
    final lines = <String>[];
    for (var start = 0; start < body.length; start += size) {
      final end = start + size > body.length ? body.length : start + size;
      lines.add('response: ${body.substring(start, end)}');
    }
    return lines;
  }

  @override
  void close() => _inner.close();
}
