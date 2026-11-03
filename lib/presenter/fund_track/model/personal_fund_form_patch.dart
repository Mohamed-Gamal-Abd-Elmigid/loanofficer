import 'package:loanofficer/core/api/funding_orders_api.dart';

/// Maps `getByServiceId` + inbox row into editable wizard values (web `patchValue`).
class PersonalFundFormPatch {
  PersonalFundFormPatch({
    required this.fundRaw,
    required this.order,
  });

  final Map<String, dynamic> fundRaw;
  final FundingOrderRow order;

  String get serviceId => _s(fundRaw['serviceId'], order.serviceId);
  String get ticketId => _s(fundRaw['ticketId'], order.ticketId);
  String get wfCode => _s(fundRaw['wfCode'], order.wfCode);
  String get custno => _s(fundRaw['custno']);
  String get stepId =>
      _s(order.details.currentStepId).isEmpty ? '1' : order.details.currentStepId;
  String get stageId =>
      _s(order.details.currentStageId).isEmpty ? '1' : order.details.currentStageId;

  String get idno => _s(fundRaw['custId'], order.custId);
  String get customerName => _s(fundRaw['custName'], order.custName);
  String get loanType => _s(fundRaw['loanType']);
  String get prodType => _s(fundRaw['prodType'], '1');
  String get brCode => _s(fundRaw['brcode'] ?? fundRaw['brCode']);

  String get reqAmount => _s(fundRaw['requiredValue'], order.requiredValue);
  String get reqNoOfksts => _s(fundRaw['requiredNoOfKst'] ?? fundRaw['requiredNoOfksts']);
  String get approvedAmount => _s(fundRaw['approveValue']);
  String get approvedNoOfksts => _s(fundRaw['noOfKsts']);

  Map<String, dynamic> savePayload({
    String comment = '',
    String? reqAmountOverride,
    String? reqNoOfkstsOverride,
    String? approvedAmountOverride,
    String? approvedNoOfkstsOverride,
  }) {
    return {
      'approvedAmount': _num(approvedAmountOverride ?? approvedAmount),
      'approvedNoOfksts': _num(approvedNoOfkstsOverride ?? approvedNoOfksts),
      'idno': idno,
      'loanType': _num(loanType),
      'orgId': fundRaw['orgId'],
      'prodType': prodType,
      'reqAmount': _num(reqAmountOverride ?? reqAmount),
      'reqNoOfksts': _num(reqNoOfkstsOverride ?? reqNoOfksts),
      'serviceId': serviceId,
      'ticketId': ticketId,
      'wfCode': wfCode,
      'brCode': brCode,
      'stepId': stepId,
      'stageId': stageId,
      'comment': comment,
    };
  }

  Map<String, dynamic> wfSavePayload({String comment = ''}) {
    return {
      'ticketId': ticketId,
      'serviceId': serviceId,
      'prodType': prodType,
      'comment': comment,
      'amount': null,
      'noOfksts': null,
      'stageId': stageId,
    };
  }

  static String _s(dynamic value, [String fallback = '']) {
    if (value == null) return fallback;
    final t = '$value'.trim();
    return t.isEmpty ? fallback : t;
  }

  static dynamic _num(String value) {
    final t = value.trim();
    if (t.isEmpty) return null;
    final i = int.tryParse(t);
    if (i != null) return i;
    return double.tryParse(t) ?? t;
  }
}
