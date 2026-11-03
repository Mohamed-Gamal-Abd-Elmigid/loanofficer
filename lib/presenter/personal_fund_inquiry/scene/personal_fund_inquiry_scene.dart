import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fund_track_api.dart';
import 'package:loanofficer/core/api/fmc_session.dart';
import 'package:loanofficer/core/models/inquiry_search_filters.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/core/validation/fmc_validation.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';
import 'package:loanofficer/presenter/fund_track/scene/fund_track_detail_scene.dart';
import 'package:loanofficer/presenter/personal_fund_inquiry/widgets/inquiry_filter_sheet.dart';
/// Fusion «استعلام تمويل فردي» — web `geteAllServiceQuery`: full list, UI pagination.
class PersonalFundInquiryScene extends StatefulWidget {
  const PersonalFundInquiryScene({
    super.key,
    this.initialCustId,
    this.initialServiceId,
    this.embedInShell = false,
  });

  final String? initialCustId;
  final String? initialServiceId;
  final bool embedInShell;

  @override
  State<PersonalFundInquiryScene> createState() =>
      _PersonalFundInquirySceneState();
}

class _PersonalFundInquirySceneState extends State<PersonalFundInquiryScene> {
  final _api = FundTrackApi();
  final _custId = TextEditingController();
  final _serviceId = TextEditingController();
  final _grantIdno = TextEditingController();
  InquirySearchFilters _filters = const InquirySearchFilters();

  List<FundTrackRow> _allRows = [];
  FundTrackRow? _selectedRow;
  bool _loading = false;
  String? _error;
  int _pageIndex = 0;
  int _pageSize = 10;
  static const _pageSizes = [10, 25, 50];
  bool _initialLoadDone = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialCustId != null) {
      _custId.text = widget.initialCustId!.trim();
    }
    if (widget.initialServiceId != null) {
      _serviceId.text = widget.initialServiceId!.trim();
    }
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _runSearch(resetPage: true, initial: true),
    );
  }

  @override
  void dispose() {
    _custId.dispose();
    _serviceId.dispose();
    _grantIdno.dispose();
    super.dispose();
  }

  List<FundTrackRow> get _pageRows {
    if (_allRows.isEmpty) return const [];
    final start = _pageIndex * _pageSize;
    if (start >= _allRows.length) return const [];
    final end = (start + _pageSize).clamp(0, _allRows.length);
    return _allRows.sublist(start, end);
  }

  int get _totalRecords => _allRows.length;

  Future<void> _runSearch({bool resetPage = false, bool initial = false}) async {
    if (!initial) {
      final custErr = FmcValidation.fundTrackCustId(_custId.text);
      final svcErr = FmcValidation.fundTrackServiceId(_serviceId.text);
      final grantErr = FmcValidation.fundTrackCustId(_grantIdno.text);
      if (custErr != null || svcErr != null || grantErr != null) {
        _toast(FmcValidation.fillFormMessage);
        return;
      }
    }
    if (resetPage) _pageIndex = 0;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await _api.findInquiryServices(
        custIdno: _custId.text.trim(),
        serviceId: _serviceId.text.trim(),
        grantIdno1: _grantIdno.text.trim(),
        filters: _filters.hasAny ? _filters : null,
      );
      if (!mounted) return;
      setState(() {
        _allRows = page.rows;
        if (_pageIndex * _pageSize >= _allRows.length) {
          _pageIndex = 0;
        }
        _loading = false;
        _initialLoadDone = true;
        _selectedRow = _pickDefaultRow(_pageRows);
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = apiErrorMessage(error);
        _allRows = [];
        _selectedRow = null;
        _initialLoadDone = true;
      });
    }
  }

  FundTrackRow? _pickDefaultRow(List<FundTrackRow> rows) {
    if (rows.isEmpty) return null;
    final filterService = _serviceId.text.trim();
    if (filterService.isNotEmpty) {
      for (final row in rows) {
        if (row.serviceId == filterService) return row;
      }
    }
    if (kIsWeb || rows.length == 1) return rows.first;
    return _selectedRow != null &&
            rows.any((r) => r.serviceId == _selectedRow!.serviceId)
        ? rows.firstWhere((r) => r.serviceId == _selectedRow!.serviceId)
        : null;
  }

  void _selectRow(FundTrackRow row) {
    setState(() => _selectedRow = row);
    if (!kIsWeb) {
      Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => FundTrackDetailScene(
            serviceId: row.serviceId,
            inquiryRow: row,
          ),
        ),
      );
    }
  }

  void _submitSearch() => _runSearch(resetPage: true);

  Future<void> _openAdvancedFilters() async {
    final login = await FmcSession.instance.readLogin();
    if (!mounted) return;
    final hq = _sessionInt(login?['hq']);
    final brCode = _sessionInt(login?['brCode']);
    final branchLocked = hq != brCode && brCode != 0;
    final result = await showInquiryFilterSheet(
      context: context,
      initial: _filters,
      branchLocked: branchLocked,
      lockedBranchCode: branchLocked ? brCode : null,
    );
    if (result == null || !mounted) return;
    setState(() => _filters = result);
    await _runSearch(resetPage: true);
  }

  static int _sessionInt(dynamic raw) {
    if (raw is num) return raw.toInt();
    return int.tryParse('$raw') ?? 0;
  }

  void _goToPreviousPage() {
    if (_pageIndex <= 0 || _loading) return;
    setState(() {
      _pageIndex--;
      _selectedRow = _pickDefaultRow(_pageRows);
    });
  }

  void _goToNextPage() {
    if (_loading) return;
    final pageCount = _totalRecords == 0
        ? 1
        : ((_totalRecords - 1) ~/ _pageSize) + 1;
    if (_pageIndex >= pageCount - 1) return;
    setState(() {
      _pageIndex++;
      _selectedRow = _pickDefaultRow(_pageRows);
    });
  }

  void _onPageSizeChanged(int size) {
    setState(() {
      _pageSize = size;
      _pageIndex = 0;
      _selectedRow = _pickDefaultRow(_pageRows);
    });
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final total = _totalRecords;
    final pageCount = total == 0 ? 1 : ((total - 1) ~/ _pageSize) + 1;
    final pageRows = _pageRows;

    return FlowScaffold(
      embedInShell: widget.embedInShell,
      pageTitle: widget.embedInShell ? null : 'استعلام تمويل فردي',
      pageIcon: Icons.manage_search_outlined,
      onBack: () => Navigator.of(context).pop(),
      body: ColoredBox(
        color: AppColors.page,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final showInlineReview =
                kIsWeb && constraints.maxWidth >= 720 && _selectedRow != null;
            final listBody = _buildListSection(
              total: total,
              pageCount: pageCount,
              pageRows: pageRows,
              showInlineReview: showInlineReview,
            );
            if (!showInlineReview) return listBody;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: listBody),
                VerticalDivider(width: 1.w, color: const Color(0xFFE4E9F0)),
                Expanded(
                  flex: 6,
                  child: ColoredBox(
                    color: AppColors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                          child: Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              Container(
                                width: 36.r,
                                height: 36.r,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.iconBubble,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(
                                  Icons.timeline,
                                  color: AppColors.accent,
                                  size: 20.r,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'متابعة الطلب',
                                style: TextStyle(
                                  fontFamily: AppFonts.dinNextArabic,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF032F64),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: FundTrackReviewPanel(
                            key: ValueKey(_selectedRow!.serviceId),
                            serviceId: _selectedRow!.serviceId,
                            inquiryRow: _selectedRow,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildListSection({
    required int total,
    required int pageCount,
    required List<FundTrackRow> pageRows,
    required bool showInlineReview,
  }) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      children: [
        _SearchCard(
          loading: _loading,
          custId: _custId,
          serviceId: _serviceId,
          grantIdno: _grantIdno,
          filtersActive: _filters.hasAny,
          onRefresh: () => _runSearch(initial: true),
          onSearch: _submitSearch,
          onFilters: _openAdvancedFilters,
        ),
        if (_initialLoadDone && !_loading && total > 0) ...[
          SizedBox(height: 12.h),
          _InfoBanner(
            message: kIsWeb
                ? 'تم تحميل الطلبات — اختر طلباً لعرض مراجعة الطلب'
                : 'تم تحميل الطلبات — اضغط متابعة الطلب لعرض المسار وخيارات الطلب',
          ),
        ],
        SizedBox(height: 16.h),
        if (_loading)
          _LoadingState()
        else if (_error != null)
          _ErrorState(message: _error!, onRetry: () => _runSearch(initial: true))
        else if (total == 0 && _initialLoadDone && _allRows.isEmpty)
          const _EmptyState()
        else if (_allRows.isNotEmpty) ...[
          for (var i = 0; i < pageRows.length; i++) ...[
            _InquiryCard(
              row: pageRows[i],
              selected: _selectedRow?.serviceId == pageRows[i].serviceId,
              onSeeDetails: () => _selectRow(pageRows[i]),
            ),
            if (i < pageRows.length - 1)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: const Color(0xFFE4E9F0),
                ),
              ),
          ],
          SizedBox(height: 16.h),
          _PaginationBar(
            pageIndex: _pageIndex,
            pageCount: pageCount,
            pageSize: _pageSize,
            totalRecords: total,
            pageSizes: _pageSizes,
            onPageSize: _onPageSizeChanged,
            onPrev: _goToPreviousPage,
            onNext: _goToNextPage,
          ),
        ],
      ],
    );
  }
}

class _SearchCard extends StatelessWidget {
  const _SearchCard({
    required this.loading,
    required this.custId,
    required this.serviceId,
    required this.grantIdno,
    required this.filtersActive,
    required this.onRefresh,
    required this.onSearch,
    required this.onFilters,
  });

  final bool loading;
  final TextEditingController custId;
  final TextEditingController serviceId;
  final TextEditingController grantIdno;
  final bool filtersActive;
  final VoidCallback onRefresh;
  final VoidCallback onSearch;
  final VoidCallback onFilters;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.iconBubble,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.search, color: AppColors.accent, size: 22.r),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'معايير البحث',
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF032F64),
                  ),
                ),
              ),
              IconButton(
                onPressed: loading ? null : onFilters,
                tooltip: 'تصفية متقدمة',
                icon: Badge(
                  isLabelVisible: filtersActive,
                  smallSize: 8.r,
                  child: Icon(
                    Icons.filter_list_rounded,
                    color: AppColors.accent,
                    size: 24.r,
                  ),
                ),
              ),
              IconButton(
                onPressed: loading ? null : onRefresh,
                tooltip: 'تحديث',
                icon: Icon(Icons.refresh_rounded, color: AppColors.accent, size: 24.r),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          const FlowLabel('رقم البطاقة'),
          SizedBox(height: 6.h),
          FlowTextField(
            controller: custId,
            hint: '14 رقم',
            digitsOnly: true,
            maxLength: 14,
            keyboardType: TextInputType.number,
            onChanged: (_) {},
            onSubmitted: (_) => onSearch(),
          ),
          SizedBox(height: 12.h),
          const FlowLabel('رقم التمويل'),
          SizedBox(height: 6.h),
          FlowTextField(
            controller: serviceId,
            hint: 'رقم التمويل',
            digitsOnly: true,
            keyboardType: TextInputType.number,
            onChanged: (_) {},
            onSubmitted: (_) => onSearch(),
          ),
          SizedBox(height: 12.h),
          const FlowLabel('رقم بطاقة الضامن'),
          SizedBox(height: 6.h),
          FlowTextField(
            controller: grantIdno,
            hint: '14 رقم (اختياري)',
            digitsOnly: true,
            maxLength: 14,
            keyboardType: TextInputType.number,
            onChanged: (_) {},
            onSubmitted: (_) => onSearch(),
          ),
          SizedBox(height: 16.h),
          FlowActionButton(
            label: 'بحث',
            enabled: !loading,
            onPressed: onSearch,
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F3FC),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFB8DCF5)),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20.r, color: AppColors.accent),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: AppFonts.dinNextArabic,
                color: const Color(0xFF032F64),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 48.h),
      child: Column(
        children: [
          SizedBox(
            width: 36.r,
            height: 36.r,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.accent,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'جاري تحميل النتائج...',
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              color: const Color(0xFF9AA3AE),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40.h),
      child: Column(
        children: [
          Container(
            width: 72.r,
            height: 72.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.iconBubble,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 36.r,
              color: AppColors.accent,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'لا توجد نتائج',
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF032F64),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'جرّب تعديل معايير البحث أو تحديث القائمة',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              color: const Color(0xFF9AA3AE),
              fontSize: 13.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: AppColors.primary, size: 32.r),
          SizedBox(height: 10.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              color: AppColors.primary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          SizedBox(height: 12.h),
          TextButton.icon(
            onPressed: onRetry,
            icon: Icon(Icons.refresh, size: 18.r, color: AppColors.accent),
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
    );
  }
}

class _InquiryCard extends StatelessWidget {
  const _InquiryCard({
    required this.row,
    required this.onSeeDetails,
    this.selected = false,
  });

  final FundTrackRow row;
  final VoidCallback onSeeDetails;
  final bool selected;

  static String _display(String value) {
    final text = value.trim();
    return text.isEmpty ? '—' : text;
  }

  @override
  Widget build(BuildContext context) {
    final row = this.row;
    final fundCode = row.serviceId.isNotEmpty ? row.serviceId : row.financeCode;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE8F4FC) : AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.cardBorder,
            width: selected ? 1.5 : 1,
          ),
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
            Text(
              _display(row.custName),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppFonts.dinNextArabic,
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF032F64),
                height: 1.35,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7FA),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE4E9F0)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _InquiryMetricTile(
                          label: 'كود التمويل',
                          value: _display(fundCode),
                          icon: Icons.numbers_rounded,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _InquiryMetricTile(
                          label: 'تاريخ الإصدار',
                          value: _display(row.issueDate),
                          icon: Icons.calendar_today_outlined,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: _InquiryMetricTile(
                          label: 'الرصيد القائم',
                          value: _display(row.currentBalance),
                          icon: Icons.account_balance_wallet_outlined,
                          emphasizeValue: true,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _InquiryMetricTile(
                          label: 'الرصيد المستحق',
                          value: _display(row.dueBalance),
                          icon: Icons.payments_outlined,
                          emphasizeValue: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: _InquiryMetricTile(
                          label: 'حالة التمويل',
                          value: _display(row.financeStatus),
                          icon: Icons.flag_outlined,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _InquiryMetricTile(
                          label: 'المنتج التمويلي',
                          value: _display(row.loanTypeName),
                          icon: Icons.category_outlined,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            _CompactRow(label: 'رقم البطاقة', value: row.custId),
            SizedBox(height: 12.h),
            SizedBox(
              width: double.infinity,
              height: 44.h,
              child: OutlinedButton.icon(
                onPressed: onSeeDetails,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  side: BorderSide(color: AppColors.accent.withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                icon: Icon(Icons.timeline_outlined, size: 20.r),
                label: Text(
                  'متابعة الطلب',
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            if (selected && kIsWeb) ...[
              SizedBox(height: 10.h),
              Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.accent, size: 18.r),
                  SizedBox(width: 6.w),
                  Text(
                    'محدد للمراجعة',
                    style: TextStyle(
                      fontFamily: AppFonts.dinNextArabic,
                      color: AppColors.accent,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InquiryMetricTile extends StatelessWidget {
  const _InquiryMetricTile({
    required this.label,
    required this.value,
    required this.icon,
    this.emphasizeValue = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool emphasizeValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE8EDF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: 16.r, color: AppColors.accent),
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              fontSize: emphasizeValue ? 15.sp : 14.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF032F64),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactRow extends StatelessWidget {
  const _CompactRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              fontSize: 12.sp,
              color: const Color(0xFF9AA3AE),
            ),
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              value.isEmpty ? '—' : value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: AppFonts.dinNextArabic,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF032F64),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.pageIndex,
    required this.pageCount,
    required this.pageSize,
    required this.totalRecords,
    required this.pageSizes,
    required this.onPageSize,
    required this.onPrev,
    required this.onNext,
  });

  final int pageIndex;
  final int pageCount;
  final int pageSize;
  final int totalRecords;
  final List<int> pageSizes;
  final ValueChanged<int> onPageSize;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFE4E9F0)),
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
          Text(
            'إجمالي النتائج: $totalRecords',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF032F64),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Text(
                'عدد الصفوف:',
                style: TextStyle(
                  fontFamily: AppFonts.dinNextArabic,
                  fontSize: 12.sp,
                  color: const Color(0xFF5C6F8A),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8.w),
              DropdownButton<int>(
                value: pageSize,
                underline: const SizedBox.shrink(),
                items: [
                  for (final s in pageSizes)
                    DropdownMenuItem(value: s, child: Text('$s')),
                ],
                onChanged: (v) {
                  if (v != null) onPageSize(v);
                },
              ),
              const Spacer(),
              IconButton(
                onPressed: pageIndex > 0 ? onPrev : null,
                icon: const Icon(Icons.chevron_right),
                color: AppColors.accent,
              ),
              Text(
                '${pageIndex + 1} / $pageCount',
                style: TextStyle(
                  fontFamily: AppFonts.dinNextArabic,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF032F64),
                ),
              ),
              IconButton(
                onPressed: pageIndex < pageCount - 1 ? onNext : null,
                icon: const Icon(Icons.chevron_left),
                color: AppColors.accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
