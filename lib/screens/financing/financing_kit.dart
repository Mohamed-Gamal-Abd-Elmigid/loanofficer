import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';

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
  });

  final Widget body;
  final String? pageTitle;
  final IconData? pageIcon;
  final Color iconColor;
  final Color iconBackground;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
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
                padding: EdgeInsets.fromLTRB(16.w, 4.h, 8.w, 10.h),
                child: Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    const Spacer(),
                    Text(
                      pageTitle!,
                      style: TextStyle(
                        fontFamily: AppFonts.dinNextArabic,
                        color: const Color(0xFF2C2C2C),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        height: 1,
                      ),
                    ),
                    if (pageIcon != null) ...[
                      SizedBox(width: 8.w),
                      Container(
                        width: 30.w,
                        height: 30.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: iconBackground,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(pageIcon, color: iconColor, size: 16.r),
                      ),
                    ],
                    SizedBox(
                      width: 36.w,
                      height: 36.h,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: onBack ?? () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.chevron_right,
                          color: const Color(0xFF8E98A4),
                          size: 26.r,
                        ),
                      ),
                    ),
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
  });

  final String title;
  final String step;
  final VoidCallback? onTap;
  final bool done;
  final Widget? leading;
  final Widget? headerTrailing;

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
          child: Row(
            textDirection: TextDirection.ltr,
            children: [
              leading ??
                  Icon(Icons.expand_more, color: AppColors.action, size: 22.r),
              if (headerTrailing != null) headerTrailing!,
              const Spacer(),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  maxLines: 2,
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
  });

  final String title;
  final VoidCallback onTap;
  final String step;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: FlowAccordionRow(
        title: title,
        step: step,
        done: done,
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
            leading: Icon(
              expanded ? Icons.expand_less : Icons.expand_more,
              color: AppColors.action,
              size: 22.r,
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
          if (expanded && child != null) ...[SizedBox(height: 10.h), child!],
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
  const FlowLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          color: const Color(0xFF5C6F8A),
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
    this.keyboardType,
    this.maxLength,
    this.digitsOnly = false,
    this.readOnly = false,
    this.onTap,
    this.prefix,
    this.filledColor,
    this.textColor,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool digitsOnly;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? prefix;
  final Color? filledColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final numeric =
        digitsOnly ||
        keyboardType == TextInputType.number ||
        keyboardType == TextInputType.phone;
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      onChanged: onChanged,
      autocorrect: !numeric,
      enableSuggestions: !numeric,
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      inputFormatters: [
        if (digitsOnly) FilteringTextInputFormatter.digitsOnly,
        if (maxLength != null) LengthLimitingTextInputFormatter(maxLength!),
      ],
      style: TextStyle(
        color: textColor ?? const Color(0xFF2C2C2C),
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
        filled: filledColor != null,
        fillColor: filledColor,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        suffixIcon: prefix == null
            ? null
            : Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: prefix,
              ),
        suffixIconConstraints: BoxConstraints(minWidth: 28.w, minHeight: 24.h),
        enabledBorder: _border(const Color(0xFFD5DDE6)),
        focusedBorder: _border(const Color(0xFF3C92D6)),
        border: _border(const Color(0xFFD5DDE6)),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: color),
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
  });

  final String label;
  final String value;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FlowLabel(label),
        SizedBox(height: 6.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFD5DDE6)),
            ),
            child: Row(
              textDirection: TextDirection.ltr,
              children: [
                const Icon(Icons.keyboard_arrow_down, color: Color(0xFF3C4F73)),
                Expanded(
                  child: Text(
                    value.isEmpty ? hint : value,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: value.isEmpty
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

Future<String?> showChoiceDialog({
  required BuildContext context,
  required String title,
  String? subtitle,
  required List<String> options,
  String? selected,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) {
      return _ChoiceDialog(
        title: title,
        subtitle: subtitle,
        options: options,
        selected: selected,
      );
    },
  );
}

class _ChoiceDialog extends StatefulWidget {
  const _ChoiceDialog({
    required this.title,
    required this.options,
    this.subtitle,
    this.selected,
  });

  final String title;
  final String? subtitle;
  final List<String> options;
  final String? selected;

  @override
  State<_ChoiceDialog> createState() => _ChoiceDialogState();
}

class _ChoiceDialogState extends State<_ChoiceDialog> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    final chosen = _selected != null;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 22.w),
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
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
                  icon: const Icon(Icons.close, color: Color(0xFF8E98A4)),
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.right,
                    style: TextStyle(
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
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.options.length,
                separatorBuilder: (_, _) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  final active = option == _selected;
                  return Material(
                    color: active
                        ? const Color(0xFFE7F3FC)
                        : const Color(0xFFF6F7F9),
                    borderRadius: BorderRadius.circular(12.r),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () => setState(() => _selected = option),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 16.h,
                        ),
                        child: Row(
                          textDirection: TextDirection.ltr,
                          children: [
                            Icon(
                              active
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: active
                                  ? const Color(0xFF3C92D6)
                                  : const Color(0xFFD0D5DC),
                            ),
                            const Spacer(),
                            Text(
                              option,
                              style: TextStyle(
                                color: active
                                    ? const Color(0xFF3C92D6)
                                    : const Color(0xFF2C2C2C),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
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
                child: const Text('اختيار'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showFlowSuccess(
  BuildContext context, {
  required String message,
  String? note,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 28.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72.r,
                height: 72.r,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.successBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: AppColors.success, size: 36.r),
              ),
              SizedBox(height: 16.h),
              Text(
                'حسناً..!',
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 14.sp,
                  height: 1.5,
                ),
              ),
              if (note != null) ...[
                SizedBox(height: 12.h),
                Text(
                  note,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.navy,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ],
              SizedBox(height: 8.h),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('حسناً'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<String?> pickFlowDate(BuildContext context) async {
  final now = DateTime.now();
  final picked = await showDatePicker(
    context: context,
    initialDate: DateTime(now.year - 20),
    firstDate: DateTime(1950),
    lastDate: DateTime(now.year + 20),
  );
  if (picked == null) return null;
  final day = picked.day.toString().padLeft(2, '0');
  final month = picked.month.toString().padLeft(2, '0');
  return '$day/$month/${picked.year}';
}
