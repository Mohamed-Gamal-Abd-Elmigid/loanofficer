import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter/services.dart';
import 'package:loanofficer/core/api/auth_api.dart';
import 'package:loanofficer/core/api/admin_api.dart';
import 'package:loanofficer/core/components/app_button.dart';
import 'package:loanofficer/core/components/app_field_label.dart';
import 'package:loanofficer/core/components/app_logo_row.dart';
import 'package:loanofficer/core/components/app_text_field.dart';
import 'package:loanofficer/core/theme/app_colors.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key, required this.onSignedIn});

  final VoidCallback onSignedIn;

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscure = true;
  bool _busy = false;

  bool get _canSubmit =>
      _phone.text.trim().isNotEmpty && _password.text.isNotEmpty;

  @override
  void dispose() {
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _busy = true);
    try {
      await AdminApi().login(userId: _phone.text, password: _password.text);
      widget.onSignedIn();
    } on AuthApiException catch (error) {
      if (!mounted) return;
      showAuthError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.page,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 28),
            const Center(
              child: AppLogoRow(
                fmcHeight: 48,
                tanmeyahHeight: 42,
                gap: 18,
                dividerHeight: 40,
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(28.r),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 28,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'لوحة الإدارة',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.navy,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'تسجيل دخول المسؤول لإنشاء مستخدمي التطبيق',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 14.sp,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 28.h),
                            const AppFieldLabel.muted('رقم المسؤول'),
                            SizedBox(height: 8.h),
                            AppTextField(
                              controller: _phone,
                              hint: 'رقم المستخدم',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (_) => setState(() {}),
                            ),
                            SizedBox(height: 16.h),
                            const AppFieldLabel.muted('كلمة المرور'),
                            SizedBox(height: 8.h),
                            AppTextField(
                              controller: _password,
                              hint: 'كلمة المرور',
                              obscure: _obscure,
                              onChanged: (_) => setState(() {}),
                              suffix: AppPasswordToggle(
                                obscure: _obscure,
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                            ),
                            SizedBox(height: 24.h),
                            AppButton(
                              label: 'تسجيل الدخول',
                              backgroundColor: AppColors.navy,
                              onPressed: _canSubmit && !_busy ? _login : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
