import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/theme/app_colors.dart';

/// Fingerprint + Face ID login control (red tile, white glyph).
class BiometricMark extends StatelessWidget {
  const BiometricMark({super.key, this.size = 50, this.onPressed});

  static const assetPath = 'assets/images/biometric_face_id.png';

  final double size;
  final VoidCallback? onPressed;

  /// White glyph with alpha from luminance (source art is white on black).
  static const ColorFilter _glyphFilter = ColorFilter.matrix(<double>[
    0, 0, 0, 0, 255,
    0, 0, 0, 0, 255,
    0, 0, 0, 0, 255,
    0.2126, 0.7152, 0.0722, 0, 0,
  ]);

  @override
  Widget build(BuildContext context) {
    final side = size.r;
    final radius = (size * 0.24).r.clamp(10.r, 16.r);
    return SizedBox(
      width: side,
      height: side,
      child: Material(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(radius),
        elevation: 0,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(radius),
          splashColor: AppColors.white.withValues(alpha: 0.12),
          highlightColor: AppColors.white.withValues(alpha: 0.08),
          child: Padding(
            padding: EdgeInsets.all(side * 0.17),
            child: ColorFiltered(
              colorFilter: _glyphFilter,
              child: Image.asset(
                assetPath,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                semanticLabel: 'تسجيل الدخول بالبصمة أو الوجه',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
