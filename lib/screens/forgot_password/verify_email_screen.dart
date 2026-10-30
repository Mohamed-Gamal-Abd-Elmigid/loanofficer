import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter/services.dart';
import 'package:loanofficer/core/api/auth_api.dart';
import 'package:loanofficer/core/components/app_button.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/screens/forgot_password/auth_flow_page.dart';
import 'package:loanofficer/screens/forgot_password/create_password_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({
    super.key,
    required this.email,
    required this.employeeId,
    required this.otp,
    this.recoveryToken,
  });

  final String email;
  final String employeeId;
  final String otp;
  final String? recoveryToken;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  static const int _codeLength = 5;

  final TextEditingController _code = TextEditingController();
  final FocusNode _focus = FocusNode();
  Timer? _timer;
  int _seconds = 10;
  bool _busy = false;
  bool _resending = false;
  late String _otp = widget.otp;
  late String? _recoveryToken = widget.recoveryToken;
  ScaffoldMessengerState? _messenger;

  bool get _canConfirm => _code.text.length == _codeLength;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _messenger = ScaffoldMessenger.of(context);
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _showOtp(_otp);
    });
  }

  void _showOtp(String otp) {
    if (!RegExp(r'^\d{5}$').hasMatch(otp)) return;
    final messenger = _messenger;
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 30),
          backgroundColor: AppColors.navy,
          content: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _fillPin,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: TextDirection.rtl,
              children: [
                const Text(
                  'اضغط لإدخال الكود: ',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  otp,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  void _fillPin() {
    if (!RegExp(r'^\d{5}$').hasMatch(_otp)) return;
    _code.value = TextEditingValue(
      text: _otp,
      selection: const TextSelection.collapsed(offset: _codeLength),
    );
    setState(() {});
  }

  void _hideOtp() {
    _messenger?.hideCurrentSnackBar();
  }

  @override
  void dispose() {
    _hideOtp();
    _timer?.cancel();
    _code.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 10);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_seconds <= 1) {
        timer.cancel();
        setState(() => _seconds = 0);
      } else {
        setState(() => _seconds -= 1);
      }
    });
  }

  Future<void> _resend() async {
    if (_resending) return;
    setState(() => _resending = true);
    try {
      final code = await AuthApi().requestPasswordReset(
        email: widget.email,
        employeeId: widget.employeeId,
      );
      if (!mounted) return;
      setState(() {
        _otp = code.pin;
        _recoveryToken = code.recoveryToken;
      });
      _showOtp(code.pin);
      _startTimer();
    } on AuthApiException catch (error) {
      if (!mounted) return;
      showAuthError(context, error);
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  Future<void> _confirm() async {
    setState(() => _busy = true);
    try {
      await AuthApi().verifyEmailCode(
        email: widget.email,
        employeeId: widget.employeeId,
        code: _code.text,
        recoveryToken: _recoveryToken,
      );
      if (!mounted) return;
      _hideOtp();
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const CreatePasswordScreen()),
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
    return AuthFlowPage(
      title: 'تأكيد الايميل',
      illustration: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Image(
          image: const AssetImage('assets/images/forgot_otp.png'),
          width: double.infinity,
          height: 320.h,
          fit: BoxFit.contain,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'برجاء إدخال الكود المكون من 5 ارقام الذي تم\nارساله إلي ايميل تنميه الخاص بك\nex..',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
          SizedBox(height: 22.h),
          GestureDetector(
            onTap: () => _focus.requestFocus(),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  textDirection: TextDirection.ltr,
                  children: List.generate(_codeLength, (index) {
                    final filled = index < _code.text.length;
                    return Expanded(
                      child: Container(
                        height: 52.h,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: AppColors.borderSoft),
                        ),
                        child: Text(
                          filled ? _code.text[index] : '0',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: filled
                                ? AppColors.navyLabel
                                : AppColors.hint,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(
                  height: 52.h,
                  child: TextField(
                    controller: _code,
                    focusNode: _focus,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(_codeLength),
                    ],
                    style: const TextStyle(color: Colors.transparent),
                    cursorColor: Colors.transparent,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Center(
            child: _seconds > 0
                ? Text.rich(
                    TextSpan(
                      style: TextStyle(color: AppColors.muted, fontSize: 13.sp),
                      children: [
                        const TextSpan(text: 'إرسال مرة أخرى بعد '),
                        TextSpan(
                          text: '$_seconds',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const TextSpan(text: ' ثواني'),
                      ],
                    ),
                  )
                : GestureDetector(
                    onTap: _resending ? null : _resend,
                    child: Text(
                      'إرسال مرة أخرى',
                      style: TextStyle(
                        color: AppColors.navyLabel,
                        fontSize: 13.sp,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
          ),
          SizedBox(height: 22.h),
          AppButton(
            label: 'تأكيد',
            onPressed: _canConfirm && !_busy ? _confirm : null,
          ),
        ],
      ),
    );
  }
}
