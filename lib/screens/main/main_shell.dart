import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/components/app_logo_row.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/screens/main/financing_screen.dart';
import 'package:loanofficer/screens/main/home_screen.dart';
import 'package:loanofficer/screens/main/more_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _pages = [HomeScreen(), FinancingScreen(), MoreScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _MainHeader(title: _index == 1 ? 'طلبات التمويلية' : null),
            Expanded(child: _pages[_index]),
            _MainBottomBar(
              index: _index,
              onChanged: (value) => setState(() => _index = value),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainHeader extends StatelessWidget {
  const _MainHeader({this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 8.h),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          IconButton(
            onPressed: _noop,
            icon: Icon(Icons.notifications, color: AppColors.bell, size: 26.r),
          ),
          const Spacer(),
          if (title == null)
            const AppLogoRow(
              fmcHeight: 36,
              tanmeyahHeight: 32,
              gap: 10,
              dividerHeight: 28,
            )
          else
            Text(
              title!,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: AppTypography.appBar(color: AppColors.primary),
            ),
        ],
      ),
    );
  }
}

void _noop() {}

class _MainBottomBar extends StatelessWidget {
  const _MainBottomBar({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              _NavItem(
                selected: index == 0,
                label: 'الرئيسية',
                icon: const _HomeIcon(),
                onTap: () => onChanged(0),
              ),
              _NavItem(
                selected: index == 1,
                label: 'ط.تمويلية',
                icon: const _FinancingIcon(),
                onTap: () => onChanged(1),
              ),
              _NavItem(
                selected: index == 2,
                label: 'المزيد',
                icon: const _MoreIcon(),
                onTap: () => onChanged(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.selected,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final bool selected;
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.idle;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconTheme(
              data: IconThemeData(color: color, size: 26.r),
              child: icon,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeIcon extends StatelessWidget {
  const _HomeIcon();

  @override
  Widget build(BuildContext context) {
    final selected = IconTheme.of(context).color == AppColors.primary;
    return Icon(selected ? Icons.home_rounded : Icons.home_outlined);
  }
}

class _FinancingIcon extends StatelessWidget {
  const _FinancingIcon();

  @override
  Widget build(BuildContext context) {
    final color = IconTheme.of(context).color ?? AppColors.idle;
    return SizedBox(
      width: 26.w,
      height: 26.h,
      child: CustomPaint(
        painter: _GridPlusPainter(color, filled: color == AppColors.primary),
      ),
    );
  }
}

class _GridPlusPainter extends CustomPainter {
  const _GridPlusPainter(this.color, {required this.filled});

  final Color color;
  final bool filled;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final gap = size.width * 0.14;
    final cell = (size.width - gap) / 2;
    final radius = Radius.circular(cell * 0.28);
    for (var row = 0; row < 2; row++) {
      for (var col = 0; col < 2; col++) {
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(col * (cell + gap), row * (cell + gap), cell, cell),
          radius,
        );
        canvas.drawRRect(rect, paint);
      }
    }
    final plus = Paint()
      ..color = filled ? Colors.white : color
      ..strokeWidth = size.width * 0.09
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final center = Offset(cell + gap + cell / 2, cell / 2);
    final arm = cell * 0.26;
    canvas.drawLine(center.translate(-arm, 0), center.translate(arm, 0), plus);
    canvas.drawLine(center.translate(0, -arm), center.translate(0, arm), plus);
  }

  @override
  bool shouldRepaint(covariant _GridPlusPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.filled != filled;
  }
}

class _MoreIcon extends StatelessWidget {
  const _MoreIcon();

  @override
  Widget build(BuildContext context) {
    final color = IconTheme.of(context).color ?? AppColors.idle;
    return Container(
      width: 26.w,
      height: 26.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color, width: 1.6),
      ),
      child: Icon(Icons.more_horiz, color: color, size: 16.r),
    );
  }
}
