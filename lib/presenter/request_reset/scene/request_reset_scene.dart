import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/auth_api.dart';
import 'package:loanofficer/core/components/app_button.dart';
import 'package:loanofficer/core/components/app_field_label.dart';
import 'package:loanofficer/core/components/app_text_field.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/validation/app_validators.dart';
import 'package:loanofficer/presenter/forgot_password/widget/auth_flow_page.dart';
import 'package:loanofficer/presenter/verify_email/scene/verify_email_scene.dart';

import 'package:loanofficer/core/bases/base_state.dart';
import 'package:loanofficer/core/bases/states/base/base_state.dart';
import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/request_reset/bloc/request_reset_bloc.dart';
import 'package:loanofficer/presenter/request_reset/model/request_reset_model.dart';

class RequestResetScene extends StatefulWidget {
  const RequestResetScene({super.key});

  @override
  State<RequestResetScene> createState() => _RequestResetSceneState();
}

class _RequestResetSceneState
    extends BaseState<RequestResetScene, RequestResetBloc, RequestResetModel> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _employeeId = TextEditingController();
  bool _busy = false;

  bool get _canContinue {
    return AppValidators.isTanmeyahEmail(_email.text) &&
        _employeeId.text.trim().isNotEmpty;
  }

  Future<void> _continue() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final code = await AuthApi().requestPasswordReset(
        email: _email.text,
        employeeId: _employeeId.text,
      );
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => VerifyEmailScene(
            email: _email.text.trim(),
            employeeId: _employeeId.text.trim(),
            otp: code.pin,
            recoveryToken: code.recoveryToken,
          ),
        ),
      );
    } on AuthApiException catch (error) {
      if (!mounted) return;
      showAuthError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _employeeId.dispose();
    super.dispose();
  }

  @override
  Widget buildWidget(
    BuildContext context,
    RenderDataState<RequestResetModel> state,
  ) {
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'أدخل ايميل تنميه الخاص بك ورقم الموظف\nالخاص بك لإعادة تعيين كلمة المرور.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
          SizedBox(height: 20.h),
          const AppFieldLabel('الايميل'),
          SizedBox(height: 8.h),
          AppTextField(
            controller: _email,
            hint: 'example@tanmeyah.com',
            keyboardType: TextInputType.emailAddress,
            reserveErrorSpace: true,
            errorText:
                _email.text.trim().isEmpty ||
                    AppValidators.isTanmeyahEmail(_email.text)
                ? null
                : AppValidators.emailMessage,
            onChanged: (value) {
              final completed = AppValidators.withTanmeyahDomain(value);
              if (completed != null) {
                _email.value = TextEditingValue(
                  text: completed,
                  selection: TextSelection.collapsed(offset: completed.length),
                );
              }
              setState(() {});
            },
          ),
          SizedBox(height: 16.h),
          const AppFieldLabel('رقم الموظف'),
          SizedBox(height: 8.h),
          AppTextField(
            controller: _employeeId,
            hint: 'رقم الموظف',
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: 20.h),
          AppButton(
            label: 'استمرار',
            onPressed: _canContinue && !_busy ? _continue : null,
          ),
        ],
      ),
    );
  }

  @override
  void listenToState(BuildContext context, BaseStates state) {}

  @override
  RequestResetBloc createBloc() => RequestResetBloc(RequestResetModel());
}
