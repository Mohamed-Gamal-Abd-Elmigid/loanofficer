import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/auth_api.dart';
import 'package:loanofficer/core/components/app_button.dart';
import 'package:loanofficer/core/components/app_field_label.dart';
import 'package:loanofficer/core/components/app_text_field.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/screens/forgot_password/auth_flow_page.dart';
import 'package:loanofficer/screens/forgot_password/password_rules.dart';
import 'package:loanofficer/screens/forgot_password/reset_success_dialog.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirm = true;
  bool _busy = false;

  Future<void> _submit() async {
    setState(() => _busy = true);
    try {
      await AuthApi().updatePassword(_password.text);
      if (!mounted) return;
      await showResetSuccessDialog(context);
    } on AuthApiException catch (error) {
      if (!mounted) return;
      showAuthError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = isStrongPassword(_password.text, _confirm.text);
    return AuthFlowPage(
      title: 'إعادة تعين كلمة المرور',
      illustration: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Image(
          image: const AssetImage('assets/images/forgot_reset.png'),
          width: double.infinity,
          height: 320.h,
          fit: BoxFit.contain,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'يرجى إنشاء كلمة مرور جديدة',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 14.sp),
          ),
          SizedBox(height: 18.h),
          const AppFieldLabel('كلمة المرور الجديدة'),
          SizedBox(height: 8.h),
          AppTextField(
            controller: _password,
            hint: '********',
            obscure: _hidePassword,
            errorText: passwordRuleMessage(_password.text),
            onChanged: (_) => setState(() {}),
            suffix: AppPasswordToggle(
              obscure: _hidePassword,
              onPressed: () => setState(() => _hidePassword = !_hidePassword),
            ),
          ),
          SizedBox(height: 16.h),
          const AppFieldLabel('تاكيد كلمة المرور'),
          SizedBox(height: 8.h),
          AppTextField(
            controller: _confirm,
            hint: '********',
            obscure: _hideConfirm,
            errorText: confirmPasswordMessage(_password.text, _confirm.text),
            onChanged: (_) => setState(() {}),
            suffix: AppPasswordToggle(
              obscure: _hideConfirm,
              onPressed: () => setState(() => _hideConfirm = !_hideConfirm),
            ),
          ),
          SizedBox(height: 16.h),
          const _PasswordRules(),
          SizedBox(height: 16.h),
          AppButton(
            label: 'إعادة تعين',
            onPressed: canSubmit && !_busy ? _submit : null,
          ),
        ],
      ),
    );
  }
}

class _PasswordRules extends StatelessWidget {
  const _PasswordRules();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.info, size: 18.r),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                'يجب مراعاة هذه الشروط لانشاء كلمة مرور قوية',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.info,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ..._ruleLines,
      ],
    );
  }
}

const List<Widget> _ruleLines = [
  _RuleLine('الطول: استخدم 8 أحرف على الأقل.'),
  _RuleLine('الحروف الكبيرة: أضف حرف إنجليزي كبير واحد على الأقل، مثل A–Z'),
  _RuleLine('الحروف الصغيرة: أضف حرف إنجليزي صغير واحد على الأقل، مثل a–z'),
  _RuleLine('الارقام: أضف رقم واحد على الأقل، مثل 0–9'),
  _RuleLine('الرموز: أضف رمز واحد على الأقل، مثل ! @ # \$ %'),
  _RuleLine(
    'عدم سهولة التخمين: تجنب اسمك، وتاريخ ميلادك، ورقم هاتفك، والكلمات الشائعة.',
  ),
  _RuleLine('التطابق: تأكد من تطابق كلمة السر المدخلة'),
];

class _RuleLine extends StatelessWidget {
  const _RuleLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Text(
        '• $text',
        textAlign: TextAlign.right,
        style: TextStyle(color: AppColors.info, fontSize: 12.sp, height: 1.45),
      ),
    );
  }
}
