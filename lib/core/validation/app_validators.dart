class AppValidators {
  const AppValidators._();

  static final RegExp _tanmeyahEmail = RegExp(
    r'^[a-z0-9._%+\-]+@tanmeyah\.com$',
  );
  static final RegExp _phoneNumber = RegExp(r'^\d{11}$');

  static const String tanmeyahDomain = 'tanmeyah.com';

  static const String emailMessage =
      'الايميل يجب أن يكون مثل example@tanmeyah.com';
  static const String phoneMessage = 'رقم الهاتف يجب أن يكون 11 رقم';

  static bool isTanmeyahEmail(String value) {
    return _tanmeyahEmail.hasMatch(value.trim().toLowerCase());
  }

  static bool isPhoneNumber(String value) {
    return _phoneNumber.hasMatch(value.trim());
  }

  /// When the user types `@` and nothing after it, complete `@tanmeyah.com`.
  static String? withTanmeyahDomain(String value) {
    return completeTanmeyahEmail(previous: '', current: value);
  }

  /// Completes the domain when `@` is entered.
  ///
  /// [previous] is the text before this keystroke, so an `@` inserted at the
  /// start of a right-to-left field (`@maged`) still becomes `maged@tanmeyah.com`.
  static String? completeTanmeyahEmail({
    required String previous,
    required String current,
  }) {
    if (!current.contains('@')) return null;
    final suffix = '@$tanmeyahDomain';
    if (current.toLowerCase().endsWith(suffix) &&
        '@'.allMatches(current).length == 1) {
      return null;
    }

    final insertedAt =
        !previous.contains('@') && current.replaceFirst('@', '') == previous;
    final atEnd = current.endsWith('@') && '@'.allMatches(current).length == 1;
    if (!insertedAt && !atEnd) return null;

    final local =
        (insertedAt ? previous : current.substring(0, current.length - 1))
            .trim();
    return '$local$suffix';
  }
}
