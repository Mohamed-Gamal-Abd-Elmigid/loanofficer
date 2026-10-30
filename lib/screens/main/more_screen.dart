import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/auth_api.dart';
import 'package:loanofficer/core/components/app_button.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/screens/login_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  SignedInOfficer? _officer;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _load();
    });
  }

  Future<void> _load() async {
    try {
      final officer = await AuthApi().cachedOfficer();
      if (!mounted) return;
      setState(() {
        _officer = officer;
        _ready = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _ready = true);
    }
  }

  Future<void> _logout(BuildContext context) async {
    await AuthApi().signOut();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
        child: Column(
          children: [
            _OfficerCard(officer: _officer, ready: _ready),
            const Spacer(),
            AppButton(label: 'تسجيل الخروج', onPressed: () => _logout(context)),
          ],
        ),
      ),
    );
  }
}

class _OfficerCard extends StatelessWidget {
  const _OfficerCard({required this.officer, required this.ready});

  final SignedInOfficer? officer;
  final bool ready;

  @override
  Widget build(BuildContext context) {
    final name = officer?.fullName.trim() ?? '';
    final initial = name.isEmpty ? '?' : name.characters.first.toUpperCase();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ColoredBox(
              color: AppColors.card,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 18.h),
                child: ready
                    ? Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          CircleAvatar(
                            radius: 28.r,
                            backgroundColor: AppColors.iconBubble,
                            child: Text(
                              initial,
                              style: TextStyle(
                                color: AppColors.navy,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الاسم',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: AppColors.fieldLabel,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  name.isEmpty ? '—' : name,
                                  textAlign: TextAlign.right,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.navy,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 72.h,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
              ),
            ),
            if (ready) ...[
              _ProfileLine(
                icon: Icons.badge_outlined,
                label: 'رقم الموظف',
                value: officer?.employeeId ?? '',
              ),
              const Divider(height: 1, color: AppColors.cardBorder),
              _ProfileLine(
                icon: Icons.mail_outline,
                label: 'الايميل',
                value: officer?.email ?? '',
                ltr: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProfileLine extends StatelessWidget {
  const _ProfileLine({
    required this.icon,
    required this.label,
    required this.value,
    this.ltr = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool ltr;

  @override
  Widget build(BuildContext context) {
    final shown = value.trim().isEmpty ? '—' : value.trim();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.iconBubble,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.accent, size: 18.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.fieldLabel,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  shown,
                  textAlign: ltr ? TextAlign.left : TextAlign.right,
                  textDirection: ltr ? TextDirection.ltr : TextDirection.rtl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
