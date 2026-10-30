import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/theme/app_colors.dart';

class AppFieldLabel extends StatelessWidget {
  const AppFieldLabel(
    this.text, {
    super.key,
    this.color = AppColors.navyLabel,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w700,
  });

  const AppFieldLabel.muted(this.text, {super.key})
    : color = AppColors.fieldLabel,
      fontSize = 13,
      fontWeight = FontWeight.w600;

  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        color: color,
        fontSize: kIsWeb ? fontSize : fontSize.sp,
        fontWeight: fontWeight,
      ),
    );
  }
}
