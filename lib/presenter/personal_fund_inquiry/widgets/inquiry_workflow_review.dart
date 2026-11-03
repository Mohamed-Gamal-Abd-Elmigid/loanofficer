import 'package:flutter/material.dart';
import 'package:loanofficer/core/api/fund_track_api.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';
import 'package:loanofficer/presenter/fund_track/scene/fund_track_detail_scene.dart';

/// FMC `GET query/service/wfReviews?serviceId=` — **اجراءات مراجعة الطلب**.
class InquiryWorkflowReviewScene extends StatelessWidget {
  const InquiryWorkflowReviewScene({super.key, required this.row});

  final FundTrackRow row;

  static void open(BuildContext context, FundTrackRow row) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => InquiryWorkflowReviewScene(row: row),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      pageTitle: 'مراحل تقديم الطلب',
      pageIcon: Icons.route_outlined,
      onBack: () => Navigator.of(context).pop(),
      body: ColoredBox(
        color: AppColors.page,
        child: FundTrackReviewPanel(
          serviceId: row.serviceId,
          labels: FundTrackReviewLabels.inquiryWorkflow,
        ),
      ),
    );
  }
}
