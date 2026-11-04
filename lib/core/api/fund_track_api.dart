import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fmc_client.dart';
import 'package:loanofficer/core/api/fmc_session.dart';
import 'package:loanofficer/core/components/app_loading.dart';
import 'package:loanofficer/core/models/inquiry_search_filters.dart';

/// Fusion `funding-requests/fund-track` (`query/service/findWfServices`, …).
class FundTrackApi {
  FundTrackApi({FmcClient? client, FmcSession? session})
    : _client = client ?? FmcClient(),
      _session = session ?? FmcSession.instance;

  final FmcClient _client;
  final FmcSession _session;

  Future<List<FundTrackRow>> findWorkflowServices({
    String? custIdno,
    String? serviceId,
  }) {
    return _findServiceRows(
      path: 'query/service/findWfServices',
      custIdno: custIdno,
      serviceId: serviceId,
    );
  }

  /// Fusion «استعلام تمويل فردي» (`query/service/findService` — same as FMC web «بحث»).
  Future<List<FundTrackRow>> findServices({
    String? custIdno,
    String? serviceId,
  }) async {
    final page = await findInquiryServices(
      custIdno: custIdno,
      serviceId: serviceId,
    );
    return page.rows;
  }

  /// Web `ServiceQueryService.geteAllServiceQuery` — full result list, no pagination fields.
  Future<FundTrackFindPage> findInquiryServices({
    String? custIdno,
    String? serviceId,
    String? grantIdno1,
    InquirySearchFilters? filters,
  }) {
    return AppLoading.watch(() async {
      if (!_session.isSignedIn) {
        throw AuthApiException('بيانات الدخول غير صحيحة');
      }
      final body = await _inquirySearchBody(
        custIdno: custIdno,
        serviceId: serviceId,
        grantIdno1: grantIdno1,
        filters: filters,
      );
      final result = await _client.post('query/service/findService', body);
      final rows = _rows(result);
      return FundTrackFindPage(rows: rows, totalRecords: rows.length);
    });
  }

  Future<List<FundTrackRow>> _findServiceRows({
    required String path,
    String? custIdno,
    String? serviceId,
  }) {
    return AppLoading.watch(() async {
      if (!_session.isSignedIn) {
        throw AuthApiException('بيانات الدخول غير صحيحة');
      }
      final body = await _inquirySearchBody(
        custIdno: custIdno,
        serviceId: serviceId,
      );
      final result = await _client.post(path, body);
      return _rows(result);
    });
  }

  /// POST body for `findService` — matches web `getAllServiceQuery` (PrimeNG paginates locally).
  Future<Map<String, dynamic>> _inquirySearchBody({
    String? custIdno,
    String? serviceId,
    String? grantIdno1,
    InquirySearchFilters? filters,
  }) async {
    final login = await _session.readLogin();
    final hq = _int(login?['hq']);
    final brNum = _int(login?['brCode']);
    final body = <String, dynamic>{...?filters?.toApiMap()};

    // Web `getAllServiceQuery`: branch users always search their branch.
    if (hq != brNum && brNum != 0) {
      body['brcode'] = brNum;
    }

    final cust = _orNull(custIdno);
    if (cust != null) body['custIdno'] = cust;
    final svc = _orNull(serviceId);
    if (svc != null) body['serviceId'] = svc;
    final grant = _orNull(grantIdno1);
    if (grant != null) body['grantIdno1'] = grant;
    return body;
  }

  Future<FundTrackServiceDetail> serviceWorkflowReviews(String serviceId) {
    return AppLoading.watch(() async {
      final result = await _client.get(
        'query/service/wfReviews',
        query: {'serviceId': serviceId.trim()},
      );
      return FundTrackServiceDetail.fromMap(_map(result));
    });
  }

  Future<void> moveToStep(Map<String, dynamic> body) {
    return _post('wf/action/delegate', body);
  }

  Future<void> resetTicket({required String ticketId}) {
    return _post('wf/action/resetTicket', {'ticketId': ticketId});
  }

  Future<void> cancelWorkflowRequest({
    required String serviceId,
    String? comment,
  }) {
    return _post('service/cancelWfRequest', {
      'serviceId': serviceId,
      'comment': comment,
    });
  }

  Future<void> unfreezeRequest(Map<String, dynamic> body) {
    return _post('wf/action/unFreezed', body);
  }

  Future<void> changeLoanOfficer({
    required String ticketId,
    required String newUsrNo,
  }) {
    return _post('wf/action/changeTicketUser', {
      'ticketId': ticketId,
      'newUsrNo': newUsrNo,
    });
  }

  Future<TicketReviewerInfo> ticketReviewer(String ticketId) {
    return AppLoading.watch(() async {
      final result = await _client.get(
        'wf/action/changeTicketReviewer',
        query: {'ticketId': ticketId},
      );
      return TicketReviewerInfo.fromMap(_map(result));
    });
  }

  Future<void> changeTicketReviewer({
    required String ticketId,
    required String newUsrNo,
  }) {
    return _post('wf/action/changeTicketReviewer', {
      'ticketId': ticketId,
      'newUsrNo': newUsrNo,
    });
  }

  Future<List<TicketUser>> usersForTicket(String ticketId) {
    return AppLoading.watch(() async {
      final result = await _client.get(
        'wf/action/usersForticket',
        query: {'ticketId': ticketId},
      );
      return _ticketUsers(result);
    });
  }

  Future<void> changeWorkflowUser({
    required String ticketId,
    required String fromUsrNo,
    required String toUsrNo,
  }) {
    return _post('wf/action/changeUserReviewer', {
      'ticketId': ticketId,
      'fromUsrNo': fromUsrNo,
      'toUsrNo': toUsrNo,
    });
  }

  Future<List<BranchUser>> loanOfficersByBranch(int brcode) {
    return AppLoading.watch(() async {
      final result = await _client.get(
        'adminController/users/getAllUserByBranchCodeAndJopCode',
        query: {'brcode': '$brcode', 'jobCode': '0'},
      );
      return _branchUsers(result);
    });
  }

  Future<List<BranchUser>> usersByBranch(int brcode) {
    return AppLoading.watch(() async {
      final result = await _client.get(
        'adminController/users/getAllUserByBranchCode',
        query: {'brcode': '$brcode'},
      );
      return _branchUsers(result);
    });
  }

  Future<void> _post(String path, Map<String, dynamic> body) {
    return AppLoading.blocking(() => _client.post(path, body));
  }

  static List<FundTrackRow> _rows(dynamic result) {
    final rows = <FundTrackRow>[];
    for (final item in _list(result)) {
      if (item is! Map) continue;
      rows.add(FundTrackRow.fromMap(Map<String, dynamic>.from(item)));
    }
    return rows;
  }

  static List<dynamic> _list(dynamic result) {
    if (result is List) return result;
    if (result is Map) {
      for (final key in const ['data', 'content', 'result']) {
        final value = result[key];
        if (value is List) return value;
      }
    }
    return const [];
  }

  static List<TicketUser> _ticketUsers(dynamic result) {
    if (result is! List) return const [];
    final users = <TicketUser>[];
    for (final item in result) {
      if (item is! Map) continue;
      users.add(TicketUser.fromMap(Map<String, dynamic>.from(item)));
    }
    return users;
  }

  static List<BranchUser> _branchUsers(dynamic result) {
    if (result is! List) return const [];
    final users = <BranchUser>[];
    for (final item in result) {
      if (item is! Map) continue;
      users.add(BranchUser.fromMap(Map<String, dynamic>.from(item)));
    }
    return users;
  }

  static Map<String, dynamic> _map(dynamic result) {
    if (result is Map) return Map<String, dynamic>.from(result);
    return const {};
  }

  static String? _orNull(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? null : text;
  }
}

class FundTrackFindPage {
  const FundTrackFindPage({
    required this.rows,
    required this.totalRecords,
  });

  final List<FundTrackRow> rows;
  final int totalRecords;
}

class FundTrackRow {
  const FundTrackRow({
    required this.serviceId,
    required this.custId,
    required this.custName,
    required this.loanTypeName,
    required this.branchName,
    required this.loCodeName,
    required this.ticketId,
    required this.brcode,
    required this.prodType,
    this.financeCode = '',
    this.issueDate = '',
    this.currentBalance = '',
    this.dueBalance = '',
    this.financeStatus = '',
    this.status = 0,
    this.custno = '',
    this.orgId = '',
    this.raw = const {},
  });

  final String serviceId;
  final String custId;
  final String custName;
  final String loanTypeName;
  final String branchName;
  final String loCodeName;
  final String ticketId;
  final int brcode;
  final String prodType;
  final String financeCode;
  final String issueDate;
  final String currentBalance;
  final String dueBalance;
  final String financeStatus;
  /// Fusion service status code — drives inquiry API paths (premiums, penalty, grantors).
  final int status;
  final String custno;
  final String orgId;
  /// Full `findService` row as returned by Fusion (used for «بيانات التمويل» read-only view).
  final Map<String, dynamic> raw;

  factory FundTrackRow.fromMap(Map<String, dynamic> map) {
    final copy = Map<String, dynamic>.from(map);
    return FundTrackRow(
      serviceId: _text(map['serviceId']),
      custId: _text(map['custId'] ?? map['custIdno'] ?? map['idno']),
      custName: _text(map['custName']),
      loanTypeName: _firstLabel(
        map,
        [
          'loanName',
          'loanNameAr',
          'loanNameEn',
          'prodName',
          'prodNameAr',
          'prodNameEn',
          'loanTypeNameAr',
          'loanTypeNameEn',
        ],
      ),
      branchName: _firstLabel(
        map,
        ['createdBrNameAr', 'createdBrNameEn', 'brNameAr', 'brNameEn'],
      ),
      loCodeName: _text(map['loCodeName']),
      ticketId: _text(map['ticketId']),
      brcode: _int(map['brcode']),
      prodType: _text(map['prodType']),
      financeCode: _text(
        map['serviceId'] ??
            map['kstCode'] ??
            map['loanCode'] ??
            map['financeCode'],
      ),
      issueDate: _text(map['issueDate'] ?? map['createdDate'] ?? map['openDate']),
      currentBalance: _text(
        map['balValue'] ??
            map['currentBalance'] ??
            map['outstandingBalance'] ??
            map['principalAmt'],
      ),
      dueBalance: _text(
        map['debtDues'] ?? map['dueBalance'] ?? map['dueAmt'] ?? map['dueAmount'],
      ),
      financeStatus: _firstLabel(
        map,
        [
          'srvStatusName',
          'statusNameAr',
          'loanStatusNameAr',
          'statusNameEn',
          'loanStatusNameEn',
        ],
      ),
      status: _int(map['status'] ?? map['srvStatus'] ?? map['loanStatus']),
      custno: _text(map['custno'] ?? map['custNo']),
      orgId: _text(map['orgId']),
      raw: copy,
    );
  }
}

class FundTrackServiceDetail {
  const FundTrackServiceDetail({
    required this.custName,
    required this.wfNameAr,
    required this.currentStageNameAr,
    required this.ticketId,
    required this.prodType,
    required this.wfSteps,
    required this.wfReviews,
  });

  final String custName;
  final String wfNameAr;
  final String currentStageNameAr;
  final String ticketId;
  final String prodType;
  final List<WfStep> wfSteps;
  final List<WfReview> wfReviews;

  factory FundTrackServiceDetail.fromMap(Map<String, dynamic> map) {
    return FundTrackServiceDetail(
      custName: _text(map['custName']),
      wfNameAr: _text(map['wfNameAr']),
      currentStageNameAr: _text(map['currentStageNameAr']),
      ticketId: _text(map['ticketId']),
      prodType: _text(map['prodType']),
      wfSteps: _steps(map['wfSteps']),
      wfReviews: _reviews(map['wfReviews']),
    );
  }
}

class WfStep {
  const WfStep({required this.stageId, required this.stageNameAr});

  final String stageId;
  final String stageNameAr;

  factory WfStep.fromMap(Map<String, dynamic> map) {
    return WfStep(
      stageId: _text(map['stageId']),
      stageNameAr: _pickName(map, 'stageNameAr', 'stageNameEn'),
    );
  }
}

class WfReview {
  const WfReview({
    required this.nameAr,
    required this.actionNameAr,
    required this.userNameAr,
    required this.roleNameAr,
    required this.userNo,
    required this.comments,
    required this.startDate,
    required this.finishDate,
    required this.action,
  });

  final String nameAr;
  final String actionNameAr;
  final String userNameAr;
  final String roleNameAr;
  final String userNo;
  final String comments;
  final String startDate;
  final String finishDate;
  final bool action;

  String get assigneeLine {
    final parts = <String>[
      if (userNo.isNotEmpty) userNo,
      if (userNameAr.isNotEmpty) userNameAr,
      if (roleNameAr.isNotEmpty) roleNameAr,
    ];
    return parts.join(' - ');
  }

  factory WfReview.fromMap(Map<String, dynamic> map) {
    return WfReview(
      nameAr: _pickName(map, 'nameAr', 'nameEn'),
      actionNameAr: _pickName(map, 'actionNameAr', 'actionNameEn'),
      userNameAr: _pickName(map, 'userNameAr', 'userNameEn'),
      roleNameAr: _pickName(map, 'roleNameAr', 'roleNameEn'),
      userNo: _text(map['userNo'] ?? map['usrNo'] ?? map['usrno']),
      comments: _text(map['comments']),
      startDate: _text(map['startDate']),
      finishDate: _text(map['finishDate']),
      action: map['action'] == true || '${map['action']}' == 'true',
    );
  }
}

class TicketReviewerInfo {
  const TicketReviewerInfo({
    required this.currentUsrnoName,
    required this.currentStageDescr,
    required this.currentRoleDescr,
    required this.users,
  });

  final String currentUsrnoName;
  final String currentStageDescr;
  final String currentRoleDescr;
  final List<BranchUser> users;

  factory TicketReviewerInfo.fromMap(Map<String, dynamic> map) {
    final list = map['usersList'];
    final users = <BranchUser>[];
    if (list is List) {
      for (final item in list) {
        if (item is Map) {
          users.add(BranchUser.fromMap(Map<String, dynamic>.from(item)));
        }
      }
    }
    return TicketReviewerInfo(
      currentUsrnoName: _text(map['currentUsrnoName']),
      currentStageDescr: _text(map['currentStageDescr']),
      currentRoleDescr: _text(map['currentRoleDescr']),
      users: users,
    );
  }
}

class TicketUser {
  const TicketUser({required this.usrno, required this.brcode, required this.label});

  final String usrno;
  final int brcode;
  final String label;

  factory TicketUser.fromMap(Map<String, dynamic> map) {
    return TicketUser(
      usrno: _text(map['usrno']),
      brcode: _int(map['brcode']),
      label: _pickName(map, 'userNameAr', 'userNameEn'),
    );
  }
}

class BranchUser {
  const BranchUser({required this.usrno, required this.label});

  final String usrno;
  final String label;

  factory BranchUser.fromMap(Map<String, dynamic> map) {
    return BranchUser(
      usrno: _text(map['usrno']),
      label: _pickName(map, 'userNameAr', 'userNameEn', 'nameAr', 'nameEn'),
    );
  }
}

List<WfStep> _steps(dynamic raw) {
  if (raw is! List) return const [];
  return [
    for (final item in raw)
      if (item is Map) WfStep.fromMap(Map<String, dynamic>.from(item)),
  ];
}

List<WfReview> _reviews(dynamic raw) {
  if (raw is! List) return const [];
  return [
    for (final item in raw)
      if (item is Map) WfReview.fromMap(Map<String, dynamic>.from(item)),
  ];
}

String _text(dynamic value) => value == null ? '' : '$value'.trim();

int _int(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse('$value') ?? 0;
}

String _firstLabel(Map<String, dynamic> map, List<String> keys) {
  for (final key in keys) {
    final value = _text(map[key]);
    if (value.isNotEmpty) return value;
  }
  return '';
}

String _pickName(Map<String, dynamic> map, String ar, String en, [String? altAr, String? altEn]) {
  final arabic = _text(map[ar]);
  if (arabic.isNotEmpty) return arabic;
  if (altAr != null) {
    final alt = _text(map[altAr]);
    if (alt.isNotEmpty) return alt;
  }
  final english = _text(map[en]);
  if (english.isNotEmpty) return english;
  if (altEn != null) return _text(map[altEn]);
  return '';
}
