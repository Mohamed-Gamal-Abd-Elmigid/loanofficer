import 'package:flutter/material.dart';
import 'package:loanofficer/core/api/funding_orders_api.dart';
import 'package:loanofficer/presenter/fund_track/scene/personal_fund_detail_scene.dart';

/// Opens the full personal-fund wizard (same as web edit route).
class EditPersonalFundScene extends StatelessWidget {
  const EditPersonalFundScene({super.key, required this.order});

  final FundingOrderRow order;

  @override
  Widget build(BuildContext context) {
    return PersonalFundDetailScene(order: order);
  }
}
