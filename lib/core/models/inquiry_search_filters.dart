/// Advanced criteria for Fusion `query/service/findService` (web filter modal).
class InquirySearchFilters {
  const InquirySearchFilters({
    this.status,
    this.prodType,
    this.loanType,
    this.regionalArea,
    this.brcode,
    this.loCode,
    this.fromIssueDate,
    this.toIssueDate,
    this.fromApproveValue,
    this.toApproveValue,
    this.fromBalValue,
    this.toBalValue,
    this.fromNoLateDays,
    this.toNoLateDays,
    this.offloadingBatchId,
    this.legalAction,
  });

  final String? status;
  final String? prodType;
  final String? loanType;
  final String? regionalArea;
  final int? brcode;
  final String? loCode;
  final String? fromIssueDate;
  final String? toIssueDate;
  final String? fromApproveValue;
  final String? toApproveValue;
  final String? fromBalValue;
  final String? toBalValue;
  final String? fromNoLateDays;
  final String? toNoLateDays;
  final String? offloadingBatchId;
  final String? legalAction;

  bool get hasAny =>
      status != null ||
      prodType != null ||
      loanType != null ||
      regionalArea != null ||
      brcode != null ||
      loCode != null ||
      fromIssueDate != null ||
      toIssueDate != null ||
      fromApproveValue != null ||
      toApproveValue != null ||
      fromBalValue != null ||
      toBalValue != null ||
      fromNoLateDays != null ||
      toNoLateDays != null ||
      offloadingBatchId != null ||
      legalAction != null;

  InquirySearchFilters copyWith({
    String? Function()? status,
    String? Function()? prodType,
    String? Function()? loanType,
    String? Function()? regionalArea,
    int? Function()? brcode,
    String? Function()? loCode,
    String? Function()? fromIssueDate,
    String? Function()? toIssueDate,
    String? Function()? fromApproveValue,
    String? Function()? toApproveValue,
    String? Function()? fromBalValue,
    String? Function()? toBalValue,
    String? Function()? fromNoLateDays,
    String? Function()? toNoLateDays,
    String? Function()? offloadingBatchId,
    String? Function()? legalAction,
  }) {
    return InquirySearchFilters(
      status: status != null ? status() : this.status,
      prodType: prodType != null ? prodType() : this.prodType,
      loanType: loanType != null ? loanType() : this.loanType,
      regionalArea: regionalArea != null ? regionalArea() : this.regionalArea,
      brcode: brcode != null ? brcode() : this.brcode,
      loCode: loCode != null ? loCode() : this.loCode,
      fromIssueDate:
          fromIssueDate != null ? fromIssueDate() : this.fromIssueDate,
      toIssueDate: toIssueDate != null ? toIssueDate() : this.toIssueDate,
      fromApproveValue: fromApproveValue != null
          ? fromApproveValue()
          : this.fromApproveValue,
      toApproveValue:
          toApproveValue != null ? toApproveValue() : this.toApproveValue,
      fromBalValue:
          fromBalValue != null ? fromBalValue() : this.fromBalValue,
      toBalValue: toBalValue != null ? toBalValue() : this.toBalValue,
      fromNoLateDays:
          fromNoLateDays != null ? fromNoLateDays() : this.fromNoLateDays,
      toNoLateDays:
          toNoLateDays != null ? toNoLateDays() : this.toNoLateDays,
      offloadingBatchId: offloadingBatchId != null
          ? offloadingBatchId()
          : this.offloadingBatchId,
      legalAction: legalAction != null ? legalAction() : this.legalAction,
    );
  }

  /// Keys sent in POST body (non-empty only), dates already `DD/MM/YYYY`.
  Map<String, dynamic> toApiMap() {
    final map = <String, dynamic>{};
    void put(String key, dynamic value) {
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      map[key] = value;
    }

    put('status', status);
    put('prodType', prodType);
    put('loanType', loanType);
    put('regionalArea', regionalArea);
    put('brcode', brcode);
    put('loCode', loCode);
    put('fromIssueDate', fromIssueDate);
    put('toIssueDate', toIssueDate);
    put('fromApproveValue', fromApproveValue);
    put('toApproveValue', toApproveValue);
    put('fromBalValue', fromBalValue);
    put('toBalValue', toBalValue);
    put('fromNoLateDays', fromNoLateDays);
    put('toNoLateDays', toNoLateDays);
    put('offloadingBatchId', offloadingBatchId);
    put('legalAction', legalAction);
    return map;
  }
}
