import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:loanofficer/core/api/api_text.dart';

/// Prints the URL, request body, and response for every FMC call.
class ApiLogClient extends http.BaseClient {
  ApiLogClient([http.Client? inner]) : _inner = inner ?? http.Client();

  final http.Client _inner;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final requestBody = request is http.Request ? request.body : '';
    if (kDebugMode) {
      debugPrint('API → ${request.method} ${request.url}');
      if (requestBody.isNotEmpty) {
        debugPrint('API request: $requestBody');
      }
    }

    try {
      final response = await _inner.send(request);
      final bytes = await response.stream.toBytes();
      final responseBody = decodeApiText(
        utf8.decode(bytes, allowMalformed: true),
      );
      if (kDebugMode) {
        debugPrint('API ← ${response.statusCode} ${request.url}');
        if (responseBody.isNotEmpty) {
          debugPrint('API response: $responseBody');
        }
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
        debugPrint('API ✕ ${request.method} ${request.url}');
        debugPrint('API error: $error');
      }
      rethrow;
    }
  }

  @override
  void close() => _inner.close();
}
