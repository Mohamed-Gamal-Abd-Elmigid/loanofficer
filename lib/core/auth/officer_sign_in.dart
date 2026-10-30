import 'package:flutter/material.dart';
import 'package:loanofficer/core/api/auth_api.dart';
import 'package:loanofficer/core/theme/app_colors.dart';

Future<void> signInOfficer(
  BuildContext context, {
  required String employeeId,
  required String password,
}) async {
  final roles = await AuthApi().login(
    employeeId: employeeId,
    password: password,
  );
  if (!context.mounted || roles.isEmpty) return;
  final role = await showDialog<FmcRole>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.white,
        title: const Text('اختر الصلاحية'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final role in roles)
                ListTile(
                  title: Text(role.label),
                  onTap: () => Navigator.of(context).pop(role),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
        ],
      );
    },
  );
  if (!context.mounted) return;
  if (role == null) {
    await AuthApi().signOut();
    throw AuthApiException('اختر الصلاحية للمتابعة');
  }
  await AuthApi().selectRole(role);
}
