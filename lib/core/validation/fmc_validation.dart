/// Fusion checks from `CustomValidation` and the Arabic `VALIDATION-MESSAGES`.
///
/// Screens copy the website by calling these methods. A null result means the
/// value is accepted. Empty values pass the format checks; [required] is separate,
/// the same way Angular `Validators.required` is separate from a pattern.
class FmcValidation {
  const FmcValidation._();

  static const requiredMessage = 'هذا الحقل مطلوب';
  static const fillFormMessage = 'الرجاء تعبئة الحقول المطلوبة';
  static const ceilingMessage = 'برجاء تقريب الرقم الى اقرب 500';
  static const amountMaxMessage =
      'لا يمكن ادخال مبلغ اكبر من المبلغ المحدد  لمسئول التمويل';
  static const installmentsMessage = 'قيمة القسط غير مناسبة مع المنتج';
  static const nationalIdMessage = 'برجاء ادخال الرقم القومى بشكل صحيح';
  static const mobileMessage =
      'يجب انا يكون الحقل مكون من 11 رقم ويبدا ب (010 , 011 , 012 , 015)';
  static const landlineMessage = 'يجب انا يكون الحقل مكون من 10 رقم ويبدا ب 0';
  static const emailMessage = 'برجاء إدخال بريد إلكتروني صحيح';
  static const numericMessage = 'يجب ان يحتوي ارقام فقط';
  static const greaterThanZeroMessage = 'برجاء ادخال قيمة اكبر من 0';
  static const negativeMessage = ' لا يجب ان يكون بالسالب';
  static const arabicMessage = 'هذا الحقل يجب ان يحتوي حروف عربي فقط';
  static const englishMessage = 'يجب إدخال بيانات باللغة الإنجليزية فقط';
  static const spacesMessage = 'هذا الحقل لا يمكن ان يحتوي مسافات';
  static const startSpaceMessage = 'هذا الحقل لا يمكن أن يبدأ بمسافة';
  static const minLengthMessage = 'هذا الحقل لا يقبل احرف أقل من 2 حروف';
  static const guarantorIsClientMessage =
      'العميل المستفيد من التمويل لا يمكن تغذيته كضامن.';
  static const sameGuarantorOrderMessage =
      'لا يمكن ان يكون الضامنين بنفس الترتيب';

  static final RegExp _nationalId = RegExp(
    r'^(2|3)\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])\d{7}$',
  );
  static final RegExp _mobile = RegExp(r'^(010|011|012|015)\d{8}$');
  static final RegExp _landline = RegExp(r'^0\d{9}$');
  static final RegExp _digits = RegExp(r'^[0-9]+$');
  /// Local@domain.tld — Fusion-style email (ASCII only, no spaces).
  static final RegExp _email = RegExp(
    r'^[A-Za-z0-9](?:[A-Za-z0-9._%+\-]*[A-Za-z0-9])?@[A-Za-z0-9](?:[A-Za-z0-9.\-]*[A-Za-z0-9])?\.[A-Za-z]{2,}$',
  );
  static final RegExp _arabic = RegExp(r'^[\u0600-\u06FF ]+$');
  static final RegExp _english = RegExp(r'^[a-zA-Z ]+$');
  static final RegExp _englishNoSpace = RegExp(r'^[a-zA-Z]+$');
  static final RegExp _englishPattern = RegExp(r'^[a-zA-Z0-9]+$');
  static final RegExp _arabicAlphaNumeric = RegExp(
    r'^[\u0600-\u06FF0-9\s\-%]+$',
  );
  static final RegExp _englishArabicAlphaNumeric = RegExp(
    r'^[\u0600-\u06FFa-zA-Z0-9\s]+$',
  );
  static final RegExp _englishArabicAlpha = RegExp(
    r'^[\u0600-\u06FFA-Za-z\s]+$',
  );
  static final RegExp _alphaOnly = RegExp(r'^[a-zA-Z\u0621-\u064A\s]*$');
  static final RegExp _englishAlphaNumeric = RegExp(r'^[a-zA-Z0-9\s\-%]+$');
  static final RegExp _firstLetter = RegExp(r'^[\u0600-\u06FFa-zA-Z0-9].*$');
  static final RegExp _specialStart = RegExp(r'^[^a-zA-Z0-9\u0600-\u06FF]');
  static final RegExp _arabicOnlyWord = RegExp(r'^[\u0600-\u06FF]+$');
  static final RegExp _mapsLink = RegExp(
    r'^https:\/\/maps\.app\.goo\.gl\/[A-Za-z0-9]+(\?.*)?$',
  );
  static final RegExp _currency = RegExp(
    r'^(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d{1,2})?$',
  );

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) return requiredMessage;
    return null;
  }

  static String? nationalId(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final text = value.trim();
    if (text == '0' || !_nationalId.hasMatch(text)) return nationalIdMessage;
    return null;
  }

  static String? requiredNationalId(String? value) {
    return required(value) ?? nationalId(value);
  }

  /// Digits only; if user typed 10 digits starting 10/11/12/15, prefix `0`.
  static String normalizeEgyptianMobile(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (RegExp(r'^(10|11|12|15)\d{8}$').hasMatch(digits)) {
      return '0$digits';
    }
    return digits;
  }

  /// Fusion `startWith01Validator`: an Egyptian mobile is 11 digits and starts
  /// with 010, 011, 012, or 015. An empty value is accepted here.
  static String? mobile(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final normalized = normalizeEgyptianMobile(value);
    if (!_mobile.hasMatch(normalized)) return mobileMessage;
    return null;
  }

  static String? requiredMobile(String? value) {
    return required(value) ?? mobile(value);
  }

  static String? landline(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (!_landline.hasMatch(value.trim())) return landlineMessage;
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final text = value.trim();
    if (text.contains(RegExp(r'\s')) ||
        text.contains('..') ||
        text.startsWith('.') ||
        text.startsWith('@') ||
        text.endsWith('.') ||
        text.endsWith('@') ||
        text.runes.any((code) => code > 127) ||
        !_email.hasMatch(text)) {
      return emailMessage;
    }
    return null;
  }

  static String? requiredEmail(String? value) {
    return required(value) ?? email(value);
  }

  /// Live optional-email error: empty is OK; invalid format shows immediately.
  static String? emailLive(String? value) => email(value);

  static String? numeric(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (!_digits.hasMatch(value.trim())) return numericMessage;
    return null;
  }

  static String? greaterThanZero(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty || !_digits.hasMatch(text)) return null;
    if ((num.tryParse(text) ?? 0) <= 0) return greaterThanZeroMessage;
    return null;
  }

  static String? notNegative(String? value) {
    final number = num.tryParse(value?.trim() ?? '');
    if (number == null) return null;
    if (number < 0) return negativeMessage;
    return null;
  }

  static String? arabicOnly(String? value) =>
      _pattern(value, _arabic, arabicMessage);

  /// Required Arabic name part (no Latin / digits), max 15 characters.
  static String? requiredArabicNamePart(String? value) {
    final requiredError = required(value);
    if (requiredError != null) return requiredError;
    final text = value!.trim();
    if (text.length > 15) {
      return 'هذا الحقل لا يقبل اكثر من 15 حرف';
    }
    return arabicOnly(text);
  }

  static String? englishOnly(String? value) =>
      _pattern(value, _english, englishMessage);

  static String? englishOnlyNoSpaces(String? value) =>
      _pattern(value, _englishNoSpace, englishMessage);

  static String? englishPattern(String? value) => _pattern(
    value,
    _englishPattern,
    'هذا الحقل يقبل احرف إنجليزية و ارقام فقط',
  );

  static String? noSpaces(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return null;
    if (RegExp(r'\s').hasMatch(text)) return spacesMessage;
    return null;
  }

  static String? startSpace(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return null;
    if (text.startsWith(RegExp(r'\s'))) return startSpaceMessage;
    return null;
  }

  static String? minTwoCharacters(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return null;
    if (text.length < 2) return minLengthMessage;
    return null;
  }

  /// Fusion `getReqAmount`: empty or zero is required, the amount must be a
  /// multiple of 500, and it cannot pass the product ceiling.
  static String? requestedAmount(String? raw, num? maxAmount) {
    final amount = num.tryParse((raw ?? '').trim());
    if (amount == null || amount == 0) return requiredMessage;
    final ceiling = (amount / 500).ceil() * 500;
    if (ceiling != amount) return ceilingMessage;
    if (maxAmount != null && amount > maxAmount) return amountMaxMessage;
    return null;
  }

  /// Fusion `getReqNoOfksts`: empty is required, zero or a count above the
  /// product limit is rejected.
  /// Fusion fund-track search: optional national ID and service id filters.
  static String? fundTrackCustId(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return null;
    return nationalId(text);
  }

  static String? fundTrackServiceId(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return null;
    return numeric(text);
  }

  static String? fundTrackServiceIdRequired(String? value) {
    return required(value) ?? fundTrackServiceId(value);
  }

  static String? requestedInstallments(String? raw, num? maxCount) {
    final text = (raw ?? '').trim();
    if (text.isEmpty) return requiredMessage;
    final count = num.tryParse(text);
    if (count == null || count == 0) return installmentsMessage;
    if (maxCount != null && count > maxCount) return installmentsMessage;
    return null;
  }

  static String? _pattern(String? value, RegExp pattern, String message) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    if (!pattern.hasMatch(text)) return message;
    return null;
  }

  static String? arabicAlphaNumeric(String? value) => _pattern(
    value,
    _arabicAlphaNumeric,
    'هذا الحقل يقبل احرف عربية و ارقام فقط',
  );

  static String? englishArabicAlphaNumeric(String? value) => _pattern(
    value,
    _englishArabicAlphaNumeric,
    'يُسمح فقط بالحروف العربية والإنجليزية والأرقام والمسافات، ولا يُسمح باستخدام الرموز الخاصة',
  );

  static String? firstLetter(String? value) {
    final text = value ?? '';
    if (text.trim().isEmpty) return null;
    if (!_firstLetter.hasMatch(text)) {
      return 'يجب أن يبدأ النص بحرف عربي أو إنجليزي أو رقم';
    }
    return null;
  }

  static String? englishArabicAlpha(String? value) =>
      _pattern(value, _englishArabicAlpha, 'يجب ادخال احرف فقط في هذا الحقل');

  static String? alphaOnly(String? value) => _pattern(
    value,
    _alphaOnly,
    'هذا الحقل يقبل الأحرف والمسافات فقط، الرجاء عدم إدخال أرقام أو رموز',
  );

  static String? englishAlphaNumeric(String? value) => _pattern(
    value,
    _englishAlphaNumeric,
    'هذا الحقل يقبل احرف إنجليزي و ارقام فقط',
  );

  static String? specialStart(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    if (_specialStart.hasMatch(text)) {
      return 'هذا الحقل لايمكن ان يبدأ برموز خاصة';
    }
    return null;
  }

  static String? passwordNotArabic(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    if (_arabicOnlyWord.hasMatch(text)) {
      return 'لايمكن ادخال احرف عربي في هذا الحقل';
    }
    return null;
  }

  static String? googleMapsLink(String? value) =>
      _pattern(value, _mapsLink, 'برجاء ادخال لينك لجوجل ماب صحيح');

  static String? currency(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    if (!_currency.hasMatch(text)) return 'برجاء إدخال قيمة عملة صحيحة';
    return null;
  }

  static String? totalRevenue(String? value) {
    final number = num.tryParse(value?.trim() ?? '');
    if (number != null && number > 83000) {
      return 'لقد تجاوز الحد الأقصى من الإيرادات';
    }
    return null;
  }

  static DateTime? fusionDate(String? value) {
    final parts = (value ?? '').split('/');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    return DateTime(year, month, day);
  }

  static String? afterAppDate(String? value, DateTime appDate) {
    final date = fusionDate(value);
    if (date == null) return null;
    if (!date.isAfter(DateTime(appDate.year, appDate.month, appDate.day))) {
      return 'هذا التاريخ يجب أن  يتعدى تاريخ اليومية';
    }
    return null;
  }

  static String? beforeAppDate(String? value, DateTime appDate) {
    final date = fusionDate(value);
    if (date == null) return null;
    if (!date.isBefore(DateTime(appDate.year, appDate.month, appDate.day))) {
      return 'هذا التاريخ يجب أن لا يتعدى تاريخ اليومية';
    }
    return null;
  }

  static String? onOrBeforeAppDate(String? value, DateTime appDate) {
    final date = fusionDate(value);
    if (date == null) return null;
    final day = DateTime(appDate.year, appDate.month, appDate.day);
    if (date.isAfter(day)) {
      return 'هذا التاريخ يجب أن يكون اقل من او يساوي تاريخ اليومية';
    }
    return null;
  }
}
