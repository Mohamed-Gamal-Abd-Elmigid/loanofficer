import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fmc_client.dart';
import 'package:loanofficer/core/api/fmc_session.dart';
import 'package:loanofficer/core/components/app_loading.dart';

/// Fusion `/funding-requests` inbox (`wf/action/inbox?action=PULL`).
class FundingOrdersApi {
  FundingOrdersApi({FmcClient? client, FmcSession? session})
    : _client = client ?? FmcClient(),
      _session = session ?? FmcSession.instance;

  final FmcClient _client;
  final FmcSession _session;

  Future<List<FundingOrderRow>> inboxOrders() {
    return AppLoading.watch(() async {
      if (!_session.isSignedIn) {
        throw AuthApiException('بيانات الدخول غير صحيحة');
      }
      final result = await _client.get(
        'wf/action/inbox',
        query: {'action': 'PULL'},
      );
      return _rows(result);
    });
  }

  Future<Map<String, dynamic>> fundService(String serviceId) {
    return AppLoading.watch(() async {
      final result = await _client.get(
        'query/service/getByServiceId/${serviceId.trim()}',
      );
      if (result is Map) return Map<String, dynamic>.from(result);
      return const {};
    });
  }

  static List<FundingOrderRow> _rows(dynamic result) {
    if (result is! List) return const [];
    final rows = <FundingOrderRow>[];
    for (final item in result) {
      if (item is! Map) continue;
      rows.add(FundingOrderRow.fromMap(Map<String, dynamic>.from(item)));
    }
    return rows;
  }
}

class FundingOrderRow {
  const FundingOrderRow({
    required this.serviceId,
    required this.custId,
    required this.custName,
    required this.requiredValue,
    required this.loanTypeName,
    required this.branchName,
    required this.statusLabel,
    required this.statusCode,
    required this.createdDate,
    required this.ticketId,
    required this.prodType,
    required this.wfCode,
    required this.details,
  });

  final String serviceId;
  final String custId;
  final String custName;
  final String requiredValue;
  final String loanTypeName;
  final String branchName;
  final String statusLabel;
  final String statusCode;
  final String createdDate;
  final String ticketId;
  final String prodType;
  final String wfCode;
  final FundingOrderDetails details;

  bool get isPersonalFund =>
      prodType == '1' ||
      prodType == 'FUND_PERSONAL' ||
      prodType.toUpperCase().contains('PERSONAL');

  factory FundingOrderRow.fromMap(Map<String, dynamic> map) {
    final detailsRaw = map['details'];
    final details = detailsRaw is Map
        ? FundingOrderDetails.fromMap(Map<String, dynamic>.from(detailsRaw))
        : const FundingOrderDetails();
    return FundingOrderRow(
      serviceId: _text(map['serviceId']),
      custId: _text(map['custId']),
      custName: _text(map['custName']),
      requiredValue: _text(map['requiredValue']),
      loanTypeName: _pickName(map, 'loanTypeNameAr', 'loanTypeNameEn'),
      branchName: _pickName(map, 'createdBrNameAr', 'createdBrNameEn'),
      statusLabel: _pickName(map, 'previousStatusNameAr', 'previousStatusNameEn'),
      statusCode: details.previousStatus.isNotEmpty
          ? details.previousStatus
          : _text(map['previousStatus']),
      createdDate: _text(map['createdDate']).isEmpty
          ? details.createdDate
          : _text(map['createdDate']),
      ticketId: _text(map['ticketId']),
      prodType: _text(map['prodType']),
      wfCode: _text(map['wfCode']),
      details: details,
    );
  }
}

class FundingOrderDetails {
  const FundingOrderDetails({
    this.currentStepId = '',
    this.currentStageId = '',
    this.previousStatus = '',
    this.createdDate = '',
    this.createdUsrName = '',
    this.previousUsrName = '',
    this.previousRoleName = '',
    this.previousComment = '',
  });

  final String currentStepId;
  final String currentStageId;
  final String previousStatus;
  final String createdDate;
  final String createdUsrName;
  final String previousUsrName;
  final String previousRoleName;
  final String previousComment;

  factory FundingOrderDetails.fromMap(Map<String, dynamic> map) {
    return FundingOrderDetails(
      currentStepId: _text(map['currentStepId']),
      currentStageId: _text(map['currentStageId']),
      previousStatus: _text(map['previousStatus']),
      createdDate: _text(map['createdDate']),
      createdUsrName: _pickName(map, 'createdUsrNameAr', 'createdUsrNameEn'),
      previousUsrName: _pickName(map, 'previousUsrNameAr', 'previousUsrNameEn'),
      previousRoleName: _pickName(map, 'previousRoleNameAr', 'previousRoleNameEn'),
      previousComment: _text(map['previousComment']),
    );
  }
}

String _text(dynamic value) => value == null ? '' : '$value'.trim();

String _pickName(Map<String, dynamic> map, String ar, String en) {
  final arabic = _text(map[ar]);
  if (arabic.isNotEmpty) return arabic;
  return _text(map[en]);
}
