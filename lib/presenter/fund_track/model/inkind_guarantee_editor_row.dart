import 'package:flutter/material.dart';

class InkindGuaranteeEditorRow {
  InkindGuaranteeEditorRow({
    required this.grantCode,
    required this.grantAmt,
    required this.acceptRete,
    required this.openDate,
    required this.endDate,
    required this.totalGrantAmt,
  });

  final TextEditingController grantCode;
  final TextEditingController grantAmt;
  final TextEditingController acceptRete;
  final TextEditingController openDate;
  final TextEditingController endDate;
  final TextEditingController totalGrantAmt;

  factory InkindGuaranteeEditorRow.fromApi(Map<String, dynamic> map) {
    final amt = _num(map['grantAmt']);
    final rate = _num(map['acceptRete']);
    final total = map['totalGrantAmt'] ?? (amt * rate / 100);
    return InkindGuaranteeEditorRow(
      grantCode: TextEditingController(text: '${map['grantCode'] ?? ''}'),
      grantAmt: TextEditingController(text: amt == 0 ? '' : '$amt'),
      acceptRete: TextEditingController(text: rate == 0 ? '' : '$rate'),
      openDate: TextEditingController(text: '${map['openDate'] ?? ''}'),
      endDate: TextEditingController(text: '${map['endDate'] ?? ''}'),
      totalGrantAmt: TextEditingController(
        text: total == null || '$total' == '0' ? '' : '$total',
      ),
    );
  }

  void recomputeTotal() {
    final amt = double.tryParse(grantAmt.text.trim()) ?? 0;
    final rate = double.tryParse(acceptRete.text.trim()) ?? 0;
    if (amt > 0 && rate > 0) {
      totalGrantAmt.text = (amt * rate / 100).toStringAsFixed(2);
    }
  }

  Map<String, dynamic> toPayload() {
    return {
      'grantCode': grantCode.text.trim(),
      'grantAmt': double.tryParse(grantAmt.text.trim()) ?? 0,
      'acceptRete': double.tryParse(acceptRete.text.trim()) ?? 0,
      'openDate': openDate.text.trim(),
      'endDate': endDate.text.trim(),
    };
  }

  void dispose() {
    grantCode.dispose();
    grantAmt.dispose();
    acceptRete.dispose();
    openDate.dispose();
    endDate.dispose();
    totalGrantAmt.dispose();
  }

  static double _num(dynamic v) {
    if (v is num) return v.toDouble();
    return double.tryParse('$v') ?? 0;
  }
}
