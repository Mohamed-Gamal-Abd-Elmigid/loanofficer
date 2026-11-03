import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fund_track_api.dart';
import 'package:loanofficer/core/api/service_query_api.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';
import 'package:loanofficer/presenter/fund_track/scene/fund_track_detail_scene.dart';
export 'package:loanofficer/presenter/personal_fund_inquiry/widgets/inquiry_account_statement.dart'
    show InquiryAccountStatementScene;
export 'package:loanofficer/presenter/personal_fund_inquiry/widgets/inquiry_micro_financial_study.dart'
    show InquiryFinancialStudyScene;
export 'package:loanofficer/presenter/personal_fund_inquiry/widgets/inquiry_service_documents.dart'
    show InquiryDocumentsScene;
export 'package:loanofficer/presenter/personal_fund_inquiry/widgets/inquiry_workflow_review.dart'
    show InquiryWorkflowReviewScene;
import 'package:loanofficer/presenter/personal_fund_inquiry/widgets/inquiry_customer_query.dart';
import 'package:loanofficer/presenter/personal_fund_inquiry/widgets/inquiry_grantor_profile.dart';
import 'package:loanofficer/presenter/personal_fund_inquiry/widgets/inquiry_organization_profile.dart';
/// Shared helpers + all «⋮» inquiry destinations (FMC `funding-personal-service-query`).
class InquiryFundDataScene extends StatelessWidget {
  const InquiryFundDataScene({super.key, required this.row});

  final FundTrackRow row;

  static void open(BuildContext context, FundTrackRow row) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => InquiryFundDataScene(row: row),
      ),
    );
  }

  static const _sections = <({String title, Map<String, String> fields})>[
    (
      title: 'بيانات الفرع',
      fields: {
        'branchName': 'الفرع',
        'bmCodeName': 'مدير الفرع',
        'tlCodeName': 'قائد الفريق',
        'loCodeName': 'مسؤول التمويل',
        'telerName': 'Tele-sales',
      },
    ),
    (
      title: 'بيانات العميل',
      fields: {
        'custName': 'اسم العميل',
        'custno': 'رقم العميل',
        'custId': 'رقم البطاقة',
        'renewDescr': 'تجديد',
      },
    ),
    (
      title: 'بيانات التمويل',
      fields: {
        'serviceId': 'رقم التمويل',
        'loanName': 'المنتج',
        'promotionName': 'العرض',
        'srvStatusName': 'حالة التمويل',
        'layerName': 'الطبقة',
        'groupId': 'المجموعة',
        'prodName': 'نوع المنتج',
        'merchantName': 'التاجر',
        'legalActionDescr': 'إجراء قانوني',
        'issueSrcDescr': 'مصدر الإصدار',
        'disbursementStatus': 'حالة الصرف',
        'fundingSourceDescr': 'مصدر التمويل',
        'insLifeCoDescr': 'تأمين على الحياة',
        'insDebtCoDescr': 'تأمين على الدين',
        'archiveCode': 'كود الأرشيف',
      },
    ),
    (
      title: 'بيانات المنح',
      fields: {
        'approveValue': 'المبلغ المعتمد',
        'addedValue': 'القيمة المضافة',
        'profitValue': 'قيمة الربح',
        'kstAmt': 'قيمة القسط',
        'totalAmount': 'إجمالي المبلغ',
        'requiredValue': 'المبلغ المطلوب',
        'netDeliverToCust': 'صافي للعميل',
        'noOfKsts': 'عدد الأقساط',
        'noOfMonths': 'عدد الشهور',
        'rate': 'النسبة',
        'issueDate': 'تاريخ الإصدار',
        'openDate': 'تاريخ الفتح',
        'fkstDate': 'أول قسط',
        'lkstDate': 'آخر قسط',
        'expireDate': 'تاريخ الانتهاء',
      },
    ),
    (
      title: 'بيانات القرض',
      fields: {
        'balValue': 'الرصيد',
        'debtDues': 'المستحقات',
        'remBalKstAmt': 'متبقي أصل القسط',
        'remIntKstAmt': 'متبقي فائدة القسط',
        'remPenaltyAmt': 'متبقي الغرامات',
        'lateNoOfKst': 'أقساط متأخرة',
        'lateKstDate': 'تاريخ التأخير',
        'remNoOfKst': 'أقساط متبقية',
        'totalDebts': 'إجمالي المديونية',
        'customerCrBalance': 'رصيد دائن',
        'netTotalDebts': 'صافي المديونية',
        'entryAppCommAmt': 'عمولة',
        'customerPindingBalance': 'رصيد معلق',
      },
    ),
    (
      title: 'سداد معجل',
      fields: {
        'earlyPaymentRequired': 'المطلوب للسداد المعجل',
        'netEarlyPaymentRequired': 'صافي السداد المعجل',
        'earlyIntRate': 'نسبة الفائدة',
        'earlyIntAmt': 'قيمة الفائدة',
        'earlyKstIntPayed': 'فائدة أقساط مسددة',
      },
    ),
    (
      title: 'Offloading',
      fields: {
        'offloadingTypeDescr': 'النوع',
        'offloadingBanknoName': 'البنك',
        'offloadingAppdate': 'تاريخ الطلب',
      },
    ),
    (
      title: 'شطب / تنفيذ',
      fields: {
        'writoffType': 'نوع الشطب',
        'writoffDescription': 'الوصف',
        'writoffDate': 'التاريخ',
        'writoffBal': 'الرصيد',
        'writoffTotDebt': 'إجمالي الدين',
        'writoffPayments': 'المدفوعات',
        'writoffUnpaiedNoKst': 'أقساط غير مسددة',
      },
    ),
    (
      title: 'إعادة جدولة',
      fields: {
        'reschUpdateDate': 'تاريخ التحديث',
        'reschExecuteDate': 'تاريخ التنفيذ',
        'reschTotalAmount': 'المبلغ الإجمالي',
        'reschCommAmount': 'العمولة',
        'reschProfitAmount': 'الربح',
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final map = row.raw;
    return FlowScaffold(
      pageTitle: 'بيانات التمويل',
      pageIcon: Icons.description_outlined,
      onBack: () => Navigator.of(context).pop(),
      body: ColoredBox(
        color: AppColors.page,
        child: ListView(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
          children: [
            for (final section in _sections) ...[
              _SectionCard(
                title: section.title,
                lines: [
                  for (final e in section.fields.entries)
                    (e.value, _InquiryFormat.value(map[e.key])),
                ],
              ),
              SizedBox(height: 12.h),
            ],
          ],
        ),
      ),
    );
  }
}

class InquiryInstallmentsScene extends StatefulWidget {
  const InquiryInstallmentsScene({super.key, required this.row});

  final FundTrackRow row;

  static void open(BuildContext context, FundTrackRow row) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => InquiryInstallmentsScene(row: row),
      ),
    );
  }

  @override
  State<InquiryInstallmentsScene> createState() =>
      _InquiryInstallmentsSceneState();
}

class _InquiryInstallmentsSceneState extends State<InquiryInstallmentsScene> {
  final _api = ServiceQueryApi();
  List<Map<String, dynamic>> _rows = [];
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
    });
    try {
      final rows = await _api.premiums(
        status: widget.row.status,
        serviceId: widget.row.serviceId,
      );
      if (!mounted) return;
      setState(() {
        _rows = rows;
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
      pageTitle: 'بيانات الأقساط',
      pageIcon: Icons.calendar_month_outlined,
      onBack: () => Navigator.of(context).pop(),
      body: ColoredBox(
        color: AppColors.page,
        child: _AsyncBody(
          loading: _loading,
          error: _error,
          onRetry: _load,
          child: _rows.isEmpty
              ? Center(
                  child: Text(
                    'لا توجد أقساط',
                    style: TextStyle(fontFamily: AppFonts.dinNextArabic),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                  itemCount: _rows.length,
                  separatorBuilder: (_, __) => SizedBox(height: 14.h),
                  itemBuilder: (_, index) =>
                      _InstallmentCard(row: _rows[index]),
                ),
        ),
      ),
    );
  }
}

class _InstallmentCard extends StatelessWidget {
  const _InstallmentCard({required this.row});

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    final detailRows = _InquiryFormat.list(row['details']);
    final installmentNo = _InquiryFormat.value(row['installmentNo']);
    final installmentDate = _InquiryFormat.value(row['installmentDate']);
    final total = _InstallmentUi.amount(row['installmentAmount']);
    final paid = _InstallmentUi.amount(row['installmentPayedAmount']);
    final lateDays = _InstallmentUi.intValue(row['noOfDaysLate']);
    final payStatus = _InstallmentUi.payStatus(total: total, paid: paid);
    final progress = total <= 0 ? 0.0 : (paid / total).clamp(0.0, 1.0);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48.r,
                    height: 48.r,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.iconBubble,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      installmentNo == '—' ? '؟' : installmentNo,
                      style: TextStyle(
                        fontFamily: AppFonts.dinNextArabic,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'قسط $installmentNo',
                          style: TextStyle(
                            fontFamily: AppFonts.dinNextArabic,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF032F64),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.event_outlined,
                              size: 16.r,
                              color: const Color(0xFF9AA3AE),
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                installmentDate,
                                style: TextStyle(
                                  fontFamily: AppFonts.dinNextArabic,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _InstallmentStatusChip(status: payStatus),
                      if (lateDays > 0) ...[
                        SizedBox(height: 6.h),
                        _InstallmentLateChip(days: lateDays),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F7FA),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE4E9F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'قيمة القسط',
                            style: TextStyle(
                              fontFamily: AppFonts.dinNextArabic,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF9AA3AE),
                            ),
                          ),
                        ),
                        Text(
                          _InstallmentUi.money(row['installmentAmount']),
                          style: TextStyle(
                            fontFamily: AppFonts.dinNextArabic,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF032F64),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6.h,
                        backgroundColor: const Color(0xFFE4E9F0),
                        color: _InstallmentUi.progressColor(payStatus),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Text(
                          'المسدد ${_InstallmentUi.money(row['installmentPayedAmount'])}',
                          style: TextStyle(
                            fontFamily: AppFonts.dinNextArabic,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF3C4F73),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${(progress * 100).round()}%',
                          style: TextStyle(
                            fontFamily: AppFonts.dinNextArabic,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF9AA3AE),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Row(
                children: [
                  Expanded(
                    child: _InstallmentMetric(
                      label: 'تاريخ السداد',
                      value: _InquiryFormat.value(row['installmentPayedDate']),
                      icon: Icons.check_circle_outline,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _InstallmentMetric(
                      label: 'أيام التأخير',
                      value: lateDays > 0 ? '$lateDays' : '0',
                      icon: Icons.schedule_outlined,
                      highlight: lateDays > 0,
                    ),
                  ),
                ],
              ),
            ),
            if (detailRows.isNotEmpty) ...[
              SizedBox(height: 14.h),
              Divider(height: 1, color: const Color(0xFFE8EDF2)),
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'تفاصيل القسط',
                      style: TextStyle(
                        fontFamily: AppFonts.dinNextArabic,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF032F64),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    for (var i = 0; i < detailRows.length; i++) ...[
                      if (i > 0) SizedBox(height: 8.h),
                      _InstallmentDetailTile(row: detailRows[i]),
                    ],
                  ],
                ),
              ),
            ] else
              SizedBox(height: 14.h),
          ],
        ),
      ),
    );
  }
}

enum _InstallmentPayStatus { paid, partial, unpaid }

class _InstallmentUi {
  static double amount(dynamic v) {
    if (v is num) return v.toDouble();
    return double.tryParse('$v'.trim()) ?? 0;
  }

  static int intValue(dynamic v) {
    if (v is num) return v.toInt();
    return int.tryParse('$v'.trim()) ?? 0;
  }

  static String money(dynamic v) {
    if (v == null || '$v'.trim().isEmpty) return '—';
    final n = amount(v);
    if (n == 0 && '$v'.trim() != '0') return _InquiryFormat.value(v);
    final text = n == n.roundToDouble()
        ? n.toStringAsFixed(0)
        : n.toStringAsFixed(2);
    return text;
  }

  static _InstallmentPayStatus payStatus({
    required double total,
    required double paid,
  }) {
    if (total <= 0 && paid <= 0) return _InstallmentPayStatus.unpaid;
    if (paid >= total && total > 0) return _InstallmentPayStatus.paid;
    if (paid > 0) return _InstallmentPayStatus.partial;
    return _InstallmentPayStatus.unpaid;
  }

  static Color progressColor(_InstallmentPayStatus status) {
    return switch (status) {
      _InstallmentPayStatus.paid => const Color(0xFF16A34A),
      _InstallmentPayStatus.partial => const Color(0xFFD97706),
      _InstallmentPayStatus.unpaid => AppColors.accent,
    };
  }
}

class _InstallmentStatusChip extends StatelessWidget {
  const _InstallmentStatusChip({required this.status});

  final _InstallmentPayStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, fg, bg, border) = switch (status) {
      _InstallmentPayStatus.paid => (
        'مسدد',
        const Color(0xFF166534),
        const Color(0xFFDCFCE7),
        const Color(0xFF86EFAC),
      ),
      _InstallmentPayStatus.partial => (
        'مسدد جزئياً',
        const Color(0xFF92400E),
        const Color(0xFFFFEDD5),
        const Color(0xFFFDBA74),
      ),
      _InstallmentPayStatus.unpaid => (
        'غير مسدد',
        const Color(0xFF0369A1),
        const Color(0xFFE7F3FC),
        const Color(0xFFB8DCF5),
      ),
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.dinNextArabic,
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          color: fg,
        ),
      ),
    );
  }
}

class _InstallmentLateChip extends StatelessWidget {
  const _InstallmentLateChip({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Text(
        'تأخير $days يوم',
        style: TextStyle(
          fontFamily: AppFonts.dinNextArabic,
          fontSize: 10.sp,
          fontWeight: FontWeight.w800,
          color: const Color(0xFFB91C1C),
        ),
      ),
    );
  }
}

class _InstallmentMetric extends StatelessWidget {
  const _InstallmentMetric({
    required this.label,
    required this.value,
    required this.icon,
    this.highlight = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFFFF7ED) : AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: highlight ? const Color(0xFFFED7AA) : const Color(0xFFE8EDF2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16.r,
                color: highlight ? const Color(0xFFEA580C) : AppColors.accent,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF9AA3AE),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: highlight
                  ? const Color(0xFF9A3412)
                  : const Color(0xFF032F64),
            ),
          ),
        ],
      ),
    );
  }
}

class _InstallmentDetailTile extends StatelessWidget {
  const _InstallmentDetailTile({required this.row});

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    final title = _InquiryFormat.value(row['kstTypeNameAr'] ?? row['kstType']);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFD6E8F7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: AppFonts.dinNextArabic,
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF032F64),
                height: 1.35,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'المبلغ ${_InstallmentUi.money(row['installmentAmount'])}',
                style: TextStyle(
                  fontFamily: AppFonts.dinNextArabic,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF3C4F73),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'المسدد ${_InstallmentUi.money(row['installmentPayedAmount'])}',
                style: TextStyle(
                  fontFamily: AppFonts.dinNextArabic,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF9AA3AE),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InquiryPenaltiesScene extends StatefulWidget {
  const InquiryPenaltiesScene({super.key, required this.row});

  final FundTrackRow row;

  static void open(BuildContext context, FundTrackRow row) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => InquiryPenaltiesScene(row: row),
      ),
    );
  }

  @override
  State<InquiryPenaltiesScene> createState() => _InquiryPenaltiesSceneState();
}

class _InquiryPenaltiesSceneState extends State<InquiryPenaltiesScene> {
  final _api = ServiceQueryApi();
  List<Map<String, dynamic>> _rows = [];
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
    });
    try {
      final rows = await _api.penalties(
        status: widget.row.status,
        serviceId: widget.row.serviceId,
      );
      if (!mounted) return;
      setState(() {
        _rows = rows;
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
    return _InquiryTableScaffold(
      title: 'الغرامات',
      icon: Icons.warning_amber_outlined,
      loading: _loading,
      error: _error,
      onRetry: _load,
      emptyMessage: 'لا توجد غرامات',
      rows: _rows,
      columns: const [
        _Col('calcDate', 'تاريخ احتساب الغرامة'),
        _Col('premiumDate', 'تاريخ القسط'),
        _Col('penaltyAmount', 'قيمة الغرامة'),
        _Col('setAmount', 'المحصل'),
        _Col('canceledAmount', 'الملغى'),
        _Col('setDate', 'تاريخ التحصيل'),
        _Col('installmentNo', 'رقم القسط'),
      ],
    );
  }
}

class InquiryGrantorsScene extends StatefulWidget {
  const InquiryGrantorsScene({super.key, required this.row});

  final FundTrackRow row;

  static void open(BuildContext context, FundTrackRow row) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => InquiryGrantorsScene(row: row),
      ),
    );
  }

  @override
  State<InquiryGrantorsScene> createState() => _InquiryGrantorsSceneState();
}

class _InquiryGrantorsSceneState extends State<InquiryGrantorsScene> {
  final _api = ServiceQueryApi();
  List<Map<String, dynamic>> _rows = [];
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
    });
    try {
      final rows = await _api.grantors(
        status: widget.row.status,
        serviceId: widget.row.serviceId,
      );
      if (!mounted) return;
      setState(() {
        _rows = rows;
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
      pageTitle: 'بيانات الضامنين',
      pageIcon: Icons.groups_outlined,
      onBack: () => Navigator.of(context).pop(),
      body: ColoredBox(
        color: AppColors.page,
        child: _AsyncBody(
          loading: _loading,
          error: _error,
          onRetry: _load,
          child: _rows.isEmpty
              ? Center(
                  child: Text(
                    'لا يوجد ضامنون',
                    style: TextStyle(fontFamily: AppFonts.dinNextArabic),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                  itemCount: _rows.length,
                  separatorBuilder: (_, __) => SizedBox(height: 14.h),
                  itemBuilder: (context, index) =>
                      _GrantorListCard(row: _rows[index]),
                ),
        ),
      ),
    );
  }
}

class _GrantorListCard extends StatelessWidget {
  const _GrantorListCard({required this.row});

  final Map<String, dynamic> row;

  @override
  Widget build(BuildContext context) {
    final idno = _InquiryFormat.value(row['grantIdno']);
    final name = _InquiryFormat.value(row['grantFullName']);
    final relation = _InquiryFormat.value(row['relationTypeAr']);
    final order = _InquiryFormat.value(row['orderby']);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48.r,
                  height: 48.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.iconBubble,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: AppColors.accent,
                    size: 26.r,
                  ),
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
                if (order != '—')
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4F8),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: const Color(0xFFD5DDE6)),
                    ),
                    child: Text(
                      'ترتيب $order',
                      style: TextStyle(
                        fontFamily: AppFonts.dinNextArabic,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF3C4F73),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7FA),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFFE4E9F0)),
              ),
              child: Row(
                children: [
                  Icon(Icons.family_restroom_outlined,
                      size: 18.r, color: AppColors.accent),
                  SizedBox(width: 8.w),
                  Text(
                    'صلة القرابة',
                    style: TextStyle(
                      fontFamily: AppFonts.dinNextArabic,
                      fontSize: 12.sp,
                      color: const Color(0xFF9AA3AE),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    relation,
                    style: TextStyle(
                      fontFamily: AppFonts.dinNextArabic,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF032F64),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 44.h,
              child: FilledButton.icon(
                onPressed: idno == '—' || idno.length != 14
                    ? null
                    : () => InquiryGrantorProfileScene.open(
                          context,
                          idno: idno,
                          displayName: name == '—' ? null : name,
                        ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: const Color(0xFFE4E9F0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                icon: Icon(Icons.visibility_outlined, size: 20.r),
                label: Text(
                  'عرض',
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InquiryOrganizationScene extends StatelessWidget {
  const InquiryOrganizationScene({super.key, required this.row});

  final FundTrackRow row;

  static void open(BuildContext context, FundTrackRow row) {
    InquiryOrganizationProfileScene.open(context, row);
  }

  @override
  Widget build(BuildContext context) {
    return InquiryOrganizationProfileScene(row: row);
  }
}

class InquiryCustomerScene extends StatelessWidget {
  const InquiryCustomerScene({super.key, required this.row});

  final FundTrackRow row;

  static void open(BuildContext context, FundTrackRow row) {
    InquiryCustomerProfileScene.open(context, row);
  }

  @override
  Widget build(BuildContext context) {
    return InquiryCustomerProfileScene(row: row);
  }
}

class _Col {
  const _Col(this.key, this.label);
  final String key;
  final String label;
}

class _InquiryTableScaffold extends StatelessWidget {
  const _InquiryTableScaffold({
    required this.title,
    required this.icon,
    required this.loading,
    required this.error,
    required this.onRetry,
    required this.emptyMessage,
    required this.rows,
    required this.columns,
    this.header,
  });

  final String title;
  final IconData icon;
  final bool loading;
  final String? error;
  final VoidCallback onRetry;
  final String emptyMessage;
  final List<Map<String, dynamic>> rows;
  final List<_Col> columns;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      pageTitle: title,
      pageIcon: icon,
      onBack: () => Navigator.of(context).pop(),
      body: ColoredBox(
        color: AppColors.page,
        child: _AsyncBody(
          loading: loading,
          error: error,
          onRetry: onRetry,
          child: rows.isEmpty
              ? Center(
                  child: Text(
                    emptyMessage,
                    style: TextStyle(fontFamily: AppFonts.dinNextArabic),
                  ),
                )
              : ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                  children: [
                    if (header != null) header!,
                    for (final row in rows)
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: _SectionCard(
                          title: _InquiryFormat.value(
                            row[columns.first.key] ?? title,
                          ),
                          lines: [
                            for (final col in columns.skip(1))
                              (
                                col.label,
                                _InquiryFormat.value(row[col.key]),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _AsyncBody extends StatelessWidget {
  const _AsyncBody({
    required this.loading,
    required this.error,
    required this.onRetry,
    required this.child,
  });

  final bool loading;
  final String? error;
  final VoidCallback onRetry;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error!, textAlign: TextAlign.center),
            TextButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
          ],
        ),
      );
    }
    return child;
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.lines,
    this.footer,
  });

  final String title;
  final List<(String, String)> lines;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: AppFonts.dinNextArabic,
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF032F64),
              ),
            ),
            SizedBox(height: 10.h),
            for (final (label, value) in lines)
              if (value != '—')
                Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120.w,
                        child: Text(
                          label,
                          style: TextStyle(
                            fontFamily: AppFonts.dinNextArabic,
                            fontSize: 12.sp,
                            color: const Color(0xFF9AA3AE),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          value,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: AppFonts.dinNextArabic,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2C2C2C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            if (footer != null) footer!,
          ],
        ),
      ),
    );
  }
}

class _InquiryFormat {
  static String value(dynamic v) {
    if (v == null || v == 'null') return '—';
    final t = '$v'.trim();
    return t.isEmpty ? '—' : t;
  }

  static List<Map<String, dynamic>> list(dynamic raw) {
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map) Map<String, dynamic>.from(item),
    ];
  }
}
