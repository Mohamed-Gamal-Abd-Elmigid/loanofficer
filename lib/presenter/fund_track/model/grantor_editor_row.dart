import 'package:flutter/material.dart';

class GrantorEditorRow {
  GrantorEditorRow({
    this.grantCustNo,
    required this.grantIdno,
    required this.custName,
    required this.orderby,
    required this.relationType,
  });

  String? grantCustNo;
  final TextEditingController grantIdno;
  final TextEditingController custName;
  final TextEditingController orderby;
  String? relationType;

  factory GrantorEditorRow.fromApi(Map<String, dynamic> map) {
    return GrantorEditorRow(
      grantCustNo: map['grantCustNo']?.toString(),
      grantIdno: TextEditingController(
        text: '${map['grantIdno'] ?? ''}'.trim(),
      ),
      custName: TextEditingController(
        text: '${map['grantFullName'] ?? map['custName'] ?? ''}'.trim(),
      ),
      orderby: TextEditingController(
        text: '${map['orderby'] ?? ''}'.trim(),
      ),
      relationType: '${map['relationType'] ?? ''}'.trim().isEmpty
          ? null
          : '${map['relationType']}',
    );
  }

  Map<String, dynamic> toPayload() {
    return {
      if (grantCustNo != null && grantCustNo!.isNotEmpty)
        'grantCustNo': grantCustNo,
      'grantIdno': grantIdno.text.trim(),
      'orderby': orderby.text.trim(),
      'relationType': relationType,
    };
  }

  void dispose() {
    grantIdno.dispose();
    custName.dispose();
    orderby.dispose();
  }
}
