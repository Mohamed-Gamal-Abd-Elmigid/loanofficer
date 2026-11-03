class FundingProduct {
  const FundingProduct({
    required this.name,
    required this.loanType,
    required this.orgRequired,
    required this.maxAmount,
    required this.maxInstallments,
  });

  final String name;
  final int loanType;
  final bool orgRequired;
  final int maxAmount;
  final int maxInstallments;
}

class NewIndividualRequestModel {
  List<FundingProduct> products = [];
}
