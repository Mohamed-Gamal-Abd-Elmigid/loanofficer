import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/theme/app_colors.dart';

class AppLogoRow extends StatelessWidget {
  const AppLogoRow({
    super.key,
    this.fmcHeight = 42,
    this.tanmeyahHeight = 38,
    this.gap = 12,
    this.dividerHeight = 34,
  });

  final double fmcHeight;
  final double tanmeyahHeight;
  final double gap;
  final double dividerHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.ltr,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo_fmc.png',
          height: fmcHeight.h,
          fit: BoxFit.contain,
        ),
        SizedBox(width: gap.w),
        SizedBox(
          height: dividerHeight.h,
          child: const VerticalDivider(
            width: 1,
            thickness: 1,
            color: AppColors.divider,
          ),
        ),
        SizedBox(width: gap.w),
        Image.asset(
          'assets/images/logo_tanmeyah.png',
          height: tanmeyahHeight.h,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
