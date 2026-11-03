import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fund_track_api.dart';
import 'package:loanofficer/core/api/personal_fund_api.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';
import 'package:loanofficer/presenter/personal_fund_inquiry/widgets/inquiry_customer_query.dart';

/// FMC org VIEW modal — `cif/organizations` list + detail + partners.
class InquiryOrganizationProfileScene extends StatefulWidget {
  const InquiryOrganizationProfileScene({super.key, required this.row})
      : idno = null,
        orgId = null;

  const InquiryOrganizationProfileScene.forFund({
    super.key,
    required String idno,
    required String orgId,
  })  : row = null,
        idno = idno,
        orgId = orgId;

  final FundTrackRow? row;
  final String? idno;
  final String? orgId;

  String get _custIdno => row?.custId ?? idno ?? '';
  String get _orgId => row?.orgId ?? orgId ?? '';

  static void open(BuildContext context, FundTrackRow row) {
    if (row.orgId.trim().isEmpty) return;
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => InquiryOrganizationProfileScene(row: row),
      ),
    );
  }

  static void openForFund(
    BuildContext context, {
    required String idno,
    required String orgId,
  }) {
    if (orgId.trim().isEmpty) return;
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => InquiryOrganizationProfileScene.forFund(
          idno: idno,
          orgId: orgId,
        ),
      ),
    );
  }

  @override
  State<InquiryOrganizationProfileScene> createState() =>
      _InquiryOrganizationProfileSceneState();
}

class _InquiryOrganizationProfileSceneState
    extends State<InquiryOrganizationProfileScene> {
  final _api = PersonalFundApi();
  OrganizationInquiryBundle? _bundle;
  String? _error;
  bool _loading = true;

  static const _sections = [
    'بيانات المنشأة',
    'بيانات التأسيس',
    'بيانات التواصل',
    'موقع المنشأة',
    'العنوان',
    'بيانات الشركاء',
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
      final bundle = await _api.organizationInquiry(
        idno: widget._custIdno,
        orgId: widget._orgId,
      );
      if (!mounted) return;
      if (bundle.detail.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'لا توجد بيانات منشأة';
        });
        return;
      }
      setState(() {
        _bundle = bundle;
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

  String get _orgTitle {
    final d = _bundle?.detail ?? const {};
    final name = '${d['orgName'] ?? d['orgNameAr'] ?? ''}'.trim();
    return name.isEmpty ? 'بيانات المنشأة' : name;
  }

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      pageTitle: _orgTitle,
      pageIcon: Icons.business_outlined,
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
              : _bundle == null
              ? const SizedBox.shrink()
              : ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                  children: [
                    _OrgSummaryCard(
                      orgId: widget._orgId,
                      detail: _bundle!.detail,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'اختر القسم',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: AppFonts.dinNextArabic,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF032F64),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    for (var i = 0; i < _sections.length; i++) ...[
                      if (i > 0) SizedBox(height: 10.h),
                      _OrgSectionMenuTile(
                        label: _sections[i],
                        selected: false,
                        onTap: () => Navigator.of(context).push<void>(
                          MaterialPageRoute(
                            builder: (_) => _OrgSectionPage(
                              title: _sections[i],
                              index: i,
                              detail: _bundle!.detail,
                              partners: _bundle!.partners,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

class _OrgSummaryCard extends StatelessWidget {
  const _OrgSummaryCard({required this.orgId, required this.detail});

  final String orgId;
  final Map<String, dynamic> detail;

  @override
  Widget build(BuildContext context) {
    final regNo = '${detail['regNo'] ?? ''}'.trim();
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.cardBorder),
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
            child: Icon(Icons.storefront, color: AppColors.accent, size: 24.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'رقم المنشأة $orgId',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF032F64),
                  ),
                ),
                if (regNo.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    'سجل $regNo',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: AppFonts.dinNextArabic,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrgSectionMenuTile extends StatelessWidget {
  const _OrgSectionMenuTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFE7F3FC) : AppColors.white,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: selected
                  ? AppColors.accent
                  : const Color(0xFFD6E8F7),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: selected
                        ? const Color(0xFF032F64)
                        : AppColors.accent,
                  ),
                ),
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Icon(
                  Icons.chevron_left,
                  color: selected ? AppColors.accent : const Color(0xFF9AA3AE),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrgSectionPage extends StatelessWidget {
  const _OrgSectionPage({
    required this.title,
    required this.index,
    required this.detail,
    required this.partners,
  });

  final String title;
  final int index;
  final Map<String, dynamic> detail;
  final List<Map<String, dynamic>> partners;

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      pageTitle: title,
      pageIcon: Icons.business_outlined,
      onBack: () => Navigator.of(context).pop(),
      body: ColoredBox(
        color: AppColors.page,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: index == 5
              ? _PartnersPanel(partners: partners)
              : _OrgFieldsPanel(
                  title: title,
                  specs: _specsFor(index, detail),
                  data: _dataFor(index, detail),
                ),
        ),
      ),
    );
  }

  static List<InquiryFieldSpec> _specsFor(
    int index,
    Map<String, dynamic> detail,
  ) {
    final address = detail['address'];
    final addressMap = address is Map
        ? Map<String, dynamic>.from(address)
        : const <String, dynamic>{};
    return switch (index) {
      0 => OrganizationFieldMaps.main,
      1 => OrganizationFieldMaps.founding,
      2 => OrganizationFieldMaps.contact,
      3 => OrganizationFieldMaps.location,
      4 => OrganizationFieldMaps.address(addressMap),
      _ => const <InquiryFieldSpec>[],
    };
  }

  static Map<String, dynamic> _dataFor(
    int index,
    Map<String, dynamic> detail,
  ) {
    if (index != 4) return detail;
    final address = detail['address'];
    if (address is Map) return Map<String, dynamic>.from(address);
    return const {};
  }
}

/// Field order/labels aligned with FMC `AddEditOrganizationComponent` +
/// `PAGES.ORGANIZATION-ADD-EDIT-PAGE` in UAT `assets/i18n/ar.json`.
class OrganizationFieldMaps {
  static const main = [
    InquiryFieldSpec('إسم المنشأة', ['orgName', 'orgNameAr']),
    InquiryFieldSpec('رقم المنشأة', ['orgId']),
    InquiryFieldSpec('نوع المنشأة', ['orgTypeDescr', 'orgType']),
    InquiryFieldSpec('القطاع الإقتصادي', ['econCode1Descr', 'econCode1']),
    InquiryFieldSpec('القطاع التحليلي', ['econCode2Descr', 'econCode2']),
    InquiryFieldSpec('القطاع الفرعي', ['econCode3Descr', 'econCode3']),
    InquiryFieldSpec('وصف طبيعة المنشأة', ['orgDescr']),
  ];

  static const founding = [
    InquiryFieldSpec('الرقم الضريبي', ['taxFileNo']),
    InquiryFieldSpec('رقم السجل', ['regNo']),
    InquiryFieldSpec('تاريخ السجل', ['regIssueDate']),
    InquiryFieldSpec('تاريخ نهاية السجل', ['regExpDate']),
    InquiryFieldSpec('تاريخ مزاولة النشاط', ['practiceStartDate']),
    InquiryFieldSpec('رأس مال المنشأة', ['orgCapital']),
    InquiryFieldSpec('عدد العاملين', ['countEmployees']),
    InquiryFieldSpec('تصنيف حجم المؤسسة', [
      'companyCategoryDescr',
      'companyCategory',
    ]),
  ];

  static const contact = [
    InquiryFieldSpec('الرقم القومي لصاحب المنشأة', ['custIdno']),
    InquiryFieldSpec('إسم صاحب المنشأة', ['orgOwenrName', 'orgOwnerName']),
    InquiryFieldSpec('جهة التواصل', ['contactName']),
    InquiryFieldSpec('موبايل', ['contactPhone']),
    InquiryFieldSpec('البريد الإلكتروني لجهة التواصل', ['contactEmail']),
    InquiryFieldSpec('موبايل 2', ['phone1']),
    InquiryFieldSpec('تليفون ارضى', ['phone2']),
    InquiryFieldSpec('البريد الإلكتروني', ['email']),
  ];

  static const location = [
    InquiryFieldSpec('نوع موقع المنشأة', ['placeTypeDescr', 'placeType']),
    InquiryFieldSpec('ملكية موقع المنشأة', [
      'placeOwnershipDescr',
      'placeOwnership',
    ]),
    InquiryFieldSpec('عدد السنوات فى موقع المنشأة الحالى', ['placeNoOfYears']),
  ];

  static List<InquiryFieldSpec> address(Map<String, dynamic> _) => const [
    InquiryFieldSpec('المحافظة', ['stateName', 'stateCode']),
    InquiryFieldSpec('المدينة', ['cityName', 'cityCode']),
    InquiryFieldSpec('المركز / القسم', ['villageName', 'villageCode']),
    InquiryFieldSpec('الشارع', ['street']),
    InquiryFieldSpec('المبنى', ['buildingNo']),
    InquiryFieldSpec(' الطابق', ['floorNo']),
    InquiryFieldSpec(' الشقة', ['flatno', 'flatNo']),
    InquiryFieldSpec('علامة مميزة', ['addMark']),
    InquiryFieldSpec('الرمز البريدي', ['postCode']),
    InquiryFieldSpec('العنوان تفصيلي', ['addTxt']),
  ];

  static const partner = [
    InquiryFieldSpec('إسم الشريك', ['name', 'partnerName']),
    InquiryFieldSpec('الرقم القومي للشريك', ['idno', 'partnerIdno']),
    InquiryFieldSpec('تاريخ الميلاد', ['bod']),
    InquiryFieldSpec('الجنسية', ['nationCodeDescr', 'nationCode']),
    InquiryFieldSpec('مهامة بالشركة', ['role', 'roleDescr']),
    InquiryFieldSpec('نسبة الشراكة', ['partnerRatio', 'sharePercent']),
    InquiryFieldSpec('قيمة الشراكة', ['partnerAmt', 'partnerValue']),
  ];
}

class _OrgFieldsPanel extends StatelessWidget {
  const _OrgFieldsPanel({
    required this.title,
    required this.specs,
    required this.data,
  });

  final String title;
  final List<InquiryFieldSpec> specs;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final visible = [
      for (final spec in specs)
        if (spec.read(data) != '—') spec,
    ];

    if (visible.isEmpty) {
      return Center(
        child: Text(
          'لا توجد بيانات في هذا القسم',
          style: TextStyle(
            fontFamily: AppFonts.dinNextArabic,
            color: const Color(0xFF9AA3AE),
          ),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
                color: const Color(0xFFE7F3FC),
                child: Text(
                  title,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF032F64),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(14.w),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cols = constraints.maxWidth >= 520 ? 2 : 1;
                    final gap = 12.w;
                    final w = cols == 1
                        ? constraints.maxWidth
                        : (constraints.maxWidth - gap) / 2;
                    return Wrap(
                      spacing: gap,
                      runSpacing: gap,
                      children: [
                        for (final spec in visible)
                          SizedBox(
                            width: w,
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
            ],
          ),
        ),
      ],
    );
  }
}

class _PartnersPanel extends StatelessWidget {
  const _PartnersPanel({required this.partners});

  final List<Map<String, dynamic>> partners;

  @override
  Widget build(BuildContext context) {
    // Web always shows the partner form row (empty placeholders when no
    // partners exist). Match that layout instead of only an empty message.
    final rows = partners.isEmpty
        ? const [<String, dynamic>{}]
        : partners;

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      itemCount: rows.length,
      separatorBuilder: (_, _) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        final p = rows[index];
        return Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F3FC),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'بيانات الشركاء',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF032F64),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              for (final spec in OrganizationFieldMaps.partner) ...[
                InquiryReadonlyField(
                  label: spec.label,
                  value: partners.isEmpty ? '' : spec.read(p),
                ),
                SizedBox(height: 8.h),
              ],
            ],
          ),
        );
      },
    );
  }
}
