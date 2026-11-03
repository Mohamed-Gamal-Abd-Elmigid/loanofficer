import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fund_track_api.dart';
import 'package:loanofficer/core/api/service_query_api.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';
import 'package:loanofficer/presenter/personal_fund_inquiry/widgets/inquiry_customer_query.dart';

/// FMC `GET query/service/microFinancialStudy` — **بيانات الدراسة المالية**.
class InquiryFinancialStudyScene extends StatefulWidget {
  const InquiryFinancialStudyScene({super.key, required this.row});

  final FundTrackRow row;

  static void open(BuildContext context, FundTrackRow row) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => InquiryFinancialStudyScene(row: row),
      ),
    );
  }

  @override
  State<InquiryFinancialStudyScene> createState() =>
      _InquiryFinancialStudySceneState();
}

class _InquiryFinancialStudySceneState
    extends State<InquiryFinancialStudyScene> {
  final _api = ServiceQueryApi();
  Map<String, dynamic>? _study;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
      _study = null;
    });
    try {
      final custNo = widget.row.custno.isNotEmpty
          ? widget.row.custno
          : '${widget.row.raw['custno'] ?? ''}';
      final study = await _api.microFinancialStudy(
        custNo: custNo,
        serviceId: widget.row.serviceId,
      );
      if (!mounted) return;
      setState(() {
        _study = study.isEmpty ? null : study;
        _error = study.isEmpty ? 'لا توجد دراسة مالية لهذا الطلب' : null;
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

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      pageTitle: 'بيانات الدراسة المالية',
      pageIcon: Icons.analytics_outlined,
      onBack: () => Navigator.of(context).pop(),
      body: ColoredBox(
        color: AppColors.page,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: _loading
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: AppColors.accent),
                      SizedBox(height: 12.h),
                      Text(
                        'جاري تحميل الدراسة المالية...',
                        style: TextStyle(
                          fontFamily: AppFonts.dinNextArabic,
                          fontSize: 14.sp,
                          color: const Color(0xFF9AA3AE),
                        ),
                      ),
                    ],
                  ),
                )
              : _error != null
              ? _FinStudyError(message: _error!, onRetry: _load)
              : _study == null
              ? const SizedBox.shrink()
              : RefreshIndicator(
                  color: AppColors.accent,
                  onRefresh: _load,
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      _FinStudyIntroBanner(serviceId: widget.row.serviceId),
                      SizedBox(height: 12.h),
                      _MicroFinancialStudySectionsView(data: _study!),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _FinStudyIntroBanner extends StatelessWidget {
  const _FinStudyIntroBanner({required this.serviceId});

  final String serviceId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.iconBubble,
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Icon(Icons.insights_outlined, color: AppColors.accent, size: 22.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ملخص الدراسة',
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF032F64),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'كود التمويل: $serviceId',
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF9AA3AE),
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

/// Web `FinStudyInquiryModal` — four accordion tabs.
class InquiryMicroFinancialStudyPanel {
  const InquiryMicroFinancialStudyPanel({
    required this.title,
    required this.icon,
    required this.specs,
  });

  final String title;
  final IconData icon;
  final List<InquiryFieldSpec> specs;

  static List<InquiryMicroFinancialStudyPanel> panels() => const [
        InquiryMicroFinancialStudyPanel(
          title: 'بيانات الفرع',
          icon: Icons.storefront_outlined,
          specs: [
            InquiryFieldSpec('رقم التمويل', ['serviceId']),
            InquiryFieldSpec('إسم الفرع', ['branchName']),
            InquiryFieldSpec('نسبة مخاطر الفرع', ['brRiskRate']),
            InquiryFieldSpec('مسؤول التمويل', ['loCodeName', 'loName']),
            InquiryFieldSpec('عدد اشهر التعيين', ['loHireMonths']),
            InquiryFieldSpec('عدد اشهر الخبرة', ['loExperienceMonths']),
            InquiryFieldSpec('نسبة مخاطر المسؤول', ['loRiskRate']),
            InquiryFieldSpec('تاريخ الادخال', ['entryDate']),
          ],
        ),
        InquiryMicroFinancialStudyPanel(
          title: 'بيانات التمويل',
          icon: Icons.account_balance_wallet_outlined,
          specs: [
            InquiryFieldSpec('هوية العميل', ['custId']),
            InquiryFieldSpec('إسم العميل', ['custName']),
            InquiryFieldSpec('الغرض من التمويل', ['fundReason']),
            InquiryFieldSpec('اسم المنشأة', ['orgName']),
            InquiryFieldSpec('طبيعة المنشأة', ['orgTypeDescr']),
            InquiryFieldSpec('رقم السجل للمنشأة', ['orgRegNo']),
            InquiryFieldSpec('الرقم الضريبي للمنشأة', ['orgTaxFileNo']),
            InquiryFieldSpec('النشاط الاقتصادى', ['orgEconCode1Descr']),
            InquiryFieldSpec('النشاط الاقتصادى التحليلى', ['orgEconCode2Descr']),
            InquiryFieldSpec('النشاط الاقتصادى الفرعى', ['orgEconCode3Descr']),
            InquiryFieldSpec('وصف طبيعة نشاط العميل', ['activityDesc']),
            InquiryFieldSpec('تاريخ مزاولة النشاط للمنشأة', [
              'orgPracticeStartDate',
            ]),
            InquiryFieldSpec('العنوان', ['address']),
          ],
        ),
        InquiryMicroFinancialStudyPanel(
          title: 'بيانات التشغيل',
          icon: Icons.precision_manufacturing_outlined,
          specs: [
            InquiryFieldSpec('دورة التشغيل بالشهور', ['capitalRound']),
            InquiryFieldSpec('إجمالي الإيرادات', ['totalRevenue']),
            InquiryFieldSpec('إجمالي المصاريف', ['costExpenses']),
            InquiryFieldSpec('صافي الدخل', ['netIncome']),
            InquiryFieldSpec('راس مال المنشأة', ['actvCap']),
            InquiryFieldSpec('عدد العاملين الذكور', ['actvWorkerM']),
            InquiryFieldSpec('عدد العاملين اناث', ['actvWorkerF']),
            InquiryFieldSpec('عدد العمالة المؤقتة', ['temporaryEmployment']),
            InquiryFieldSpec('المحافظة- المنشأة', ['orgStateName']),
            InquiryFieldSpec('المدينة - المنشأة', ['orgCityName']),
            InquiryFieldSpec('المركز- المنشأة', ['orgVillageName']),
            InquiryFieldSpec('مؤشر السيولة', ['currentRatio']),
          ],
        ),
        InquiryMicroFinancialStudyPanel(
          title: 'بيانات آي سكور',
          icon: Icons.assessment_outlined,
          specs: [
            InquiryFieldSpec('عدد التسهيلات القائمة', ['iscoreOpenAccCnt']),
            InquiryFieldSpec('الرصيد القائم للتسهيلات القائمة', [
              'iscoreOpenAccOutstading',
              'iscoreOpenAccOutstanding',
            ]),
            InquiryFieldSpec('الفوائد الغير مستحقة للتسهيلات القائمة', [
              'iscoreOpenAccUnearnedInt',
            ]),
            InquiryFieldSpec('الفوائد الشهرية للتسهيلات القائمة', [
              'iscoreOpenAccKstAmt',
            ]),
            InquiryFieldSpec('عدد الاقساط المتبقية للتسهيلات القائمة', [
              'iscoreOpenAccNoofksts',
              'iscoreOpenAccNoOfKsts',
            ]),
            InquiryFieldSpec('عدد التسهيلات المغلقة', [
              'iscoreClosedAccountsCnt',
            ]),
            InquiryFieldSpec('عدد التسهيلات محالة للقضاء', [
              'iscoreLeagalAccountsCnt',
              'iscoreLegalAccountsCnt',
            ]),
            InquiryFieldSpec('تواجد العميل بالقوائم السلبية', [
              'iscoreNegativeListCnt',
            ]),
            InquiryFieldSpec('اقصي عدد ايام تأخير', ['iscoreMaxNdpd']),
            InquiryFieldSpec('الرصيد المستحق للتسهيلات القائمة', [
              'iscoreOpenAccOverdueamt',
              'iscoreOpenAccOverdueAmt',
            ]),
            InquiryFieldSpec('عدد التسهيلات المعدومة', [
              'iscoreWrittenoffCnt',
              'iscoreWrittenOffCnt',
            ]),
          ],
        ),
      ];
}

class _MicroFinancialStudySectionsView extends StatefulWidget {
  const _MicroFinancialStudySectionsView({required this.data});

  final Map<String, dynamic> data;

  @override
  State<_MicroFinancialStudySectionsView> createState() =>
      _MicroFinancialStudySectionsViewState();
}

class _MicroFinancialStudySectionsViewState
    extends State<_MicroFinancialStudySectionsView> {
  /// First section (**بيانات الفرع**) open on entry.
  final Set<int> _expanded = {0};

  @override
  Widget build(BuildContext context) {
    final panels = InquiryMicroFinancialStudyPanel.panels();
    final visible = [
      for (final panel in panels)
        if (panel.specs.any((s) => s.read(widget.data) != '—')) panel,
    ];

    if (visible.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        child: Text(
          'لا توجد حقول دراسة مالية للعرض',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.dinNextArabic,
            fontSize: 14.sp,
            color: const Color(0xFF9AA3AE),
          ),
        ),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < visible.length; i++) ...[
          if (i > 0) SizedBox(height: 10.h),
          _FinStudySectionCard(
            panel: visible[i],
            data: widget.data,
            expanded: _expanded.contains(i),
            onHeaderTap: () => setState(() {
              if (_expanded.contains(i)) {
                _expanded.remove(i);
              } else {
                _expanded.add(i);
              }
            }),
          ),
        ],
      ],
    );
  }
}

class _FinStudySectionCard extends StatelessWidget {
  const _FinStudySectionCard({
    required this.panel,
    required this.data,
    required this.expanded,
    required this.onHeaderTap,
  });

  final InquiryMicroFinancialStudyPanel panel;
  final Map<String, dynamic> data;
  final bool expanded;
  final VoidCallback onHeaderTap;

  @override
  Widget build(BuildContext context) {
    final fields = [
      for (final spec in panel.specs)
        if (spec.read(data) != '—') spec,
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: expanded ? const Color(0xFF0369A1) : const Color(0xFFB8DCF5),
          width: expanded ? 1.5 : 1,
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
            color: expanded ? const Color(0xFF0369A1) : const Color(0xFFE7F3FC),
            child: InkWell(
              onTap: onHeaderTap,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        panel.title,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: AppFonts.dinNextArabic,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: expanded
                              ? AppColors.white
                              : const Color(0xFF032F64),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.expand_more,
                        color: expanded ? AppColors.white : AppColors.accent,
                        size: 26.r,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
              child: Column(
                children: [
                  for (var i = 0; i < fields.length; i++) ...[
                    if (i > 0) SizedBox(height: 10.h),
                    InquiryReadonlyField(
                      label: fields[i].label,
                      value: fields[i].read(data),
                    ),
                  ],
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
            crossFadeState: expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

class _FinStudyError extends StatelessWidget {
  const _FinStudyError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: AppColors.primary, size: 36.r),
            SizedBox(height: 10.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.dinNextArabic,
                color: AppColors.primary,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 12.h),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: AppColors.accent),
              label: Text(
                'إعادة المحاولة',
                style: TextStyle(
                  fontFamily: AppFonts.dinNextArabic,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
