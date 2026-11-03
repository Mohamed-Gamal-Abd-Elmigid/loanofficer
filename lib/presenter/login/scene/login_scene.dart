import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/auth_api.dart';
import 'package:loanofficer/core/auth/officer_sign_in.dart';
import 'package:loanofficer/core/auth/biometric_gate.dart';
import 'package:loanofficer/core/components/app_button.dart';
import 'package:loanofficer/core/components/auth_backdrop.dart';
import 'package:loanofficer/core/components/app_field_label.dart';
import 'package:loanofficer/core/components/tanmeyah_brand_logo.dart';
import 'package:loanofficer/core/components/app_text_field.dart';
import 'package:loanofficer/core/components/biometric_mark.dart';
import 'package:loanofficer/core/storage/biometric_credentials_store.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/presenter/biometric_setup/scene/biometric_setup_scene.dart';
import 'package:loanofficer/presenter/roles/scene/roles_scene.dart';

import 'package:loanofficer/core/bases/base_state.dart';
import 'package:loanofficer/core/bases/states/base/base_state.dart';
import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/login/bloc/login_bloc.dart';
import 'package:loanofficer/presenter/login/model/login_model.dart';

class LoginScene extends StatefulWidget {
  const LoginScene({super.key});

  @override
  State<LoginScene> createState() => _LoginSceneState();
}

class _LoginSceneState extends BaseState<LoginScene, LoginBloc, LoginModel> {
  final TextEditingController _employeeId = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscurePassword = true;
  bool _busy = false;

  bool get _canSubmit =>
      _employeeId.text.trim().isNotEmpty && _password.text.isNotEmpty;

  Future<void> _login() async {
    setState(() => _busy = true);
    try {
      final roles = await signInOfficer(
        employeeId: _employeeId.text,
        password: _password.text,
      );
      if (!mounted) return;
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => RolesScene(roles: roles)));
    } on AuthApiException catch (error) {
      if (!mounted) return;
      showAuthError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _loginWithBiometrics() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final store = BiometricCredentialsStore();
      final saved = await store.read();
      if (!mounted) return;
      if (saved == null) {
        setState(() => _busy = false);
        await Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const BiometricSetupScene()),
        );
        return;
      }
      final unlocked = await BiometricGate().authenticate();
      if (!mounted || !unlocked) return;
      final roles = await signInOfficer(
        employeeId: saved.employeeId,
        password: saved.password,
      );
      if (!mounted) return;
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => RolesScene(roles: roles)));
    } on AuthApiException catch (error) {
      if (error.message.contains('غير صحيحة')) {
        await BiometricCredentialsStore().clear();
      }
      if (!mounted) return;
      showAuthError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _employeeId.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context, RenderDataState<LoginModel> state) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackdrop()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 32.h,
                    ),
                    child: Transform.translate(
                      offset: Offset(0, 50.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _LoginCard(
                            employeeId: _employeeId,
                            password: _password,
                            obscurePassword: _obscurePassword,
                            canSubmit: _canSubmit && !_busy,
                            onChanged: () => setState(() {}),
                            onSubmit: _login,
                            onBiometric: _busy ? null : _loginWithBiometrics,
                            onTogglePassword: () {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
                            },
                          ),
                          SizedBox(height: 28.h),
                          Text(
                            '© 2027 Tanmeyah Loan Officer App. All rights reserved.\n'
                            'Compliant with regulatory standards and data protection requirements.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.caption,
                              fontSize: 11.sp,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void listenToState(BuildContext context, BaseStates state) {}

  @override
  LoginBloc createBloc() => LoginBloc(LoginModel());
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.employeeId,
    required this.password,
    required this.obscurePassword,
    required this.canSubmit,
    required this.onChanged,
    required this.onTogglePassword,
    required this.onSubmit,
    required this.onBiometric,
  });

  final TextEditingController employeeId;
  final TextEditingController password;
  final bool obscurePassword;
  final bool canSubmit;
  final VoidCallback onChanged;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;
  final VoidCallback? onBiometric;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Center(child: TanmeyahBrandLogo(height: 44)),
          SizedBox(height: 18.h),
          Text(
            'تسجيل الدخول',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.navy,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 22.h),
          const AppFieldLabel.muted('رقم الموظف'),
          SizedBox(height: 8.h),
          AppTextField(
            controller: employeeId,
            hint: 'رقم الموظف',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) => onChanged(),
          ),
          SizedBox(height: 16.h),
          const AppFieldLabel.muted('كلمة المرور'),
          SizedBox(height: 8.h),
          AppTextField(
            controller: password,
            hint: 'كلمة المرور',
            obscure: obscurePassword,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) => onChanged(),
            suffix: AppPasswordToggle(
              obscure: obscurePassword,
              onPressed: onTogglePassword,
            ),
          ),
          SizedBox(height: 18.h),
          Row(
            textDirection: TextDirection.ltr,
            children: [
              BiometricMark(size: 50, onPressed: onBiometric),
              SizedBox(width: 10.w),
              Expanded(
                child: AppButton(
                  label: 'تسجيل الدخول',
                  height: 50,
                  radius: 12,
                  onPressed: canSubmit ? onSubmit : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
