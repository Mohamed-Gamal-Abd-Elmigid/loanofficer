import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/fund_track_api.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/presenter/personal_fund_inquiry/scene/personal_fund_inquiry_option_scenes.dart';

/// FMC service-query ⋮ actions — shared between bottom sheet and متابعة الطلب footer.
class InquiryMenuAction {
  const InquiryMenuAction({
    required this.label,
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
}

class InquiryMenuGroup {
  const InquiryMenuGroup({
    required this.title,
    required this.icon,
    required this.actions,
  });

  final String title;
  final IconData icon;
  final List<InquiryMenuAction> actions;
}

List<InquiryMenuGroup> inquiryMenuGroupsForContext(
  BuildContext context,
  FundTrackRow row, {
  bool hideWorkflowReview = false,
  bool showSubmissionStagesRow = false,
}) {
  return [
    InquiryMenuGroup(
      title: 'بيانات التمويل',
      icon: Icons.account_balance_wallet_outlined,
      actions: [
        InquiryMenuAction(
          label: 'بيانات التمويل',
          icon: Icons.description_outlined,
          onTap: () => InquiryFundDataScene.open(context, row),
        ),
        InquiryMenuAction(
          label: 'بيانات الأقساط',
          icon: Icons.calendar_month_outlined,
          onTap: () => InquiryInstallmentsScene.open(context, row),
        ),
        InquiryMenuAction(
          label: 'الغرامات',
          icon: Icons.warning_amber_outlined,
          onTap: () => InquiryPenaltiesScene.open(context, row),
        ),
        InquiryMenuAction(
          label: 'بيانات الضامنين',
          icon: Icons.groups_outlined,
          onTap: () => InquiryGrantorsScene.open(context, row),
        ),
        InquiryMenuAction(
          label: 'بيانات المنشأة',
          icon: Icons.business_outlined,
          enabled: row.orgId.trim().isNotEmpty,
          onTap: () => InquiryOrganizationScene.open(context, row),
        ),
      ],
    ),
    InquiryMenuGroup(
      title: 'بيانات العميل',
      icon: Icons.person_outline,
      actions: [
        InquiryMenuAction(
          label: 'بيانات العميل',
          icon: Icons.badge_outlined,
          onTap: () => InquiryCustomerScene.open(context, row),
        ),
        InquiryMenuAction(
          label: 'كشف حساب عميل',
          icon: Icons.receipt_long_outlined,
          onTap: () => InquiryAccountStatementScene.open(context, row),
        ),
      ],
    ),
    InquiryMenuGroup(
      title: 'مراجعة الطلب',
      icon: Icons.fact_check_outlined,
      actions: [
        if (showSubmissionStagesRow)
          InquiryMenuAction(
            label: 'مراحل تقديم الطلب',
            icon: Icons.route_outlined,
            onTap: () => InquiryWorkflowReviewScene.open(context, row),
          )
        else if (!hideWorkflowReview)
          InquiryMenuAction(
            label: 'اجراءات مراجعة الطلب',
            icon: Icons.timeline,
            onTap: () => InquiryWorkflowReviewScene.open(context, row),
          ),
        InquiryMenuAction(
          label: 'المستندات',
          icon: Icons.folder_open_outlined,
          onTap: () => InquiryDocumentsScene.open(context, row),
        ),
        InquiryMenuAction(
          label: 'بيانات الدراسة المالية',
          icon: Icons.analytics_outlined,
          onTap: () => InquiryFinancialStudyScene.open(context, row),
        ),
      ],
    ),
  ];
}

/// End-of-screen actions on **متابعة الطلب** (grouped list — no uneven grid tiles).
class InquiryOrderActionsSection extends StatelessWidget {
  const InquiryOrderActionsSection({
    super.key,
    required this.row,
    this.hideWorkflowReview = true,
    this.showSectionHeader = true,
    this.showSubmissionStagesRow = false,
  });

  final FundTrackRow row;
  final bool hideWorkflowReview;
  final bool showSectionHeader;
  /// **مراحل تقديم الطلب** row inside **مراجعة الطلب** (متابعة الطلب).
  final bool showSubmissionStagesRow;

  @override
  Widget build(BuildContext context) {
    final groups = inquiryMenuGroupsForContext(
      context,
      row,
      hideWorkflowReview: hideWorkflowReview,
      showSubmissionStagesRow: showSubmissionStagesRow,
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showSectionHeader) ...[
            _SectionHeader(row: row),
            SizedBox(height: 14.h),
          ],
          for (var g = 0; g < groups.length; g++) ...[
            if (g > 0) SizedBox(height: 12.h),
            _GroupCard(group: groups[g]),
          ],
        ],
      ),
    );
  }
}

/// Matches **مسار الطلب** section title on [FundTrackReviewPanel].
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.row});

  final FundTrackRow row;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36.r,
          height: 36.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.iconBubble,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(Icons.apps_rounded, color: AppColors.accent, size: 20.r),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            'خيارات الطلب',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              color: const Color(0xFF032F64),
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F8),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: const Color(0xFFE4E9F0)),
          ),
          child: Text(
            row.serviceId,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF3C4F73),
            ),
          ),
        ),
      ],
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group});

  final InquiryMenuGroup group;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
            color: const Color(0xFFF4F7FA),
            child: Row(
              children: [
                Icon(group.icon, size: 18.r, color: AppColors.accent),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    group.title,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: AppFonts.dinNextArabic,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF032F64),
                    ),
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < group.actions.length; i++) ...[
            _ActionListRow(action: group.actions[i]),
            if (i < group.actions.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                indent: 56.w,
                endIndent: 14.w,
                color: const Color(0xFFE8EDF2),
              ),
          ],
        ],
      ),
    );
  }
}

class _ActionListRow extends StatelessWidget {
  const _ActionListRow({required this.action});

  final InquiryMenuAction action;

  @override
  Widget build(BuildContext context) {
    final enabled = action.enabled;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? action.onTap : null,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: enabled
                      ? AppColors.iconBubble
                      : const Color(0xFFEDF0F4),
                  borderRadius: BorderRadius.circular(11.r),
                ),
                child: Icon(
                  action.icon,
                  size: 20.r,
                  color: enabled ? AppColors.accent : const Color(0xFFB0B8C1),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  action.label,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                    color: enabled
                        ? const Color(0xFF2C2C2C)
                        : const Color(0xFFB0B8C1),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Icon(
                  enabled ? Icons.chevron_left : Icons.lock_outline,
                  size: 22.r,
                  color: enabled
                      ? const Color(0xFF9AA3AE)
                      : const Color(0xFFC5CDD6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
