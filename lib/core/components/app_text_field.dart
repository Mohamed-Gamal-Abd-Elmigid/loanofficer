import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/validation/app_validators.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.obscure = false,
    this.keyboardType,
    this.suffix,
    this.errorText,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final eyeOnLeft = Directionality.of(context) == TextDirection.rtl;
    final hasError = errorText != null;
    final borderColor = hasError ? AppColors.red : AppColors.border;
    final isEmail = keyboardType == TextInputType.emailAddress;
    final isNumeric =
        keyboardType == TextInputType.number ||
        keyboardType == TextInputType.phone;
    final direction = isEmail ? TextDirection.ltr : TextDirection.rtl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          obscureText: obscure,
          onChanged: onChanged,
          keyboardType: keyboardType,
          inputFormatters: [
            if (isEmail) const TanmeyahDomainFormatter(),
            ...?inputFormatters,
          ],
          autocorrect: !isEmail && !isNumeric,
          enableSuggestions: !isEmail && !isNumeric,
          textDirection: direction,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: kIsWeb ? 15 : 15.sp,
            letterSpacing: obscure ? (kIsWeb ? 3 : 3.w) : 0,
            color: AppColors.text,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintTextDirection: direction,
            hintStyle: TextStyle(
              color: AppColors.hint,
              letterSpacing: 0,
              fontSize: kIsWeb ? 14 : 14.sp,
            ),
            prefixIcon: eyeOnLeft ? null : suffix,
            suffixIcon: eyeOnLeft ? suffix : null,
            prefixIconConstraints: BoxConstraints(
              minWidth: kIsWeb ? 40 : 40.w,
              minHeight: kIsWeb ? 40 : 40.h,
            ),
            suffixIconConstraints: BoxConstraints(
              minWidth: kIsWeb ? 40 : 40.w,
              minHeight: kIsWeb ? 40 : 40.h,
            ),
            filled: true,
            fillColor: AppColors.white,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: kIsWeb ? 14 : 14.w,
              vertical: kIsWeb ? 14 : 14.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kIsWeb ? 10 : 10.r),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kIsWeb ? 10 : 10.r),
              borderSide: BorderSide(
                color: hasError ? AppColors.red : AppColors.navy,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          SizedBox(height: kIsWeb ? 6 : 6.h),
          Text(
            errorText!,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: AppColors.red,
              fontSize: kIsWeb ? 12 : 12.sp,
            ),
          ),
        ],
      ],
    );
  }
}

class TanmeyahDomainFormatter extends TextInputFormatter {
  const TanmeyahDomainFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final completed = AppValidators.completeTanmeyahEmail(
      previous: oldValue.text,
      current: newValue.text,
    );
    if (completed == null) return newValue;
    return TextEditingValue(
      text: completed,
      selection: TextSelection.collapsed(
        offset: completed.startsWith('@') ? 0 : completed.length,
      ),
    );
  }
}

class AppPasswordToggle extends StatelessWidget {
  const AppPasswordToggle({
    super.key,
    required this.obscure,
    required this.onPressed,
  });

  final bool obscure;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: AppColors.red,
        size: kIsWeb ? 22 : 22.r,
      ),
    );
  }
}
