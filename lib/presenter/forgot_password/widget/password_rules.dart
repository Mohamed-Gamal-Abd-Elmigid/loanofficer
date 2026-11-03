bool isStrongPassword(String password, String confirm) {
  return passwordRuleMessage(password) == null && password == confirm;
}

/// What the password is still missing. Empty text has no message yet.
String? passwordRuleMessage(String password) {
  if (password.isEmpty) return null;
  final missing = <String>[];
  if (password.length < 8) missing.add('8 أحرف على الأقل');
  if (!_has(password, RegExp(r'[A-Z]'))) missing.add('حرف إنجليزي كبير');
  if (!_has(password, RegExp(r'[a-z]'))) missing.add('حرف إنجليزي صغير');
  if (!_has(password, RegExp(r'[0-9]'))) missing.add('رقم');
  if (!_has(password, RegExp(r'[!@#\$%&*]'))) {
    missing.add('رمز مثل !@#\$%&*');
  }
  if (missing.isEmpty) return null;
  return 'كلمة المرور يجب أن تحتوي على ${missing.join('، ')}';
}

/// Shown under the confirm field when the two passwords differ.
String? confirmPasswordMessage(String password, String confirm) {
  if (confirm.isEmpty) return null;
  if (password != confirm) return 'كلمتا المرور غير متطابقتين';
  return null;
}

bool _has(String value, RegExp pattern) => pattern.hasMatch(value);
