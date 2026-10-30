import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/auth_api.dart';
import 'package:loanofficer/core/auth/officer_sign_in.dart';
import 'package:loanofficer/core/components/app_button.dart';
import 'package:loanofficer/core/components/app_field_label.dart';
import 'package:loanofficer/core/components/app_logo_row.dart';
import 'package:loanofficer/core/components/app_text_field.dart';
import 'package:loanofficer/core/components/auth_backdrop.dart';
import 'package:loanofficer/core/components/biometric_mark.dart';
import 'package:loanofficer/core/storage/biometric_credentials_store.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/screens/main/main_shell.dart';

class BiometricSetupScreen extends StatefulWidget {
  const BiometricSetupScreen({super.key});

  @override
  State<BiometricSetupScreen> createState() => _BiometricSetupScreenState();
}

class _BiometricSetupScreenState extends State<BiometricSetupScreen> {
  final TextEditingController _employeeId = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscure = true;
  bool _busy = false;

  bool get _canSave =>
      _employeeId.text.trim().isNotEmpty && _password.text.isNotEmpty && !_busy;

  @override
  void dispose() {
    _employeeId.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    try {
      final employeeId = _employeeId.text.trim();
      final password = _password.text;
      await signInOfficer(context, employeeId: employeeId, password: password);
      await BiometricCredentialsStore().save(
        employeeId: employeeId,
        password: password,
      );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const MainShell()),
        (route) => false,
      );
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
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackdrop()),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 4.h, 4.w, 0),
                  child: Row(
                    textDirection: TextDirection.ltr,
                    children: [
                      const Spacer(),
                      Text(
                        'تسجيل الدخول بالبصمة',
                        textAlign: TextAlign.right,
                        style: AppTypography.appBar(color: AppColors.primary),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: Icon(
                          Icons.chevron_right,
                          color: AppColors.primary,
                          size: 28.r,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 420),
                      padding: EdgeInsets.fromLTRB(22.w, 28.h, 22.w, 22.h),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Center(child: BiometricMark(size: 64)),
                          SizedBox(height: 16.h),
                          const Center(
                            child: AppLogoRow(
                              fmcHeight: 36,
                              tanmeyahHeight: 32,
                              dividerHeight: 28,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'أدخل رقم الموظف وكلمة المرور مرة واحدة. سيتم حفظهما لتسجيل الدخول بالبصمة لاحقاً.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 13.sp,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 22.h),
                          const AppFieldLabel.muted('رقم الموظف'),
                          SizedBox(height: 8.h),
                          AppTextField(
                            controller: _employeeId,
                            hint: 'رقم الموظف',
                            keyboardType: TextInputType.number,
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
                          SizedBox(height: 22.h),
                          AppButton(
                            label: 'حفظ ومتابعة',
                            onPressed: _canSave ? _save : null,
                          ),
                        ],
                      ),
                    ),
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
