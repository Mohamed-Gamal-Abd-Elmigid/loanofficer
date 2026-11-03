import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/fund_track_api.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/presenter/personal_fund_inquiry/inquiry_order_actions.dart';

/// Web `FundingServiceQueryComponent.populateTableMenu` — bottom sheet fallback.
class PersonalFundInquiryMenu {
  static Future<void> show(
    BuildContext context, {
    required FundTrackRow row,
    bool hideWorkflowReview = false,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: AppColors.page,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: Icon(Icons.close_rounded, size: 26.r),
                      tooltip: 'إغلاق',
                    ),
                    Expanded(
                      child: Text(
                        'خيارات الطلب',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFonts.dinNextArabic,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF032F64),
                        ),
                      ),
                    ),
                    SizedBox(width: 48.w),
                  ],
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: InquiryOrderActionsSection(
                      row: row,
                      hideWorkflowReview: hideWorkflowReview,
                      showSectionHeader: false,
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
