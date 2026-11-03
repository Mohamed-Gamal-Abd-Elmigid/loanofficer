import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fund_track_api.dart';
import 'package:loanofficer/core/api/service_query_api.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';

/// FMC `GET query/customer?idno=` — same model as `CustomerInfoComponent` on web.
class InquiryCustomerProfileScene extends StatefulWidget {
  const InquiryCustomerProfileScene({super.key, required this.row});

  final FundTrackRow row;

  static void open(BuildContext context, FundTrackRow row) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => InquiryCustomerProfileScene(row: row),
      ),
    );
  }

  @override
  State<InquiryCustomerProfileScene> createState() =>
      _InquiryCustomerProfileSceneState();
}

class _InquiryCustomerProfileSceneState
    extends State<InquiryCustomerProfileScene> {
  @override
  Widget build(BuildContext context) {
    return InquiryCustomerQueryView(
      idno: widget.row.custId,
      displayName: widget.row.custName,
      pageTitle: 'بيانات العميل',
    );
  }
}

class InquiryCustomerQueryView extends StatefulWidget {
  const InquiryCustomerQueryView({
    super.key,
    required this.idno,
    required this.pageTitle,
    this.displayName,
  });

  final String idno;
  final String pageTitle;
  final String? displayName;

  @override
  State<InquiryCustomerQueryView> createState() =>
      _InquiryCustomerQueryViewState();
}

class _InquiryCustomerQueryViewState extends State<InquiryCustomerQueryView> {
  final _api = ServiceQueryApi();
  InquiryCustomerQuerySections? _sections;
  String? _error;
  bool _loading = true;
  int _tabIndex = 0;

  static const _tabLabels = [
    'بيانات أساسية',
    'بيانات الائتمان',
    'الحالة الائتمانية',
    'جهة العمل',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final raw = await _api.customerQuery(widget.idno);
      if (!mounted) return;
      setState(() {
        _sections = InquiryCustomerQuerySections.parse(raw);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = apiErrorMessage(e);
        _loading = false;
      });
    }
  }

  String get _resolvedName {
    final fromArg = widget.displayName?.trim();
    if (fromArg != null && fromArg.isNotEmpty) return fromArg;
    final fromApi = _sections?.displayName;
    if (fromApi != null && fromApi.isNotEmpty && fromApi != '—') return fromApi;
    return '—';
  }

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      pageTitle: widget.pageTitle,
      pageIcon: Icons.person_outline,
      onBack: () => Navigator.of(context).pop(),
      body: ColoredBox(
        color: AppColors.page,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFonts.dinNextArabic,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        FlowActionButton(
                          label: 'إعادة المحاولة',
                          enabled: true,
                          onPressed: _load,
                        ),
                      ],
                    ),
                  ),
                )
              : _sections == null
              ? const SizedBox.shrink()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                      child: _ProfileSummaryCard(
                        name: _resolvedName,
                        idno: widget.idno,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    _ProfileSegmentBar(
                      labels: _tabLabels,
                      index: _tabIndex,
                      onChanged: (i) => setState(() => _tabIndex = i),
                    ),
                    SizedBox(height: 8.h),
                    Expanded(
                      child: _CustomerTabSectionsView(
                        key: ValueKey(_tabIndex),
                        sections: _sections!.panelsForTab(_tabIndex),
                        collapsible: _tabIndex == 0,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class InquiryCustomerQuerySections {
  InquiryCustomerQuerySections({
    required this.customerInformation,
    required this.idAddressInformation,
    required this.addressInformation,
    required this.contactInformation,
    required this.creditInformation,
    required this.grantCreditInformation,
    required this.iScoreInformation,
    required this.creditStatusInformation,
    required this.guaranteesInformation,
    required this.workplaceInformation,
  });

  final Map<String, dynamic> customerInformation;
  final Map<String, dynamic> idAddressInformation;
  final Map<String, dynamic> addressInformation;
  final Map<String, dynamic> contactInformation;
  final Map<String, dynamic> creditInformation;
  final Map<String, dynamic> grantCreditInformation;
  final Map<String, dynamic> iScoreInformation;
  final Map<String, dynamic> creditStatusInformation;
  final Map<String, dynamic> guaranteesInformation;
  final Map<String, dynamic> workplaceInformation;

  String get displayName =>
      const InquiryFieldSpec('الاسم بالعربية', ['fullname']).read(
        customerInformation,
      );

  List<InquiryCustomerPanel> panelsForTab(int tabIndex) {
    return switch (tabIndex) {
      0 => [
        InquiryCustomerPanel(
          'بيانات أساسية',
          customerInformationSpecs,
          customerInformation,
        ),
        InquiryCustomerPanel(
          'عنوان البطاقة',
          idAddressInformationSpecs,
          idAddressInformation,
        ),
        InquiryCustomerPanel(
          'عنوان الإقامة',
          addressInformationSpecs,
          addressInformation,
        ),
        InquiryCustomerPanel(
          'بيانات التواصل',
          contactInformationSpecs,
          contactInformation,
        ),
      ],
      1 => [
        InquiryCustomerPanel(
          'بيانات التمويل',
          creditInformationSpecs,
          creditInformation,
        ),
        InquiryCustomerPanel(
          'بيانات التمويل كضامن',
          grantCreditInformationSpecs,
          grantCreditInformation,
        ),
        InquiryCustomerPanel(
          'بيانات أي سكور',
          iScoreInformationSpecs,
          iScoreInformation,
        ),
      ],
      2 => [
        InquiryCustomerPanel(
          'الحالة الإئتمانية',
          creditStatusInformationSpecs,
          creditStatusInformation,
        ),
        InquiryCustomerPanel(
          'الضمانات العينية',
          guaranteesInformationSpecs,
          guaranteesInformation,
        ),
      ],
      3 => [
        InquiryCustomerPanel(
          'جهة العمل',
          workplaceInformationSpecs,
          workplaceInformation,
        ),
      ],
      _ => const [],
    };
  }

  static InquiryCustomerQuerySections empty() => InquiryCustomerQuerySections(
    customerInformation: const {},
    idAddressInformation: const {},
    addressInformation: const {},
    contactInformation: const {},
    creditInformation: const {},
    grantCreditInformation: const {},
    iScoreInformation: const {},
    creditStatusInformation: const {},
    guaranteesInformation: const {},
    workplaceInformation: const {},
  );

  static InquiryCustomerQuerySections parse(dynamic result) {
    final row = _firstRow(result);
    if (row == null) return empty();
    return InquiryCustomerQuerySections(
      customerInformation: _pick(row, _customerInformationKeys),
      idAddressInformation: _pick(row, _idAddressKeys),
      addressInformation: _pick(row, _addressKeys),
      contactInformation: _pick(row, _contactKeys),
      creditInformation: _pick(row, _creditKeys),
      grantCreditInformation: _pick(row, _grantCreditKeys),
      iScoreInformation: _pick(row, _iScoreKeys),
      creditStatusInformation: _pick(row, _creditStatusKeys),
      guaranteesInformation: _pick(row, _guaranteesKeys),
      workplaceInformation: _pick(row, _workplaceKeys),
    );
  }

  static Map<String, dynamic> _pick(
    Map<String, dynamic> row,
    List<String> keys,
  ) {
    final out = <String, dynamic>{};
    for (final key in keys) {
      if (row.containsKey(key) && row[key] != null) {
        out[key] = row[key];
      }
    }
    return out;
  }

  static Map<String, dynamic>? _firstRow(dynamic result) {
    if (result is List) {
      if (result.isEmpty) return null;
      final first = result.first;
      if (first is Map) return Map<String, dynamic>.from(first);
      return null;
    }
    if (result is Map) {
      final map = Map<String, dynamic>.from(result);
      final nested = map['result'];
      if (nested is List) return _firstRow(nested);
      if (nested is Map) return Map<String, dynamic>.from(nested);
      if (map['content'] is List) return _firstRow(map['content']);
      if (map['data'] is List) return _firstRow(map['data']);
      return map;
    }
    return null;
  }

  static const _customerInformationKeys = [
    'lastUpdateDate',
    'custno',
    'fullname',
    'nickname',
    'idNumber',
    'idIssueDate',
    'idExpDate',
    'birthdate',
    'custAge',
    'genderDescr',
    'lifeStatusDescr',
    'qualification',
    'healthDescr',
    'socialDescr',
    'noOfChildren',
    'religionDescr',
    'nationDescr',
    'carLicenseDescr',
    'clubCardDescr',
  ];

  static const _idAddressKeys = [
    'idCountryName',
    'idStateName',
    'idCityName',
    'idVillageName',
    'idStreet',
    'idBuildingNo',
    'idFloorNo',
    'idFlatNo',
    'idAdd',
  ];

  static const _addressKeys = [
    'homeCountryName',
    'homeStateName',
    'homeCityName',
    'homeVillageName',
    'homeStreet',
    'homeBuildingNo',
    'homeFloorNo',
    'homeFlatNo',
    'homeMark',
    'homeAdd',
  ];

  static const _contactKeys = ['phoneNo1', 'phoneNo2', 'eMail'];

  static const _creditKeys = [
    'noOfSrvActive',
    'totalSrvAmounts',
    'totalSrvDues',
    'noOfKstLate',
    'noOfDaysLate',
    'highestNoOfDaysLate',
    'noOfSrvClosed',
    'noOfSrvClosedEarly',
    'noOfSrvRejected',
    'lastRejectedReason',
    'noOfSrvWriteoff',
    'firstServiceClosedPeriod',
  ];

  static const _grantCreditKeys = [
    'noOfSrvActiveAsGrant',
    'totalSrvAmountsAsGrant',
    'totalSrvDuesAsGrant',
    'noOfSrvClosedAsGrant',
    'noOfSrvClosedEarlyAsGrant',
    'noOfSrvRejectedAsGrant',
    'riskRateAsGrant',
    'noOfKstLateAsGrant',
    'noOfDaysLateAsGrant',
    'noOfSrvWriteoffAsGrant',
  ];

  static const _iScoreKeys = [
    'iscoreLastScoring',
    'iscoreOpenAccCnt',
    'iscoreOpenAccOutstading',
    'iscoreOpenAccUnearnedInt',
    'iscoreOpenAccKstAmt',
    'iscoreOpenAccNoofksts',
    'iscoreClosedAccountsCnt',
    'iscoreLeagalAccountsCnt',
    'iscoreNegativeListCnt',
    'iscoreMaxNdpd',
    'iscoreOpenAccOverdueamt',
    'iscoreWrittenoffCnt',
  ];

  static const _creditStatusKeys = [
    'blacklistStatusDescr',
    'blackListDate',
    'legalStautsDescr',
    'riskRate',
    'totalCreditAmt',
    'usedCreditAmt',
  ];

  static const _guaranteesKeys = [
    'grantsTotalAmt',
    'grantsFinalAmt',
    'grantsNoSrvRelated',
    'grantsSrvRelatedAmt',
    'grantsEndDate',
  ];

  static const _workplaceKeys = [
    'code1Name',
    'code2Name',
    'code3Name',
    'workCompanyName',
    'workPlace',
    'cifWorkMonthSalary',
    'cifWorkOthrRev',
    'cifWorkPayments',
    'cifWorkNetIncome',
  ];

  static const customerInformationSpecs = [
    InquiryFieldSpec('تاريخ تحديث البيانات', ['lastUpdateDate']),
    InquiryFieldSpec('رقم العميل', ['custno']),
    InquiryFieldSpec('الاسم بالعربية', ['fullname']),
    InquiryFieldSpec('اسم الشهرة', ['nickname']),
    InquiryFieldSpec('رقم بطاقة العميل', ['idNumber']),
    InquiryFieldSpec('تاريخ اصدار البطاقة', ['idIssueDate']),
    InquiryFieldSpec('تاريخ انتهاء البطاقة', ['idExpDate']),
    InquiryFieldSpec('تاريخ الميلاد', ['birthdate']),
    InquiryFieldSpec('عمر العميل', ['custAge']),
    InquiryFieldSpec('ذكر / انثى', ['genderDescr']),
    InquiryFieldSpec('حالة العميل (قائم / متوفي)', ['lifeStatusDescr']),
    InquiryFieldSpec('المؤهل الدراسى', ['qualification']),
    InquiryFieldSpec('الحالة الصحية', ['healthDescr']),
    InquiryFieldSpec('الحالة الإجتماعية', ['socialDescr']),
    InquiryFieldSpec('عدد الاطفال', ['noOfChildren']),
    InquiryFieldSpec('الديانة', ['religionDescr']),
    InquiryFieldSpec('الجنسية', ['nationDescr']),
    InquiryFieldSpec('رقم رخصة القيادة ونوعها', ['carLicenseDescr']),
    InquiryFieldSpec('اسم النادي', ['clubCardDescr']),
  ];

  static const idAddressInformationSpecs = [
    InquiryFieldSpec('البلد - البطاقة', ['idCountryName']),
    InquiryFieldSpec('المحافظة - البطاقة', ['idStateName']),
    InquiryFieldSpec('المدينة - البطاقة', ['idCityName']),
    InquiryFieldSpec('المركز - البطاقة', ['idVillageName']),
    InquiryFieldSpec('الشارع - البطاقة', ['idStreet']),
    InquiryFieldSpec('رقم المبنى - البطاقة', ['idBuildingNo']),
    InquiryFieldSpec('رقم الدور - البطاقة', ['idFloorNo']),
    InquiryFieldSpec('شقة - البطاقة', ['idFlatNo']),
    InquiryFieldSpec('عنوان البطاقة', ['idAdd']),
  ];

  static const addressInformationSpecs = [
    InquiryFieldSpec('البد - المنزل', ['homeCountryName']),
    InquiryFieldSpec('المحافظة- المنزل', ['homeStateName']),
    InquiryFieldSpec('المدينة - المنزل', ['homeCityName']),
    InquiryFieldSpec('المركز- المنزل', ['homeVillageName']),
    InquiryFieldSpec('الشارع - المنزل', ['homeStreet']),
    InquiryFieldSpec('رقم المبنى - المنزل', ['homeBuildingNo']),
    InquiryFieldSpec('رقم الدور - المنزل', ['homeFloorNo']),
    InquiryFieldSpec('شقة - المنزل', ['homeFlatNo']),
    InquiryFieldSpec('علامة مميزة- المنزل', ['homeMark']),
    InquiryFieldSpec('عنوان المنزل الفعلى', ['homeAdd']),
  ];

  static const contactInformationSpecs = [
    InquiryFieldSpec('تليفون 1', ['phoneNo1']),
    InquiryFieldSpec('تليفون 2', ['phoneNo2']),
    InquiryFieldSpec('بريد اللكترونى', ['eMail']),
  ];

  static const creditInformationSpecs = [
    InquiryFieldSpec('عدد التمويل القائمة', ['noOfSrvActive']),
    InquiryFieldSpec('إجمالى الرصيد القائمة', ['totalSrvAmounts']),
    InquiryFieldSpec('إجمالى المستحقات', ['totalSrvDues']),
    InquiryFieldSpec('عدد الاقساط المتأخرة', ['noOfKstLate']),
    InquiryFieldSpec('عدد أيام التأخير عن السداد حاليا', ['noOfDaysLate']),
    InquiryFieldSpec('اقصي عدد ايام تأخير للعميل', ['highestNoOfDaysLate']),
    InquiryFieldSpec('عدد التمويل منتهي سداد عادي', ['noOfSrvClosed']),
    InquiryFieldSpec('عدد التمويل منتهي سداد معجل', ['noOfSrvClosedEarly']),
    InquiryFieldSpec('عدد الطلبات المرفوضة', ['noOfSrvRejected']),
    InquiryFieldSpec('سبب رفض اخر طلب', ['lastRejectedReason']),
    InquiryFieldSpec('عدد التمويل المعدوم', ['noOfSrvWriteoff']),
    InquiryFieldSpec('عدد الاشهر على اغلاق اول قرض', [
      'firstServiceClosedPeriod',
    ]),
  ];

  static const grantCreditInformationSpecs = [
    InquiryFieldSpec('عدد التمويل', ['noOfSrvActiveAsGrant']),
    InquiryFieldSpec('قيمة التمويل', ['totalSrvAmountsAsGrant']),
    InquiryFieldSpec('قيمة المتأخرات للتمويل', ['totalSrvDuesAsGrant']),
    InquiryFieldSpec('عدد التمويل المغلق سداد عادي', ['noOfSrvClosedAsGrant']),
    InquiryFieldSpec('عدد التمويل سداد مبكر', ['noOfSrvClosedEarlyAsGrant']),
    InquiryFieldSpec('عدد الطلبات المفروضة', ['noOfSrvRejectedAsGrant']),
    InquiryFieldSpec('اعلي نسبة مخاطر سداد للتمويل', ['riskRateAsGrant']),
    InquiryFieldSpec('عدد الاقساط المتأخرة', ['noOfKstLateAsGrant']),
    InquiryFieldSpec('عدد ايام التأخير', ['noOfDaysLateAsGrant']),
    InquiryFieldSpec('عدد التمويل المعدومة', ['noOfSrvWriteoffAsGrant']),
  ];

  static const iScoreInformationSpecs = [
    InquiryFieldSpec('اخر تقييم للعميل', ['iscoreLastScoring']),
    InquiryFieldSpec('عدد التسهيلات القائمة', ['iscoreOpenAccCnt']),
    InquiryFieldSpec('الرصيد القائم للتسهيلات القائمة', [
      'iscoreOpenAccOutstading',
    ]),
    InquiryFieldSpec('الفوائد الغير مستحقة للتسهيلات القائمة', [
      'iscoreOpenAccUnearnedInt',
    ]),
    InquiryFieldSpec('الفوائد الشهرية للتسهيلات القائمة', [
      'iscoreOpenAccKstAmt',
    ]),
    InquiryFieldSpec('عدد الاقساط المتبقية للتسهيلات القائمة', [
      'iscoreOpenAccNoofksts',
    ]),
    InquiryFieldSpec('عدد التسهيلات المغلقة', ['iscoreClosedAccountsCnt']),
    InquiryFieldSpec('عدد التسهيلات محالة للقضاء', ['iscoreLeagalAccountsCnt']),
    InquiryFieldSpec('تواجد العميل بالقوائم السلبية', [
      'iscoreNegativeListCnt',
    ]),
    InquiryFieldSpec('اقصي عدد ايام تأخير', ['iscoreMaxNdpd']),
    InquiryFieldSpec('الرصيد المستحق للتسهيلات القائمة', [
      'iscoreOpenAccOverdueamt',
    ]),
    InquiryFieldSpec('عدد التسهيلات المعدومة', ['iscoreWrittenoffCnt']),
  ];

  static const creditStatusInformationSpecs = [
    InquiryFieldSpec('الحالة من قائمة الحظر', ['blacklistStatusDescr']),
    InquiryFieldSpec('تاريخ حظر العميل', ['blackListDate']),
    InquiryFieldSpec('وصف الحالة القانونية', ['legalStautsDescr']),
    InquiryFieldSpec('نسبة مخاطر سداد للعميل', ['riskRate']),
    InquiryFieldSpec('إجمالي الحد الإئتماني المسمح به', ['totalCreditAmt']),
    InquiryFieldSpec('المستخدم من الحد الائتماني', ['usedCreditAmt']),
  ];

  static const guaranteesInformationSpecs = [
    InquiryFieldSpec('إجمالى الضمانات المقدمة', ['grantsTotalAmt']),
    InquiryFieldSpec('القيمة النهائية للضمانات', ['grantsFinalAmt']),
    InquiryFieldSpec('عدد التمويل المرتبطة بالضمانات', ['grantsNoSrvRelated']),
    InquiryFieldSpec('قيمة التمويل المرتبطة بالضمانات', [
      'grantsSrvRelatedAmt',
    ]),
    InquiryFieldSpec('تاريخ نهاية الضمانة', ['grantsEndDate']),
  ];

  static const workplaceInformationSpecs = [
    InquiryFieldSpec('القطاع الاقتصادي', ['code1Name']),
    InquiryFieldSpec('القطاع الاقتصادي التحليلي', ['code2Name']),
    InquiryFieldSpec('القطاع الاقتصادي الفرعي', ['code3Name']),
    InquiryFieldSpec('اسم جهه العمل', ['workCompanyName']),
    InquiryFieldSpec('مكان جهه العمل', ['workPlace']),
    InquiryFieldSpec('الراتب الشهرى', ['cifWorkMonthSalary']),
    InquiryFieldSpec('ايرادات اخرى', ['cifWorkOthrRev']),
    InquiryFieldSpec('مصاريف', ['cifWorkPayments']),
    InquiryFieldSpec('صافى الدخل', ['cifWorkNetIncome']),
  ];
}

class InquiryCustomerPanel {
  const InquiryCustomerPanel(this.title, this.specs, this.data);

  final String title;
  final List<InquiryFieldSpec> specs;
  final Map<String, dynamic> data;
}

class _CustomerTabSectionsView extends StatefulWidget {
  const _CustomerTabSectionsView({
    super.key,
    required this.sections,
    this.collapsible = false,
  });

  final List<InquiryCustomerPanel> sections;
  final bool collapsible;

  @override
  State<_CustomerTabSectionsView> createState() =>
      _CustomerTabSectionsViewState();
}

class _CustomerTabSectionsViewState extends State<_CustomerTabSectionsView> {
  /// First subsection open by default on **بيانات أساسية** (web accordion).
  final Set<int> _expanded = {0};

  @override
  Widget build(BuildContext context) {
    final visible = [
      for (final panel in widget.sections)
        if (panel.specs.any((s) => s.read(panel.data) != '—')) panel,
    ];

    if (visible.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Text(
            'لا توجد بيانات في هذا القسم',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF9AA3AE),
            ),
          ),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
      children: [
        for (var i = 0; i < visible.length; i++) ...[
          if (i > 0) SizedBox(height: 10.h),
          _CustomerSectionCard(
            title: visible[i].title,
            specs: visible[i].specs,
            data: visible[i].data,
            expanded: !widget.collapsible || _expanded.contains(i),
            collapsible: widget.collapsible,
            onHeaderTap: widget.collapsible
                ? () => setState(() {
                    if (_expanded.contains(i)) {
                      _expanded.remove(i);
                    } else {
                      _expanded.add(i);
                    }
                  })
                : null,
          ),
        ],
      ],
    );
  }
}

class _CustomerSectionCard extends StatelessWidget {
  const _CustomerSectionCard({
    required this.title,
    required this.specs,
    required this.data,
    this.expanded = true,
    this.collapsible = false,
    this.onHeaderTap,
  });

  final String title;
  final List<InquiryFieldSpec> specs;
  final Map<String, dynamic> data;
  final bool expanded;
  final bool collapsible;
  final VoidCallback? onHeaderTap;

  int get _fieldCount =>
      specs.where((s) => s.read(data) != '—').length;

  @override
  Widget build(BuildContext context) {
    final fields = [
      for (final spec in specs)
        if (spec.read(data) != '—') spec,
    ];

    final headerColor = expanded && collapsible
        ? const Color(0xFF032F64)
        : const Color(0xFFE7F3FC);
    final titleColor = expanded && collapsible
        ? AppColors.white
        : const Color(0xFF032F64);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: expanded && collapsible
              ? const Color(0xFF032F64)
              : AppColors.cardBorder,
          width: expanded && collapsible ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: expanded ? 10.r : 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: headerColor,
            child: InkWell(
              onTap: onHeaderTap,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
                child: Row(
                  children: [
                    if (collapsible) ...[
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: AnimatedRotation(
                          turns: expanded ? 0.25 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.chevron_right,
                            color: titleColor,
                            size: 22.r,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: AppFonts.dinNextArabic,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: titleColor,
                        ),
                      ),
                    ),
                    if (collapsible && !expanded) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF032F64).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          '$_fieldCount',
                          style: TextStyle(
                            fontFamily: AppFonts.dinNextArabic,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: Padding(
              padding: EdgeInsets.all(14.w),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final cols = constraints.maxWidth >= 560 ? 2 : 1;
                  final gap = 12.w;
                  final itemWidth = cols == 1
                      ? constraints.maxWidth
                      : (constraints.maxWidth - gap) / 2;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      for (final spec in fields)
                        SizedBox(
                          width: itemWidth,
                          child: InquiryReadonlyField(
                            label: spec.label,
                            value: spec.read(data),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            secondChild: const SizedBox.shrink(),
            crossFadeState: expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 220),
            sizeCurve: Curves.easeOut,
          ),
        ],
      ),
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({required this.name, required this.idno});

  final String name;
  final String idno;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.iconBubble,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.badge_outlined, color: AppColors.accent, size: 24.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  name,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF032F64),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  idno,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSegmentBar extends StatelessWidget {
  const _ProfileSegmentBar({
    required this.labels,
    required this.index,
    required this.onChanged,
  });

  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: const Color(0xFFE8EDF2), width: 1),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Row(
            children: [
              for (var i = 0; i < labels.length; i++) ...[
                if (i > 0) SizedBox(width: 8.w),
                _SegmentChip(
                  label: labels[i],
                  selected: i == index,
                  onTap: () => onChanged(i),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SegmentChip extends StatelessWidget {
  const _SegmentChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF032F64) : const Color(0xFFF4F7FA),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: selected ? const Color(0xFF032F64) : const Color(0xFFD5DDE6),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.dinNextArabic,
            fontSize: 12.sp,
            fontWeight: FontWeight.w800,
            color: selected ? AppColors.white : AppColors.accent,
          ),
        ),
      ),
    );
  }
}

class InquiryFieldSpec {
  const InquiryFieldSpec(this.label, this.keys);

  final String label;
  final List<String> keys;

  String read(Map<String, dynamic> data) {
    String? numericFallback;
    for (final key in keys) {
      final value = data[key];
      if (value == null) continue;
      final text = '$value'.trim();
      if (text.isEmpty || text == 'null') continue;
      // Prefer Arabic/descr labels over raw lookup codes (1, 21, 453…).
      if (RegExp(r'^\d+$').hasMatch(text)) {
        numericFallback ??= text;
        continue;
      }
      return text;
    }
    return numericFallback ?? '—';
  }
}

class InquiryReadonlyField extends StatelessWidget {
  const InquiryReadonlyField({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: AppFonts.dinNextArabic,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6B7280),
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
