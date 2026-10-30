import 'package:flutter/material.dart';
import 'package:loanofficer/core/theme/app_colors.dart';

class AuthBackdrop extends StatelessWidget {
  const AuthBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      painter: AuthBackdropPainter(),
      child: SizedBox.expand(),
    );
  }
}

class AuthBackdropPainter extends CustomPainter {
  const AuthBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.loginPage);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.92, size.height * 0.04),
        width: size.width * 0.62,
        height: size.height * 0.22,
      ),
      Paint()..color = AppColors.blush.withValues(alpha: 0.9),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.02, size.height * 0.96),
        width: size.width * 0.55,
        height: size.height * 0.18,
      ),
      Paint()..color = AppColors.blushDeep.withValues(alpha: 0.85),
    );

    final gold = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(
      Path()
        ..moveTo(0, size.height * 0.09)
        ..quadraticBezierTo(
          size.width * 0.32,
          size.height * 0.17,
          size.width * 0.68,
          size.height * 0.05,
        ),
      gold,
    );
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.62, size.height * 0.97)
        ..quadraticBezierTo(
          size.width * 0.82,
          size.height * 0.90,
          size.width,
          size.height * 0.84,
        ),
      gold,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
