import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthApiException implements Exception {
  AuthApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

String apiErrorMessage(Object error) {
  final message = switch (error) {
    AuthApiException(:final message) => message,
    http.ClientException _ => 'تعذر الاتصال بالخادم',
    _ => _fallback(error),
  };
  return _knownMessage(message);
}

String _fallback(Object error) {
  final text = error.toString().toLowerCase();
  if (text.contains('socket') ||
      text.contains('network') ||
      text.contains('failed host') ||
      text.contains('handshake') ||
      text.contains('connection')) {
    return 'تعذر الاتصال بالخادم';
  }
  final raw = error.toString().trim();
  if (raw.isNotEmpty && !raw.startsWith('Exception')) return raw;
  return 'تعذر إكمال الطلب';
}

String _knownMessage(String message) {
  final lower = message.toLowerCase();
  if (lower.contains('same_password') ||
      lower.contains('different from the old password')) {
    return 'كلمة المرور الجديدة يجب أن تختلف عن كلمة المرور القديمة.';
  }
  return message;
}

void showAuthError(BuildContext context, Object error) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(apiErrorMessage(error))));
}
