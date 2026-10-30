import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';

enum AppButtonKind { primary, neutral }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.kind = AppButtonKind.primary,
    this.height = 52,
    this.radius = 12,
    this.backgroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonKind kind;
  final double height;
  final double radius;
  final Color? backgroundColor;

  bool get _enabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final enabledColor =
        backgroundColor ??
        (kind == AppButtonKind.primary
            ? AppColors.primary
            : AppColors.buttonNeutral);
    final enabledText = kind == AppButtonKind.primary
        ? AppColors.white
        : AppColors.buttonNeutralText;

    final buttonHeight = kIsWeb ? height : height.h;
    final buttonRadius = kIsWeb ? radius : radius.r;
    final labelSize = kIsWeb ? 16.0 : 16.sp;
    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: _enabled ? enabledColor : AppColors.buttonNeutral,
          disabledBackgroundColor: AppColors.buttonNeutral,
          foregroundColor: enabledText,
          disabledForegroundColor: AppColors.buttonDisabledText,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: TextStyle(
            fontFamily: AppFonts.dinNextArabic,
            fontSize: labelSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
