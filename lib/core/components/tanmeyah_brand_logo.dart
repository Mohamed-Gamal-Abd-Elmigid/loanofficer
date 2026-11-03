import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// Tanmeyah wordmark (Arabic + English) — login and main shell header.
class TanmeyahBrandLogo extends StatelessWidget {
  const TanmeyahBrandLogo({super.key, this.height = 40});

  static const assetPath = 'assets/images/logo_tanmeyah_brand.png';

  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      height: height.h,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}
