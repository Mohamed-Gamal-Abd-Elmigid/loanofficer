import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class AppFonts {
  const AppFonts._();

  static const dinNextArabic = 'DIN Next LT Arabic';
}

class AppTypography {
  const AppTypography._();

  /// App bar title: DIN Next LT Arabic, medium, 24px, line height 100%.
  static TextStyle appBar({Color? color}) {
    return TextStyle(
      fontFamily: AppFonts.dinNextArabic,
      fontWeight: FontWeight.w500,
      fontSize: 24.sp,
      height: 1,
      letterSpacing: 0,
      color: color,
    );
  }
}
