import 'dart:convert';

/// Turns UTF-8 text that was read as Latin-1 back into Arabic.
String decodeApiText(String value) {
  if (!value.contains('Ø') && !value.contains('Ù') && !value.contains('Ã')) {
    return value;
  }
  try {
    return utf8.decode(latin1.encode(value));
  } catch (_) {
    return value;
  }
}
