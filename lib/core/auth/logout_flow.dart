import 'package:flutter/material.dart';
import 'package:loanofficer/core/api/auth_api.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/presenter/login/scene/login_scene.dart';

Future<void> confirmAndSignOut(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        'تسجيل الخروج',
        textAlign: TextAlign.right,
        style: TextStyle(
          fontFamily: AppFonts.dinNextArabic,
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Text(
        'هل أنت متأكد أنك تريد تسجيل الخروج؟',
        textAlign: TextAlign.right,
        style: TextStyle(
          fontFamily: AppFonts.dinNextArabic,
          color: AppColors.text,
          fontSize: 15,
          height: 1.4,
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(
            'لا',
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              color: AppColors.fieldLabel,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(
            'نعم',
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;
  await AuthApi().signOut();
  if (!context.mounted) return;
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => const LoginScene()),
    (route) => false,
  );
}
