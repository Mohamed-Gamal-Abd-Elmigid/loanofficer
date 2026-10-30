import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/screens/financing/new_individual_request_screen.dart';

class FinancingScreen extends StatelessWidget {
  const FinancingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      children: [
        _ActionCard(
          icon: Icons.add,
          title: 'إنشاء طلب تمويل فردي',
          subtitle: 'أنشئ طلب تمويل فردي جديد',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const NewIndividualRequestScreen(),
              ),
            );
          },
        ),
        SizedBox(height: 14.h),
        const _ActionCard(
          icon: Icons.drive_file_rename_outline,
          title: 'متابعة طلبات التمويل',
          subtitle:
              'استعرض طلبات العملاء وتابع حالتها\nوأجرِ التعديلات المطلوبة',
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF4F7FB),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.r)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22.r),
        child: Padding(
          padding: EdgeInsets.fromLTRB(6.w, 18.h, 14.w, 18.h),
          child: Row(
            textDirection: TextDirection.ltr,
            children: [
              Icon(
                Icons.chevron_left,
                color: const Color(0xFFC5CED6),
                size: 28.r,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF2C2C2C),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF9AA3AE),
                        fontSize: 12.sp,
                        height: 1.35,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 48.w,
                height: 48.h,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFD7EBFA),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF3C92D6), size: 26.r),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
