import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fund_track_api.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';
import 'package:loanofficer/presenter/personal_fund_inquiry/inquiry_order_actions.dart';

class FundTrackDetailScene extends StatelessWidget {
  const FundTrackDetailScene({
    super.key,
    required this.serviceId,
    this.inquiryRow,
  });

  final String serviceId;
  final FundTrackRow? inquiryRow;

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      pageTitle: 'متابعة الطلب',
      pageIcon: Icons.timeline,
      onBack: () => Navigator.of(context).pop(),
      body: ColoredBox(
        color: AppColors.page,
        child: FundTrackReviewPanel(
          serviceId: serviceId,
          inquiryRow: inquiryRow,
          labels: inquiryRow != null
              ? FundTrackReviewLabels.inquiryWorkflow
              : FundTrackReviewLabels.followUp,
        ),
      ),
    );
  }
}

/// Labels for inquiry ⋮ vs **متابعة الطلب** embed.
class FundTrackReviewLabels {
  const FundTrackReviewLabels({
    required this.summaryTitle,
    required this.stagesTitle,
    required this.loadingMessage,
    required this.inquiryStyleSummary,
  });

  final String summaryTitle;
  final String stagesTitle;
  final String loadingMessage;
  final bool inquiryStyleSummary;

  static const followUp = FundTrackReviewLabels(
    summaryTitle: 'بيانات الطلب',
    stagesTitle: 'مسار الطلب',
    loadingMessage: 'جاري تحميل مسار الطلب...',
    inquiryStyleSummary: false,
  );

  static const inquiryWorkflow = FundTrackReviewLabels(
    summaryTitle: 'بيانات طلب التمويل',
    stagesTitle: 'مراحل تقديم الطلب',
    loadingMessage: 'جاري تحميل مراجعة الطلب...',
    inquiryStyleSummary: true,
  );
}

/// Workflow review data (`wfReviews`) for a service — usable inline or full screen.
class FundTrackReviewPanel extends StatefulWidget {
  const FundTrackReviewPanel({
    super.key,
    required this.serviceId,
    this.inquiryRow,
    this.labels = FundTrackReviewLabels.followUp,
  });

  final String serviceId;
  final FundTrackRow? inquiryRow;
  final FundTrackReviewLabels labels;

  @override
  State<FundTrackReviewPanel> createState() => _FundTrackReviewPanelState();
}

class _FundTrackReviewPanelState extends State<FundTrackReviewPanel> {
  final _api = FundTrackApi();
  FundTrackServiceDetail? _detail;
  String? _error;
  bool _loading = false;

  bool get _inquiryActionsOnly => widget.inquiryRow != null;

  @override
  void initState() {
    super.initState();
    if (!_inquiryActionsOnly) {
      _load();
    }
  }

  @override
  void didUpdateWidget(covariant FundTrackReviewPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_inquiryActionsOnly) return;
    if (oldWidget.serviceId != widget.serviceId) {
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _error = null;
      _detail = null;
      _loading = true;
    });
    try {
      final detail = await _api.serviceWorkflowReviews(widget.serviceId);
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = apiErrorMessage(error);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_inquiryActionsOnly) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        children: [
          InquiryOrderActionsSection(
            row: widget.inquiryRow!,
            hideWorkflowReview: true,
            showSectionHeader: true,
            showSubmissionStagesRow: true,
          ),
          SizedBox(height: 8.h),
        ],
      );
    }

    return RefreshIndicator(
      color: AppColors.accent,
      onRefresh: _load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        children: [
          if (_loading)
            _LoadingBlock(message: widget.labels.loadingMessage)
          else if (_error != null)
            _ErrorBlock(message: _error!, onRetry: _load)
          else if (_detail != null) ...[
            _SummaryCard(
              serviceId: widget.serviceId,
              detail: _detail!,
              labels: widget.labels,
            ),
            SizedBox(height: 20.h),
            _SectionTitle(
              icon: Icons.route_outlined,
              title: widget.labels.stagesTitle,
              trailing: Text(
                '${_detail!.wfReviews.length} مرحلة',
                style: TextStyle(
                  fontFamily: AppFonts.dinNextArabic,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF9AA3AE),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            if (_detail!.wfReviews.isEmpty)
              _EmptyTimeline()
            else
              for (var i = 0; i < _detail!.wfReviews.length; i++) ...[
                _TimelineStep(
                  review: _detail!.wfReviews[i],
                  isFirst: i == 0,
                  isLast: i == _detail!.wfReviews.length - 1,
                ),
                if (i < _detail!.wfReviews.length - 1)
                  Padding(
                    padding: EdgeInsets.only(right: 19.w, left: 16.w),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: const Color(0xFFE4E9F0),
                    ),
                  ),
              ],
          ],
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Container(
          width: 36.r,
          height: 36.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.iconBubble,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: AppColors.accent, size: 20.r),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              color: const Color(0xFF032F64),
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.serviceId,
    required this.detail,
    required this.labels,
  });

  final String serviceId;
  final FundTrackServiceDetail detail;
  final FundTrackReviewLabels labels;

  @override
  Widget build(BuildContext context) {
    if (labels.inquiryStyleSummary) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F5F7),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: const Color(0xFFE2E8EE)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                labels.summaryTitle,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: AppFonts.dinNextArabic,
                  color: const Color(0xFF032F64),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 12.h),
              _InquirySummaryField(
                label: 'إسم العميل',
                value: detail.custName,
              ),
              SizedBox(height: 10.h),
              _InquirySummaryField(
                label: 'إجراء العمل',
                value: detail.wfNameAr,
              ),
              SizedBox(height: 10.h),
              _InquirySummaryField(
                label: 'المرحلة الحالية',
                value: detail.currentStageNameAr,
              ),
            ],
          ),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 14.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 44.r,
                  height: 44.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.iconBubble,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.assignment_outlined,
                    color: AppColors.accent,
                    size: 24.r,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        labels.summaryTitle,
                        style: TextStyle(
                          fontFamily: AppFonts.dinNextArabic,
                          color: const Color(0xFF032F64),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        detail.custName.isEmpty ? '—' : detail.custName,
                        style: TextStyle(
                          fontFamily: AppFonts.dinNextArabic,
                          color: const Color(0xFF2C2C2C),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (detail.currentStageNameAr.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F3FC),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: const Color(0xFFB8DCF5)),
                  ),
                  child: Text(
                    detail.currentStageNameAr,
                    style: TextStyle(
                      fontFamily: AppFonts.dinNextArabic,
                      color: const Color(0xFF0369A1),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
            SizedBox(height: 14.h),
            Divider(height: 1, color: const Color(0xFFE4E9F0)),
            SizedBox(height: 12.h),
            _InfoLine(icon: Icons.account_tree_outlined, label: 'مسار العمل', value: detail.wfNameAr),
            _InfoLine(icon: Icons.confirmation_number_outlined, label: 'رقم الخدمة', value: serviceId),
            if (detail.ticketId.isNotEmpty)
              _InfoLine(icon: Icons.tag, label: 'رقم التذكرة', value: detail.ticketId),
          ],
        ),
      ),
    );
  }
}

class _InquirySummaryField extends StatelessWidget {
  const _InquirySummaryField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: AppFonts.dinNextArabic,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF6B7280),
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFD5DDE6)),
          ),
          child: Text(
            value.isEmpty ? '—' : value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF032F64),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.r, color: AppColors.accent),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              color: const Color(0xFF9AA3AE),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: AppFonts.dinNextArabic,
                color: const Color(0xFF032F64),
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.review,
    required this.isFirst,
    required this.isLast,
  });

  final WfReview review;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final done = review.action;
    final dotColor = done ? AppColors.success : const Color(0xFFF97316);
    final dotBg = done ? AppColors.successBackground : const Color(0xFFFFEDD5);
    final comment = review.comments == 'null' || review.comments.isEmpty
        ? null
        : review.comments;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 40.w,
              child: Column(
                children: [
                  if (!isFirst)
                    Expanded(
                      child: Container(
                        width: 2.w,
                        color: const Color(0xFFD5DDE6),
                      ),
                    ),
                  Container(
                    width: 28.r,
                    height: 28.r,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: dotBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: dotColor, width: 2),
                    ),
                    child: Icon(
                      done ? Icons.check_rounded : Icons.schedule,
                      size: 16.r,
                      color: dotColor,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2.w,
                        color: const Color(0xFFD5DDE6),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14.r),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(color: const Color(0xFFE4E9F0)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF032F64).withValues(alpha: 0.05),
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
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 12.h,
                              ),
                              color: const Color(0xFF032F64),
                              child: Text(
                                review.nameAr.isEmpty ? '—' : review.nameAr,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: AppFonts.dinNextArabic,
                                  color: AppColors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(14.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: _ActionChip(
                                      label: review.actionNameAr.isEmpty
                                          ? '—'
                                          : review.actionNameAr,
                                      done: done,
                                    ),
                                  ),
                                  if (review.assigneeLine.isNotEmpty) ...[
                                    SizedBox(height: 10.h),
                                    Text(
                                      review.assigneeLine,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontFamily: AppFonts.dinNextArabic,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.accent,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                  if (comment != null) ...[
                                    SizedBox(height: 10.h),
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEEF2FF),
                                        borderRadius: BorderRadius.circular(10.r),
                                        border: Border.all(
                                          color: const Color(0xFFD6E0F5),
                                        ),
                                      ),
                                      child: Text(
                                        comment,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontFamily: AppFonts.dinNextArabic,
                                          color: const Color(0xFF5C6F8A),
                                          fontSize: 12.sp,
                                          height: 1.45,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (review.startDate.isNotEmpty ||
                        review.finishDate.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.only(right: 4.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (review.startDate.isNotEmpty)
                              Text(
                                'من ${review.startDate}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: AppFonts.dinNextArabic,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accent,
                                ),
                              ),
                            if (review.finishDate.isNotEmpty) ...[
                              SizedBox(height: 2.h),
                              Text(
                                'إلى ${review.finishDate}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: AppFonts.dinNextArabic,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accent,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.label, required this.done});

  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: done ? AppColors.successBackground : const Color(0xFFFFEDD5),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (done) ...[
            Icon(Icons.check_circle, size: 14.r, color: const Color(0xFF065F46)),
            SizedBox(width: 4.w),
          ],
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.dinNextArabic,
                color: done ? const Color(0xFF065F46) : const Color(0xFF9A3412),
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingBlock extends StatelessWidget {
  const _LoadingBlock({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 48.h),
      child: Column(
        children: [
          SizedBox(
            width: 36.r,
            height: 36.r,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.accent,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              color: const Color(0xFF9AA3AE),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBlock extends StatelessWidget {
  const _ErrorBlock({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: AppColors.primary, size: 32.r),
          SizedBox(height: 10.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              color: AppColors.primary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          SizedBox(height: 12.h),
          TextButton.icon(
            onPressed: onRetry,
            icon: Icon(Icons.refresh, size: 18.r, color: AppColors.accent),
            label: Text(
              'إعادة المحاولة',
              style: TextStyle(
                fontFamily: AppFonts.dinNextArabic,
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        children: [
          Icon(Icons.timeline, size: 40.r, color: const Color(0xFF9AA3AE)),
          SizedBox(height: 12.h),
          Text(
            'لا توجد مراحل مسجلة لهذا الطلب',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              color: const Color(0xFF9AA3AE),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
