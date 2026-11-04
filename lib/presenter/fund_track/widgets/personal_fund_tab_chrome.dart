import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';

/// Brand gradient: primary → secondary ([AppColors.accent]).
LinearGradient get personalFundBrandGradient => const LinearGradient(
      colors: [AppColors.primary, AppColors.accent],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    );

/// Icons for the four main personal-fund wizard tabs (web parity).
IconData personalFundTabIcon(String tabId) {
  return switch (tabId) {
    'fund' => Icons.account_balance_wallet_outlined,
    'warr' => Icons.verified_user_outlined,
    'docs' => Icons.folder_open_outlined,
    'refuse' => Icons.report_gmailerrorred_outlined,
    _ => Icons.layers_outlined,
  };
}

/// Secondary brand color (same for all tabs).
Color personalFundTabAccent(String tabId) => AppColors.accent;

String? personalFundTabSubtitle(String tabId) {
  return switch (tabId) {
    'fund' => 'تفاصيل الطلب والمبالغ',
    'warr' => 'بيانات الضامن',
    'docs' => 'مرفقات ومعاينة المستندات',
    'refuse' => 'أسباب الرفض والمعالجة',
    _ => null,
  };
}

/// Height of [PersonalFundWizardTabBar] including outer padding (for pinned sliver).
double personalFundWizardTabBarExtent() => 6.r * 2 + 52.h + 10.h;

/// Full-width tab strip — each tab shares equal width (بيانات التمويل … أسباب الرفض).
class PersonalFundWizardTabBar extends StatelessWidget {
  const PersonalFundWizardTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.elevated = false,
  });

  final TabController controller;
  final List<({String id, String label})> tabs;

  /// Stronger shadow when the bar is pinned over scrolled content.
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.page,
      elevation: elevated ? 2 : 0,
      shadowColor: AppColors.cardShadow,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 6.h),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: elevated ? 16.r : 12.r,
                offset: Offset(0, elevated ? 4.h : 3.h),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(6.r),
            child: TabBar(
              controller: controller,
              isScrollable: false,
              tabAlignment: TabAlignment.fill,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: EdgeInsets.zero,
              labelColor: AppColors.white,
              unselectedLabelColor: AppColors.muted,
              tabs: [
                for (final tab in tabs)
                  Tab(
                    height: 52.h,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(personalFundTabIcon(tab.id), size: 18.r),
                          SizedBox(height: 3.h),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              tab.label,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppFonts.dinNextArabic,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                              ),
                            ),
                          ),
                        ],
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

/// Pins the wizard tab strip under a collapsing order header ([NestedScrollView]).
class PersonalFundPinnedTabBarDelegate extends SliverPersistentHeaderDelegate {
  PersonalFundPinnedTabBarDelegate({
    required this.controller,
    required this.tabs,
    required this.elevated,
  });

  final TabController controller;
  final List<({String id, String label})> tabs;
  final bool elevated;

  @override
  double get minExtent => personalFundWizardTabBarExtent();

  @override
  double get maxExtent => personalFundWizardTabBarExtent();

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return PersonalFundWizardTabBar(
      controller: controller,
      tabs: tabs,
      elevated: elevated || overlapsContent || shrinkOffset > 0,
    );
  }

  @override
  bool shouldRebuild(covariant PersonalFundPinnedTabBarDelegate oldDelegate) {
    return oldDelegate.controller != controller ||
        oldDelegate.elevated != elevated ||
        oldDelegate.tabs.length != tabs.length ||
        !_sameTabs(oldDelegate.tabs, tabs);
  }

  static bool _sameTabs(
    List<({String id, String label})> a,
    List<({String id, String label})> b,
  ) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id || a[i].label != b[i].label) return false;
    }
    return true;
  }
}

/// Compact tab title (no second gradient — order header carries brand).
class PersonalFundTabSectionHeader extends StatelessWidget {
  const PersonalFundTabSectionHeader({
    super.key,
    required this.tabId,
    required this.title,
  });

  final String tabId;
  final String title;

  @override
  Widget build(BuildContext context) {
    final subtitle = personalFundTabSubtitle(tabId);
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.iconBubble,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.2),
              ),
            ),
            child: Icon(
              personalFundTabIcon(tabId),
              color: AppColors.accent,
              size: 22.r,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    color: AppColors.primary,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: AppFonts.dinNextArabic,
                      color: AppColors.fieldLabel,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// KPI chip for order header / fund tab.
class PersonalFundStatChip extends StatelessWidget {
  const PersonalFundStatChip({
    super.key,
    required this.label,
    required this.value,
    this.highlight = false,
    this.compact = false,
  });

  final String label;
  final String value;
  final bool highlight;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final valueSize = compact ? 13.sp : 14.sp;
    final labelSize = compact ? 9.sp : 10.sp;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8.w : 10.w,
          vertical: compact ? 8.h : 10.h,
        ),
        decoration: BoxDecoration(
          color: highlight ? AppColors.iconBubble : AppColors.card,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: highlight
                ? AppColors.accent.withValues(alpha: 0.4)
                : AppColors.cardBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              label,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppFonts.dinNextArabic,
                fontSize: labelSize,
                fontWeight: FontWeight.w600,
                color: AppColors.fieldLabel,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              value.isEmpty ? '—' : value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppFonts.dinNextArabic,
                fontSize: valueSize,
                fontWeight: FontWeight.w800,
                color: highlight ? AppColors.primary : AppColors.text,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Standard tab scroll body (page bg + hero + content).
///
/// Uses always-scrollable physics so [NestedScrollView] can collapse/expand
/// the order header even when tab content is short.
class PersonalFundTabPage extends StatelessWidget {
  const PersonalFundTabPage({
    super.key,
    required this.tabId,
    required this.title,
    required this.children,
    this.showSectionHeader = true,
  });

  final String tabId;
  final String title;
  final List<Widget> children;
  final bool showSectionHeader;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.page,
      child: ListView(
        key: PageStorageKey<String>('personal-fund-tab-$tabId'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        children: [
          if (showSectionHeader)
            PersonalFundTabSectionHeader(tabId: tabId, title: title),
          ...children,
        ],
      ),
    );
  }
}

/// In-form section divider (بيانات العميل، ملخص المبالغ، …).
class PersonalFundFormSection extends StatelessWidget {
  const PersonalFundFormSection({
    super.key,
    required this.title,
    required this.children,
    this.icon,
  });

  final String title;
  final List<Widget> children;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18.r, color: AppColors.accent),
                SizedBox(width: 8.w),
              ],
              Text(
                title,
                style: TextStyle(
                  fontFamily: AppFonts.dinNextArabic,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Container(
                  height: 1,
                  color: AppColors.divider,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }
}

class PersonalFundEmptyState extends StatelessWidget {
  const PersonalFundEmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.accent,
  });

  final IconData icon;
  final String message;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final color = accent ?? AppColors.accent;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64.r,
            height: 64.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.iconBubble,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32.r, color: color),
          ),
          SizedBox(height: 14.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              color: AppColors.muted,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Scrollable empty/disabled tab body so NestedScrollView can still collapse
/// the order header when there is little content.
Widget personalFundScrollableEmpty({required Widget child, String? storageKey}) {
  return ColoredBox(
    color: AppColors.page,
    child: CustomScrollView(
      key: storageKey == null ? null : PageStorageKey<String>(storageKey),
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: child,
        ),
      ],
    ),
  );
}
