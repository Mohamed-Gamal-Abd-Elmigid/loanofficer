import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/models/fund_workflow_authority.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';
import 'package:loanofficer/presenter/fund_track/widgets/personal_fund_tab_chrome.dart'
    show personalFundBrandGradient;

Widget personalFundDisabledTab(String message) {
  return ColoredBox(
    color: AppColors.page,
    child: CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.dinNextArabic,
                  color: AppColors.muted,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget personalFundReadonlyBanner(String text) {
  return Container(
    margin: EdgeInsets.only(bottom: 12.h),
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
    decoration: BoxDecoration(
      color: AppColors.iconBubble,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: AppColors.cardBorder),
    ),
    child: Row(
      textDirection: TextDirection.rtl,
      children: [
        Icon(Icons.info_outline, size: 18.r, color: AppColors.accent),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
              height: 1.35,
            ),
          ),
        ),
      ],
    ),
  );
}

/// Main form shell for personal fund tabs (web-style card).
class PersonalFundFormShell extends StatelessWidget {
  const PersonalFundFormShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 16.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 3.h,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
            child: child,
          ),
        ],
      ),
    );
  }
}

class PersonalFundInfoCard extends StatelessWidget {
  const PersonalFundInfoCard({
    super.key,
    required this.title,
    required this.lines,
    this.accent = AppColors.primary,
  });

  final String title;
  final List<Widget> lines;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
            decoration: BoxDecoration(
              gradient: accent == AppColors.primary
                  ? personalFundBrandGradient
                  : null,
              color: accent == AppColors.primary ? null : accent,
            ),
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: AppFonts.dinNextArabic,
                color: AppColors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: lines,
            ),
          ),
        ],
      ),
    );
  }
}

/// Key on the right, value on the left (RTL).
class PersonalFundLine extends StatelessWidget {
  const PersonalFundLine(this.label, this.value, {super.key, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.fieldLabel,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: AppFonts.dinNextArabic,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: valueColor ?? AppColors.text,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PersonalFundField extends StatelessWidget {
  const PersonalFundField({
    super.key,
    required this.label,
    required this.controller,
    required this.authority,
    required this.tabRole,
    required this.controlPath,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final FundWorkflowAuthority authority;
  final String tabRole;
  final String controlPath;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    if (!authority.controlVisible(tabRole, controlPath)) {
      return const SizedBox.shrink();
    }
    final editable = authority.controlEditable(tabRole, controlPath);
    return PersonalFundLabeledField(
      label: label,
      child: FlowTextField(
        controller: controller,
        hint: label,
        readOnly: !editable,
        filledColor: editable ? null : AppColors.card,
        textColor: editable ? null : AppColors.text,
        keyboardType: keyboardType ?? TextInputType.text,
        onChanged: (_) {},
      ),
    );
  }
}

class PersonalFundLabeledField extends StatelessWidget {
  const PersonalFundLabeledField({
    super.key,
    required this.label,
    required this.child,
    this.trailing,
  });

  final String label;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: FlowLabel(label),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          SizedBox(height: 6.h),
          child,
        ],
      ),
    );
  }
}

/// Read-only cell when [controlPath] is visible; hidden when authority marks it N.
class PersonalFundAuthorityReadonly extends StatelessWidget {
  const PersonalFundAuthorityReadonly({
    super.key,
    required this.label,
    required this.value,
    required this.authority,
    required this.tabRole,
    required this.controlPath,
  });

  final String label;
  final String value;
  final FundWorkflowAuthority authority;
  final String tabRole;
  final String controlPath;

  @override
  Widget build(BuildContext context) {
    if (!authority.controlVisible(tabRole, controlPath)) {
      return const SizedBox.shrink();
    }
    return PersonalFundReadonlyValue(label: label, value: value);
  }
}

class PersonalFundReadonlyValue extends StatelessWidget {
  const PersonalFundReadonlyValue({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return PersonalFundLabeledField(
      label: label,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Text(
          value.isEmpty ? '—' : value,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: AppFonts.dinNextArabic,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
      ),
    );
  }
}

class PersonalFundIconAction extends StatelessWidget {
  const PersonalFundIconAction({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.enabled = true,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: enabled ? AppColors.iconBubble : AppColors.card,
        borderRadius: BorderRadius.circular(10.r),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(10.r),
          child: Padding(
            padding: EdgeInsets.all(8.r),
            child: Icon(
              icon,
              size: 20.r,
              color: enabled ? AppColors.accent : AppColors.muted,
            ),
          ),
        ),
      ),
    );
  }
}

class PersonalFundFormGrid extends StatelessWidget {
  const PersonalFundFormGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 520;
        if (!wide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) SizedBox(height: 4.h),
                children[i],
              ],
            ],
          );
        }
        return Wrap(
          spacing: 10.w,
          runSpacing: 4.h,
          children: [
            for (final child in children)
              SizedBox(
                width: (constraints.maxWidth - 20.w) / 3,
                child: child,
              ),
          ],
        );
      },
    );
  }
}

class PersonalFundOutlineButton extends StatelessWidget {
  const PersonalFundOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          disabledForegroundColor: AppColors.buttonDisabledText,
          side: BorderSide(
            color: enabled ? AppColors.accent : AppColors.buttonNeutral,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle: TextStyle(
            fontFamily: AppFonts.dinNextArabic,
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: TextDirection.rtl,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18.r),
              SizedBox(width: 6.w),
            ],
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PersonalFundCompactPrimaryButton extends StatelessWidget {
  const PersonalFundCompactPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.buttonNeutral,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle: TextStyle(
            fontFamily: AppFonts.dinNextArabic,
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: TextDirection.rtl,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18.r),
              SizedBox(width: 6.w),
            ],
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PersonalFundDocumentCard extends StatelessWidget {
  const PersonalFundDocumentCard({
    super.key,
    required this.title,
    required this.lines,
    required this.actions,
    this.statusColor,
  });

  final String title;
  final List<Widget> lines;
  final Widget actions;
  final Color? statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.w, 0, 10.w, 10.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 3.h,
            decoration: BoxDecoration(gradient: personalFundBrandGradient),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
            decoration: BoxDecoration(
              color: statusColor ?? AppColors.card,
              border: Border(
                bottom: BorderSide(color: AppColors.cardBorder),
              ),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 20.r,
                  color: AppColors.accent,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: AppFonts.dinNextArabic,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...lines,
                SizedBox(height: 10.h),
                actions,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> personalFundMapLines(
  Map<String, dynamic> map,
  List<(String key, String label)> defs,
) {
  final out = <Widget>[];
  for (final def in defs) {
    final v = map[def.$1];
    if (v == null || '$v'.trim().isEmpty) continue;
    out.add(PersonalFundLine(def.$2, '$v'));
  }
  return out;
}

String personalFundFundText(Map<String, dynamic> fund, List<String> keys) {
  for (final key in keys) {
    final v = fund[key];
    if (v != null && '$v'.trim().isNotEmpty) return '$v'.trim();
  }
  return '';
}
