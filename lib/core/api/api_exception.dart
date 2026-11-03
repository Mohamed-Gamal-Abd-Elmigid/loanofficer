import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    PlatformException(:final code, :final message) =>
      _platformMessage(code, message),
    _ => _fallback(error),
  };
  return _knownMessage(message);
}

/// PDF preview (pdfx) — plugin errors are not FMC network failures.
String documentPreviewErrorMessage(Object error) {
  if (error is PlatformException) {
    return _platformMessage(error.code, error.message);
  }
  final text = error.toString().toLowerCase();
  if (text.contains('pdf') ||
      text.contains('render') ||
      text.contains('platformexception') ||
      text.contains('channel')) {
    return 'تعذر عرض المستند. استخدم «تحميل على الجهاز» لفتح الملف.';
  }
  final api = apiErrorMessage(error);
  if (api == 'تعذر الاتصال بالخادم') {
    return 'تعذر عرض المستند. استخدم «تحميل على الجهاز» لفتح الملف.';
  }
  return api;
}

String _platformMessage(String code, String? message) {
  final codeLower = code.toLowerCase();
  final msgLower = '${message ?? ''}'.toLowerCase();
  if (codeLower.contains('channel') ||
      msgLower.contains('channel') ||
      (msgLower.contains('platform') && msgLower.contains('connection'))) {
    return 'تعذر فتح المعاينة على الجهاز. أعد تشغيل التطبيق أو استخدم «تحميل على الجهاز».';
  }
  if (message != null && message.trim().isNotEmpty) {
    return message.trim();
  }
  return 'تعذر إكمال الطلب';
}

String _fallback(Object error) {
  final text = error.toString().toLowerCase();
  if (_looksLikeNetworkFailure(text)) {
    return 'تعذر الاتصال بالخادم';
  }
  final raw = error.toString().trim();
  if (raw.isNotEmpty && !raw.startsWith('Exception')) return raw;
  return 'تعذر إكمال الطلب';
}

bool _looksLikeNetworkFailure(String text) {
  return text.contains('socketexception') ||
      text.contains('clientexception') ||
      text.contains('failed host lookup') ||
      text.contains('network is unreachable') ||
      text.contains('connection refused') ||
      text.contains('connection timed out') ||
      text.contains('connection reset') ||
      text.contains('handshake exception') ||
      (text.contains('network') && text.contains('unavailable'));
}

String _knownMessage(String message) {
  final lower = message.toLowerCase();
  if (lower.contains('same_password') ||
      lower.contains('different from the old password')) {
    return 'كلمة المرور الجديدة يجب أن تختلف عن كلمة المرور القديمة.';
  }
  if (lower.contains('upload_suspicious') ||
      lower.contains('محتوى مشبوه')) {
    return '❌ الملف مرفوض — يرجى رفع PDF آخر (الصور تُحوَّل تلقائياً؛ جرّب تصدير المستند كـ PDF من جديد).';
  }
  if (lower.contains('access denied')) {
    return 'لا صلاحية لعرض هذه البيانات';
  }
  return message;
}

void showAuthError(BuildContext context, Object error) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(apiErrorMessage(error))));
}
