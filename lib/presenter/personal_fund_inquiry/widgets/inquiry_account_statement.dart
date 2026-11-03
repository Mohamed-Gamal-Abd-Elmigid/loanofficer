import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fund_track_api.dart';
import 'package:loanofficer/core/api/service_query_api.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';

/// FMC `GET query/glCustomerStatement?custNo=&prodType=` (كشف حساب عميل).
class InquiryAccountStatementScene extends StatefulWidget {
  const InquiryAccountStatementScene({super.key, required this.row});

  final FundTrackRow row;

  static void open(BuildContext context, FundTrackRow row) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => InquiryAccountStatementScene(row: row),
      ),
    );
  }

  @override
  State<InquiryAccountStatementScene> createState() =>
      _InquiryAccountStatementSceneState();
}

class _InquiryAccountStatementSceneState
    extends State<InquiryAccountStatementScene> {
  final _api = ServiceQueryApi();
  List<Map<String, dynamic>> _rows = [];
  String _balance = '';
  String _customerName = '';
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
      final custNo = widget.row.custno.isNotEmpty
          ? widget.row.custno
          : '${widget.row.raw['custno'] ?? ''}';
      final map = await _api.customerAccountStatement(
        custNo: custNo,
        prodType: widget.row.prodType,
      );
      if (!mounted) return;
      setState(() {
        _rows = _StatementFormat.rows(map['details']);
        _balance = _StatementFormat.value(
          map['curerntBalance'] ?? map['currentBalance'],
        );
        final fromApi = _StatementFormat.value(
          map['subglNameAr'] ?? map['subglNameEn'],
        );
        _customerName = fromApi != '—'
            ? fromApi
            : widget.row.custName.trim().isNotEmpty
            ? widget.row.custName.trim()
            : '—';
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
      pageTitle: 'كشف حساب عميل',
      pageIcon: Icons.receipt_long_outlined,
      onBack: () => Navigator.of(context).pop(),
      body: ColoredBox(
        color: AppColors.page,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? _StatementError(message: _error!, onRetry: _load)
              : ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                  children: [
                    _StatementSummaryCard(
                      balance: _balance,
                      customerName: _customerName,
                      movementCount: _rows.length,
                    ),
                    SizedBox(height: 14.h),
                    if (_rows.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.h),
                          child: Text(
                            'لا توجد حركات',
                            style: TextStyle(
                              fontFamily: AppFonts.dinNextArabic,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF9AA3AE),
                            ),
                          ),
                        ),
                      )
                    else ...[
                      Text(
                        'الحركات',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: AppFonts.dinNextArabic,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF032F64),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      for (var i = 0; i < _rows.length; i++) ...[
                        if (i > 0) SizedBox(height: 10.h),
                        _StatementMovementCard(row: _rows[i]),
                      ],
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

class _StatementSummaryCard extends StatelessWidget {
  const _StatementSummaryCard({
    required this.balance,
    required this.customerName,
    required this.movementCount,
  });

  final String balance;
  final String customerName;
  final int movementCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F7),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE2E8EE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 400;
              final balanceField = _SummaryField(
                label: 'الرصيد الحالي للعميل',
                value: balance,
                emphasizeValue: true,
              );
              final nameField = _SummaryField(
                label: 'إسم العميل',
                value: customerName,
              );
              if (stacked) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    balanceField,
                    SizedBox(height: 12.h),
                    nameField,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: balanceField),
                  SizedBox(width: 12.w),
                  Expanded(child: nameField),
                ],
              );
            },
          ),
          if (movementCount > 0) ...[
            SizedBox(height: 12.h),
            Divider(height: 1, color: const Color(0xFFD8DEE6)),
            SizedBox(height: 10.h),
            Text(
              '$movementCount حركة',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: AppFonts.dinNextArabic,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.accent,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryField extends StatelessWidget {
  const _SummaryField({
    required this.label,
    required this.value,
    this.emphasizeValue = false,
  });

  final String label;
  final String value;
  final bool emphasizeValue;

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
            fontWeight: FontWeight.w700,
            color: const Color(0xFF6B7280),
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFD5DDE6)),
          ),
          child: Text(
            value,
            textAlign: TextAlign.right,
            maxLines: emphasizeValue ? 1 : 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              fontSize: emphasizeValue ? 18.sp : 14.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF032F64),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatementMovementCard extends StatelessWidget {
  const _StatementMovementCard({required this.row});

  final Map<String, dynamic> row;

  String get _narrative {
    final ar = _StatementFormat.value(row['narrativeAr']);
    if (ar != '—') return ar;
    return _StatementFormat.value(row['narrativeEn']);
  }

  @override
  Widget build(BuildContext context) {
    final received = _StatementFormat.amount(row['amtCr']);
    final paid = _StatementFormat.amount(row['amtDr']);
    final refNo = _StatementFormat.value(row['oprno']);
    final receiveDate = _StatementFormat.value(row['appdate']);
    final refDate = _StatementFormat.value(row['valdate']);

    return Container(
      clipBehavior: Clip.antiAlias,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            color: const Color(0xFFE7F3FC),
            child: Text(
              _narrative,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: AppFonts.dinNextArabic,
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF032F64),
                height: 1.35,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _MiniField(
                        label: 'تاريخ الإستلام',
                        value: receiveDate,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _MiniField(
                        label: 'التاريخ المرجعي',
                        value: refDate,
                      ),
                    ),
                  ],
                ),
                if (refNo != '—') ...[
                  SizedBox(height: 10.h),
                  _MiniField(label: 'الرقم المرجعي', value: refNo),
                ],
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: _AmountTile(
                        label: 'القيمة المستلمة',
                        value: received,
                        tint: const Color(0xFF0D7A4E),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _AmountTile(
                        label: 'القيمة المسددة',
                        value: paid,
                        tint: const Color(0xFF032F64),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniField extends StatelessWidget {
  const _MiniField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value == '—') return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: AppFonts.dinNextArabic,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF9AA3AE),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: AppFonts.dinNextArabic,
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2C2C2C),
          ),
        ),
      ],
    );
  }
}

class _AmountTile extends StatelessWidget {
  const _AmountTile({
    required this.label,
    required this.value,
    required this.tint,
  });

  final String label;
  final String value;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final display = value == '—' ? '0' : value;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: tint.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: tint,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            display,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
              color: tint,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatementError extends StatelessWidget {
  const _StatementError({required this.message, required this.onRetry});

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
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: AppFonts.dinNextArabic),
            ),
            SizedBox(height: 12.h),
            FlowActionButton(
              label: 'إعادة المحاولة',
              enabled: true,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatementFormat {
  static String value(dynamic v) {
    if (v == null || v == 'null') return '—';
    final t = '$v'.trim();
    return t.isEmpty ? '—' : t;
  }

  static String amount(dynamic v) {
    final t = value(v);
    if (t == '—') return '—';
    final n = num.tryParse(t.replaceAll(',', ''));
    if (n == null) return t;
    if (n == 0) return '0';
    return t;
  }

  static List<Map<String, dynamic>> rows(dynamic raw) {
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map) Map<String, dynamic>.from(item),
    ];
  }
}
