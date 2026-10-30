import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/theme/app_colors.dart';

class BiometricMark extends StatelessWidget {
  const BiometricMark({super.key, this.size = 50, this.onPressed});

  final double size;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final side = size.r;
    return SizedBox(
      width: side,
      height: side,
      child: Material(
        color: const Color(0xFFE14B4B),
        borderRadius: BorderRadius.circular(side * 0.22),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(side * 0.22),
          child: Padding(
            padding: EdgeInsets.all(side * 0.18),
            child: const CustomPaint(painter: _BiometricGlyphPainter()),
          ),
        ),
      ),
    );
  }
}

class _BiometricGlyphPainter extends CustomPainter {
  const _BiometricGlyphPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final cx = size.width * 0.5;
    final cy = size.height * 0.5;

    canvas.drawLine(
      Offset(cx, size.height * 0.08),
      Offset(cx, size.height * 0.92),
      stroke,
    );

    final origin = Offset(cx - size.width * 0.04, cy + size.height * 0.04);
    for (var i = 0; i < 4; i++) {
      final radius = size.width * (0.14 + i * 0.12);
      canvas.drawArc(
        Rect.fromCircle(center: origin, radius: radius),
        2.05,
        2.15,
        false,
        stroke,
      );
    }

    final faceStroke = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final inset = size.width * 0.08;
    final right = size.width - inset;
    final top = size.height * 0.16;
    final bottom = size.height * 0.84;
    final arm = size.width * 0.22;

    canvas.drawPath(
      Path()
        ..moveTo(cx + inset, top)
        ..lineTo(right, top)
        ..lineTo(right, top + arm),
      faceStroke,
    );
    canvas.drawPath(
      Path()
        ..moveTo(right, bottom - arm)
        ..lineTo(right, bottom)
        ..lineTo(cx + inset, bottom),
      faceStroke,
    );

    final feature = Paint()
      ..color = AppColors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width * 0.08;
    canvas.drawLine(
      Offset(cx + size.width * 0.22, cy - size.height * 0.08),
      Offset(cx + size.width * 0.22, cy + size.height * 0.02),
      feature,
    );
    canvas.drawLine(
      Offset(cx + size.width * 0.34, cy + size.height * 0.04),
      Offset(cx + size.width * 0.34, cy + size.height * 0.16),
      feature,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(cx + size.width * 0.26, cy + size.height * 0.28),
        width: size.width * 0.18,
        height: size.height * 0.12,
      ),
      0.2,
      2.6,
      false,
      faceStroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
