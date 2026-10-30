import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/components/app_button.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/screens/login_screen.dart';

Future<void> showResetSuccessDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.barrier,
    builder: (dialogContext) {
      return const Directionality(
        textDirection: TextDirection.rtl,
        child: _ResetSuccessAlert(),
      );
    },
  );
}

class _ResetSuccessAlert extends StatelessWidget {
  const _ResetSuccessAlert();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 32.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(22.w, 32.h, 22.w, 22.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92.w,
              height: 92.h,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.successBackground,
                shape: BoxShape.circle,
              ),
              child: Container(
                width: 58.w,
                height: 58.h,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 36.r,
                ),
              ),
            ),
            SizedBox(height: 22.h),
            Text(
              'حسنا..!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.success,
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'لقد تم اعادة تعين كلمة\nالمرور بنجاح',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 16.sp,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              'برجاء اعادة تسجيل الدخول\nباستخدام كلمة المرور الجديدة',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 14.sp,
                height: 1.5,
              ),
            ),
            SizedBox(height: 26.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: AppButton(
                label: 'تسجيل الدخول',
                backgroundColor: AppColors.action,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
