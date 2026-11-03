import 'package:flutter/material.dart';
import 'package:loanofficer/presenter/personal_fund_inquiry/widgets/inquiry_customer_query.dart';

export 'package:loanofficer/presenter/personal_fund_inquiry/widgets/inquiry_customer_query.dart'
    show InquiryFieldSpec, InquiryReadonlyField;

class InquiryGrantorProfileScene extends StatelessWidget {
  const InquiryGrantorProfileScene({
    super.key,
    required this.idno,
    this.displayName,
  });

  final String idno;
  final String? displayName;

  static Future<void> open(
    BuildContext context, {
    required String idno,
    String? displayName,
  }) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => InquiryGrantorProfileScene(
          idno: idno,
          displayName: displayName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InquiryCustomerQueryView(
      idno: idno,
      displayName: displayName,
      pageTitle: 'بيانات الضامن',
    );
  }
}
