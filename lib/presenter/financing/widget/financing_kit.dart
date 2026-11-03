import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/components/app_button.dart';
import 'package:loanofficer/core/components/field_error_slot.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';

export 'package:loanofficer/core/components/field_error_slot.dart';
export 'package:loanofficer/core/components/flow_date_picker.dart';

const financingProducts = ['فابريكا', 'الكسيب', 'الكبير', 'الطيار'];

class FormStore {
  final Map<String, TextEditingController> _fields = {};

  TextEditingController field(String key, [String initial = '']) {
    return _fields.putIfAbsent(key, () => TextEditingController(text: initial));
  }

  String text(String key) => _fields[key]?.text.trim() ?? '';

  void clear() {
    for (final controller in _fields.values) {
      controller.clear();
    }
  }

  void clearKeys(Iterable<String> keys) {
    for (final key in keys) {
      _fields[key]?.clear();
    }
  }

  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
  }

  Listenable listenable([Iterable<String>? keys]) {
    final controllers = keys == null ? _fields.values : keys.map(field);
    return Listenable.merge(controllers);
  }
}

class FlowScaffold extends StatelessWidget {
  const FlowScaffold({
    super.key,
    required this.body,
    this.pageTitle,
    this.pageIcon,
    this.iconColor = AppColors.accent,
    this.iconBackground = AppColors.iconBubble,
    this.onBack,
    this.embedInShell = false,
    this.hideBrandHeader = false,
  });

  final Widget body;
  final String? pageTitle;
  final IconData? pageIcon;
  final Color iconColor;
  final Color iconBackground;
  final VoidCallback? onBack;
  /// When true, only [body] is shown (main shell provides the app bar).
  final bool embedInShell;
  /// Single detail bar (no «طلبات التمويلية» row) — order / client flows.
  final bool hideBrandHeader;

  @override
  Widget build(BuildContext context) {
    if (embedInShell) {
      return ColoredBox(
        color: AppColors.white,
        child: SizedBox.expand(child: body),
      );
    }
    return Scaffold(
      backgroundColor: hideBrandHeader ? AppColors.page : AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            if (!hideBrandHeader)
              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 8.h),
                child: Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    Icon(Icons.notifications, color: AppColors.bell, size: 26.r),
                    const Spacer(),
                    Text(
                      'طلبات التمويلية',
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: AppTypography.appBar(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            if (pageTitle != null)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  8.w,
                  hideBrandHeader ? 6.h : 4.h,
                  8.w,
                  hideBrandHeader ? 6.h : 10.h,
                ),
                child: Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    SizedBox(
                      width: 40.w,
                      height: 40.h,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: onBack ?? () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.chevron_right,
                          color: AppColors.fieldLabel,
                          size: 26.r,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        pageTitle!,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.appBar(color: AppColors.primary),
                      ),
                    ),
                    if (pageIcon != null)
                      Container(
                        width: 36.w,
                        height: 36.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: iconBackground,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(pageIcon, color: iconColor, size: 18.r),
                      )
                    else
                      SizedBox(width: 40.w),
                  ],
                ),
              ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

class FlowActionButton extends StatelessWidget {
  const FlowActionButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.buttonNeutral,
          foregroundColor: AppColors.white,
          disabledForegroundColor: AppColors.buttonDisabledText,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle: TextStyle(
            fontFamily: AppFonts.dinNextArabic,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class FlowSaveButton extends StatelessWidget {
  const FlowSaveButton({
    super.key,
    required this.onPressed,
    this.enabled = true,
  });

  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF3C92D6),
          disabledBackgroundColor: const Color(0xFFD6E6F5),
          foregroundColor: AppColors.white,
          disabledForegroundColor: const Color(0xFF9BB8D4),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle: TextStyle(
            fontFamily: AppFonts.dinNextArabic,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: const Text('حفظ'),
      ),
    );
  }
}

class FlowBody extends StatelessWidget {
  const FlowBody({super.key, required this.children, this.footer});

  final List<Widget> children;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            children: children,
          ),
        ),
        if (footer != null)
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
            child: footer,
          ),
      ],
    );
  }
}

class FlowAccordionRow extends StatelessWidget {
  const FlowAccordionRow({
    super.key,
    required this.title,
    required this.step,
    required this.onTap,
    this.done = false,
    this.leading,
    this.headerTrailing,
    this.details = const [],
  });

  final String title;
  final String step;
  final VoidCallback? onTap;
  final bool done;
  final Widget? leading;
  final Widget? headerTrailing;
  final List<String> details;

  static const tileColor = Color(0xFFF6F7F9);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: tileColor,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Padding(
          padding: EdgeInsets.fromLTRB(12.w, 16.h, 16.w, 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    textDirection: TextDirection.ltr,
                    children: [
                      leading ??
                          Icon(
                            Icons.chevron_left,
                            textDirection: TextDirection.ltr,
                            color: AppColors.action,
                            size: 22.r,
                          ),
                      ?headerTrailing,
                    ],
                  ),
                  SizedBox(width: 12.w),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      textDirection: TextDirection.ltr,
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppFonts.dinNextArabic,
                              color: AppColors.action,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              height: 1,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        _StepBadge(step, done: done),
                      ],
                    ),
                  ),
                ],
              ),
              if (details.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Text(
                  details.join('، '),
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    color: const Color(0xFFE14B4B),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class FlowMenuTile extends StatelessWidget {
  const FlowMenuTile({
    super.key,
    required this.title,
    required this.onTap,
    required this.step,
    this.done = false,
    this.details = const [],
  });

  final String title;
  final VoidCallback onTap;
  final String step;
  final bool done;
  final List<String> details;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: FlowAccordionRow(
        title: title,
        step: step,
        done: done,
        details: details,
        onTap: onTap,
      ),
    );
  }
}

class FlowSection extends StatelessWidget {
  const FlowSection({
    super.key,
    required this.title,
    required this.step,
    required this.expanded,
    required this.onToggle,
    this.onClear,
    this.child,
    this.done = false,
  });

  final String title;
  final String step;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback? onClear;
  final Widget? child;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        children: [
          FlowAccordionRow(
            title: title,
            step: step,
            done: done,
            onTap: onToggle,
            leading: AnimatedRotation(
              turns: expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              child: Icon(
                Icons.expand_more,
                color: AppColors.action,
                size: 22.r,
              ),
            ),
            headerTrailing: onClear != null && expanded
                ? GestureDetector(
                    onTap: onClear,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Text(
                        'مسح الحقول',
                        style: TextStyle(
                          color: const Color(0xFFE7A0A4),
                          fontSize: 12.sp,
                          fontFamily: AppFonts.dinNextArabic,
                        ),
                      ),
                    ),
                  )
                : null,
          ),
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: expanded && child != null
                  ? Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 14.h),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: const Color(0xFFE4EAF0)),
                        ),
                        child: child,
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepBadge extends StatelessWidget {
  const _StepBadge(this.step, {this.done = false});

  final String step;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.r,
      height: 24.r,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.action,
        shape: BoxShape.circle,
      ),
      child: done
          ? Icon(Icons.check_rounded, color: AppColors.white, size: 15.r)
          : Text(
              step,
              style: TextStyle(
                fontFamily: AppFonts.dinNextArabic,
                color: AppColors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
    );
  }
}

class FlowLabel extends StatelessWidget {
  const FlowLabel(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          color: color ?? const Color(0xFF5C6F8A),
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class FlowTextField extends StatelessWidget {
  const FlowTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.maxLength,
    this.digitsOnly = false,
    this.arabicOnly = false,
    this.emailOnly = false,
    this.egyptianMobile = false,
    this.readOnly = false,
    this.onTap,
    this.prefix,
    this.filledColor,
    this.textColor,
    this.error,
    this.reserveErrorSpace = false,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool digitsOnly;
  final bool arabicOnly;
  final bool emailOnly;

  /// Egyptian mobile: digits only, max 11, auto-prefix `0` for 10/11/12/15….
  final bool egyptianMobile;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? prefix;
  final Color? filledColor;
  final Color? textColor;
  final String? error;
  final bool reserveErrorSpace;

  @override
  Widget build(BuildContext context) {
    final invalid = error != null && error!.isNotEmpty;
    final borderColor = invalid
        ? const Color(0xFFE14B4B)
        : const Color(0xFFD5DDE6);
    final dimFill = filledColor ?? (readOnly ? const Color(0xFFE9EEF3) : null);
    final dimText =
        textColor ?? (readOnly ? const Color(0xFF8E98A4) : const Color(0xFF2C2C2C));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          readOnly: readOnly,
          enableInteractiveSelection: !readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          autocorrect: false,
          enableSuggestions: false,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          inputFormatters: [
            if (egyptianMobile) const EgyptianMobileLeadingZeroFormatter(),
            if (digitsOnly && !egyptianMobile)
              FilteringTextInputFormatter.digitsOnly,
            if (arabicOnly)
              FilteringTextInputFormatter.allow(RegExp(r'[\u0600-\u06FF]')),
            if (emailOnly)
              FilteringTextInputFormatter.allow(
                RegExp(r'[A-Za-z0-9@._%+\-]'),
              ),
            if (maxLength != null && !egyptianMobile)
              LengthLimitingTextInputFormatter(maxLength!),
          ],
          style: TextStyle(
            color: dimText,
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: const Color(0xFFC5CDD6),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
            filled: dimFill != null,
            fillColor: dimFill,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 14.h,
            ),
            suffixIcon: prefix == null
                ? null
                : Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: prefix,
                  ),
            suffixIconConstraints: BoxConstraints(
              minWidth: 28.w,
              minHeight: 24.h,
            ),
            enabledBorder: _border(borderColor),
            focusedBorder: _border(
              invalid ? const Color(0xFFE14B4B) : const Color(0xFF3C92D6),
            ),
            border: _border(borderColor),
            errorStyle: const TextStyle(height: 0, fontSize: 0),
            errorText: null,
          ),
        ),
        if (invalid || reserveErrorSpace)
          FieldErrorSlot(
            message: invalid ? error : null,
            reserveWhenEmpty: reserveErrorSpace,
          ),
      ],
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: color),
    );
  }
}

/// Digits-only Egyptian mobile; auto-prefixes `0` when user enters
/// `10|11|12|15` + 8 digits (10 chars) without the leading zero.
class EgyptianMobileLeadingZeroFormatter extends TextInputFormatter {
  const EgyptianMobileLeadingZeroFormatter();

  static final _withoutZero = RegExp(r'^(10|11|12|15)\d{8}$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (_withoutZero.hasMatch(digits)) {
      digits = '0$digits';
    }
    if (digits.length > 11) {
      digits = digits.substring(0, 11);
    }
    return TextEditingValue(
      text: digits,
      selection: TextSelection.collapsed(offset: digits.length),
    );
  }
}

class FlowChoiceField extends StatelessWidget {
  const FlowChoiceField({
    super.key,
    required this.label,
    required this.value,
    required this.hint,
    required this.onTap,
    this.error,
    this.borderColor,
    this.labelColor,
    this.locked = false,
    this.reserveErrorSpace = false,
  });

  final String label;
  final String value;
  final String hint;
  final VoidCallback onTap;
  final String? error;
  final Color? borderColor;
  final Color? labelColor;
  final bool locked;
  final bool reserveErrorSpace;

  @override
  Widget build(BuildContext context) {
    final invalid = error != null && error!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FlowLabel(label, color: labelColor),
        SizedBox(height: 6.h),
        InkWell(
          onTap: locked ? null : onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: locked ? const Color(0xFFE9EEF3) : null,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: invalid
                    ? const Color(0xFFE24C4C)
                    : (borderColor ?? const Color(0xFFD5DDE6)),
              ),
            ),
            child: Row(
              textDirection: TextDirection.ltr,
              children: [
                Icon(
                  Icons.keyboard_arrow_down,
                  color: locked
                      ? const Color(0xFF8E98A4)
                      : const Color(0xFF3C4F73),
                ),
                Expanded(
                  child: Text(
                    value.isEmpty ? hint : value,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: locked
                          ? const Color(0xFF8E98A4)
                          : value.isEmpty
                          ? const Color(0xFFC5CDD6)
                          : const Color(0xFF2C2C2C),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (invalid || reserveErrorSpace)
          FieldErrorSlot(
            message: invalid ? error : null,
            reserveWhenEmpty: reserveErrorSpace,
          ),
      ],
    );
  }
}

class EgyptFlag extends StatelessWidget {
  const EgyptFlag({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2.r),
      child: SizedBox(
        width: 22.w,
        height: 14.h,
        child: const Column(
          children: [
            Expanded(child: ColoredBox(color: Color(0xFFCE1126))),
            Expanded(child: ColoredBox(color: Color(0xFFFFFFFF))),
            Expanded(child: ColoredBox(color: Color(0xFF000000))),
          ],
        ),
      ),
    );
  }
}

/// Label + value for generic option sheets (inquiry filters, etc.).
class FlowPickerOption<T> {
  const FlowPickerOption({required this.value, required this.label});

  final T value;
  final String label;
}

/// RTL option row: label at the **start** (right), radio at the end (left).
class FlowChoiceOptionTile extends StatelessWidget {
  const FlowChoiceOptionTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFE7F3FC) : const Color(0xFFF6F7F9),
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          child: Row(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.start,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    color: selected ? AppColors.accent : AppColors.text,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: selected ? AppColors.accent : const Color(0xFFD0D5DC),
                size: 22.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet picker — same option layout as [showChoiceDialog]; tap to select.
Future<T?> showFlowOptionSheet<T>({
  required BuildContext context,
  required String title,
  required List<FlowPickerOption<T>> options,
  T? current,
  bool clearable = false,
  String clearLabel = '— الكل —',
}) {
  return showModalBottomSheet<T?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final maxListHeight = MediaQuery.sizeOf(ctx).height * 0.52;
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.75),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10.h),
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.borderSoft,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.w, 8.h, 16.w, 0),
                  child: Row(
                    textDirection: TextDirection.ltr,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: AppColors.fieldLabel,
                          size: 22.r,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          title,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontFamily: AppFonts.dinNextArabic,
                            color: AppColors.navy,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 20.h, color: AppColors.line),
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxListHeight),
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                      shrinkWrap: true,
                      itemCount: options.length + (clearable ? 1 : 0),
                      separatorBuilder: (_, _) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        if (clearable && index == 0) {
                          return FlowChoiceOptionTile(
                            label: clearLabel,
                            selected: current == null,
                            onTap: () => Navigator.of(ctx).pop(null),
                          );
                        }
                        final opt = options[clearable ? index - 1 : index];
                        final selected = opt.value == current;
                        return FlowChoiceOptionTile(
                          label: opt.label,
                          selected: selected,
                          onTap: () => Navigator.of(ctx).pop(opt.value),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<String?> showChoiceDialog({
  required BuildContext context,
  required String title,
  String? subtitle,
  required List<String> options,
  String? selected,
  bool searchable = false,
  String searchHint = 'بحث…',
}) {
  return showDialog<String>(
    context: context,
    builder: (context) {
      return _ChoiceDialog(
        title: title,
        subtitle: subtitle,
        options: options,
        selected: selected,
        searchable: searchable,
        searchHint: searchHint,
      );
    },
  );
}

String _choiceSearchNormalize(String value) {
  return value.trim().toLowerCase();
}

class _ChoiceDialog extends StatefulWidget {
  const _ChoiceDialog({
    required this.title,
    required this.options,
    this.subtitle,
    this.selected,
    this.searchable = false,
    this.searchHint = 'بحث…',
  });

  final String title;
  final String? subtitle;
  final List<String> options;
  final String? selected;
  final bool searchable;
  final String searchHint;

  @override
  State<_ChoiceDialog> createState() => _ChoiceDialogState();
}

class _ChoiceDialogState extends State<_ChoiceDialog> {
  String? _selected;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _visibleOptions {
    if (!widget.searchable) return widget.options;
    final query = _choiceSearchNormalize(_searchController.text);
    if (query.isEmpty) return widget.options;
    return [
      for (final option in widget.options)
        if (_choiceSearchNormalize(option).contains(query)) option,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final chosen = _selected != null;
    final options = _visibleOptions;
    final maxListHeight = MediaQuery.sizeOf(context).height * 0.45;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 22.w),
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.78,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close_rounded,
                        color: AppColors.fieldLabel,
                        size: 22.r,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: AppFonts.dinNextArabic,
                          color: AppColors.navy,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
            if (widget.subtitle != null)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  widget.subtitle!,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: AppColors.muted, fontSize: 13.sp),
                ),
              ),
            Divider(height: 24.h, color: AppColors.line),
            if (widget.searchable) ...[
              TextField(
                controller: _searchController,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  hintTextDirection: TextDirection.rtl,
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.fieldLabel,
                    size: 22.r,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF6F7F9),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.cardBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
            ],
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxListHeight),
                child: options.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          child: Text(
                            'لا توجد نتائج',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: options.length,
                      separatorBuilder: (_, _) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        final option = options[index];
                        final active = option == _selected;
                        return FlowChoiceOptionTile(
                          label: option,
                          selected: active,
                          onTap: () => setState(() => _selected = option),
                        );
                      },
                    ),
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: FilledButton(
                onPressed: chosen
                    ? () => Navigator.of(context).pop(_selected)
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFD6EBFA),
                  disabledBackgroundColor: const Color(0xFFE6E6E8),
                  foregroundColor: AppColors.navy,
                  disabledForegroundColor: const Color(0xFFB7B7BC),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                child: Text(
                  'اختيار',
                  style: TextStyle(fontFamily: AppFonts.dinNextArabic),
                ),
              ),
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showFlowSuccess(
  BuildContext context, {
  required String message,
  String? note,
  String title = 'حسناً..!',
  String buttonLabel = 'حسناً',
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.barrier,
    builder: (dialogContext) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.86, end: 1),
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: ((scale - 0.86) / 0.14).clamp(0.0, 1.0),
                child: child,
              ),
            );
          },
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 32.w),
            backgroundColor: AppColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.r),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(28.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cardShadow,
                    blurRadius: 24.r,
                    offset: Offset(0, 10.h),
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(22.w, 32.h, 22.w, 22.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 92.w,
                    height: 92.h,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.iconBubble,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 58.w,
                      height: 58.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.35),
                            blurRadius: 16.r,
                            offset: Offset(0, 6.h),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: AppColors.white,
                        size: 36.r,
                      ),
                    ),
                  ),
                  SizedBox(height: 22.h),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.dinNextArabic,
                      color: AppColors.accent,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.dinNextArabic,
                      color: AppColors.text,
                      fontSize: 16.sp,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (note != null && note.trim().isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.page,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Text(
                        note,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFonts.dinNextArabic,
                          color: AppColors.navy,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 26.h),
                  AppButton(
                    label: buttonLabel,
                    backgroundColor: AppColors.accent,
                    onPressed: () => Navigator.of(dialogContext).pop(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

