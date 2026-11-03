import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/theme/app_typography.dart';

/// Validation line under inputs. Collapses to zero height until [message] is set
/// or [reserveWhenEmpty] is true (after the form enters validation mode).
class FieldErrorSlot extends StatelessWidget {
  const FieldErrorSlot({
    super.key,
    this.message,
    this.maxLines = 2,
    this.reserveWhenEmpty = false,
  });

  final String? message;
  final int maxLines;
  final bool reserveWhenEmpty;

  static double reservedHeight({int maxLines = 2}) {
    if (kIsWeb) return maxLines <= 1 ? 18.0 : 30.0;
    return maxLines <= 1 ? 18.h : 30.h;
  }

  bool get _visible => message != null && message!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (!_visible && !reserveWhenEmpty) {
      return const SizedBox.shrink();
    }

    final fontSize = kIsWeb ? 12.0 : 12.sp;
    return SizedBox(
      height: reservedHeight(maxLines: maxLines),
      child: Padding(
        padding: EdgeInsets.only(top: kIsWeb ? 3 : 3.h),
        child: Align(
          alignment: Alignment.topRight,
          child: Text(
            _visible ? message!.trim() : '\u200b',
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              color: _visible ? const Color(0xFFE14B4B) : Colors.transparent,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
