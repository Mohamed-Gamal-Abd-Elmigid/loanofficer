import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fund_lookups_api.dart';
import 'package:loanofficer/core/api/fund_track_api.dart';
import 'package:loanofficer/core/api/inquiry_lookups_api.dart';
import 'package:loanofficer/core/models/inquiry_search_filters.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';

Future<InquirySearchFilters?> showInquiryFilterSheet({
  required BuildContext context,
  required InquirySearchFilters initial,
  required bool branchLocked,
  int? lockedBranchCode,
}) {
  return showModalBottomSheet<InquirySearchFilters>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useSafeArea: true,
    builder: (context) => _InquiryFilterSheet(
      initial: initial,
      branchLocked: branchLocked,
      lockedBranchCode: lockedBranchCode,
    ),
  );
}

class _InquiryFilterSheet extends StatefulWidget {
  const _InquiryFilterSheet({
    required this.initial,
    required this.branchLocked,
    this.lockedBranchCode,
  });

  final InquirySearchFilters initial;
  final bool branchLocked;
  final int? lockedBranchCode;

  @override
  State<_InquiryFilterSheet> createState() => _InquiryFilterSheetState();
}

class _InquiryFilterSheetState extends State<_InquiryFilterSheet> {
  final _lookups = InquiryLookupsApi();

  late String? _status;
  late String? _prodType;
  late String? _loanType;
  late String? _regionalArea;
  late int? _brcode;
  late String? _loCode;
  late String? _fromIssueDate;
  late String? _toIssueDate;

  late final TextEditingController _fromApprove;
  late final TextEditingController _toApprove;
  late final TextEditingController _fromBal;
  late final TextEditingController _toBal;
  late final TextEditingController _fromLate;
  late final TextEditingController _toLate;

  late String? _offloading;
  late String? _legal;

  List<FundLookupItem> _statuses = const [];
  List<InquiryOption<String>> _products = const [];
  List<InquiryOption<String>> _loanTypes = const [];
  List<InquiryOption<String>> _regions = const [];
  List<InquiryOption<int>> _branches = const [];
  List<BranchUser> _officers = const [];
  List<InquiryOption<String>> _yesNo = const [];

  String? _loadError;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _status = initial.status;
    _prodType = initial.prodType;
    _loanType = initial.loanType;
    _regionalArea = initial.regionalArea;
    _brcode = widget.branchLocked ? widget.lockedBranchCode : initial.brcode;
    _loCode = initial.loCode;
    _fromIssueDate = initial.fromIssueDate;
    _toIssueDate = initial.toIssueDate;
    _offloading = initial.offloadingBatchId;
    _legal = initial.legalAction;
    _fromApprove = TextEditingController(text: initial.fromApproveValue ?? '');
    _toApprove = TextEditingController(text: initial.toApproveValue ?? '');
    _fromBal = TextEditingController(text: initial.fromBalValue ?? '');
    _toBal = TextEditingController(text: initial.toBalValue ?? '');
    _fromLate = TextEditingController(text: initial.fromNoLateDays ?? '');
    _toLate = TextEditingController(text: initial.toNoLateDays ?? '');
    _bootstrap();
  }

  @override
  void dispose() {
    _fromApprove.dispose();
    _toApprove.dispose();
    _fromBal.dispose();
    _toBal.dispose();
    _fromLate.dispose();
    _toLate.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    try {
      final results = await Future.wait([
        _lookups.fundStatuses(),
        _lookups.productTypes(),
        _lookups.regionalAreas(),
        _lookups.branches(),
        _lookups.yesNo(),
      ]);
      if (!mounted) return;
      setState(() {
        _statuses = results[0] as List<FundLookupItem>;
        _products = results[1] as List<InquiryOption<String>>;
        _regions = results[2] as List<InquiryOption<String>>;
        _branches = results[3] as List<InquiryOption<int>>;
        _yesNo = results[4] as List<InquiryOption<String>>;
        _loading = false;
      });
      if (_prodType != null && _prodType!.isNotEmpty) {
        await _loadLoanTypes(_prodType!);
      }
      if (_brcode != null && _brcode! > 0 && !widget.branchLocked) {
        await _loadOfficers(_brcode!);
      } else if (widget.branchLocked && widget.lockedBranchCode != null) {
        await _loadOfficers(widget.lockedBranchCode!);
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = apiErrorMessage(error);
        _loading = false;
      });
    }
  }

  Future<void> _loadLoanTypes(String prodType) async {
    try {
      final list = await _lookups.loanTypesByProduct(prodType);
      if (!mounted) return;
      setState(() => _loanTypes = list);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loanTypes = const [];
        _loanType = null;
      });
    }
  }

  Future<void> _loadOfficers(int brcode) async {
    try {
      final list = await _lookups.loanOfficersByBranch(brcode);
      if (!mounted) return;
      setState(() => _officers = list);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _officers = const [];
        _loCode = null;
      });
    }
  }

  InquirySearchFilters _buildResult() {
    String? trim(TextEditingController c) {
      final t = c.text.trim();
      return t.isEmpty ? null : t;
    }

    return InquirySearchFilters(
      status: _status,
      prodType: _prodType,
      loanType: _loanType,
      regionalArea: _regionalArea,
      brcode: _brcode,
      loCode: _loCode,
      fromIssueDate: _fromIssueDate,
      toIssueDate: _toIssueDate,
      fromApproveValue: trim(_fromApprove),
      toApproveValue: trim(_toApprove),
      fromBalValue: trim(_fromBal),
      toBalValue: trim(_toBal),
      fromNoLateDays: trim(_fromLate),
      toNoLateDays: trim(_toLate),
      offloadingBatchId: _offloading,
      legalAction: _legal,
    );
  }

  void _clear() {
    setState(() {
      _status = null;
      _prodType = null;
      _loanType = null;
      _regionalArea = null;
      _brcode = widget.branchLocked ? widget.lockedBranchCode : null;
      _loCode = null;
      _fromIssueDate = null;
      _toIssueDate = null;
      _offloading = null;
      _legal = null;
      _loanTypes = const [];
      _fromApprove.clear();
      _toApprove.clear();
      _fromBal.clear();
      _toBal.clear();
      _fromLate.clear();
      _toLate.clear();
    });
  }

  void _confirm() => Navigator.pop(context, _buildResult());

  Future<void> _pickOption<T>({
    required String title,
    required List<InquiryOption<T>> options,
    required T? current,
    required ValueChanged<T?> onPicked,
    bool clearable = true,
  }) async {
    final picked = await showFlowOptionSheet<T>(
      context: context,
      title: title,
      current: current,
      clearable: clearable,
      options: [
        for (final o in options) FlowPickerOption(value: o.value, label: o.label),
      ],
    );
    if (!mounted || picked == current) return;
    onPicked(picked);
  }

  Future<void> _pickStatus() async {
    final options = [
      for (final s in _statuses)
        InquiryOption(value: s.code, label: s.nameAr),
    ];
    await _pickOption<String>(
      title: 'حالة التمويل',
      options: options,
      current: _status,
      onPicked: (v) => setState(() => _status = v),
    );
  }

  Future<void> _pickProduct() async {
    await _pickOption<String>(
      title: 'نوع المنتج',
      options: _products,
      current: _prodType,
      onPicked: (v) async {
        setState(() {
          _prodType = v;
          _loanType = null;
          _loanTypes = const [];
        });
        if (v != null && v.isNotEmpty) await _loadLoanTypes(v);
      },
    );
  }

  Future<void> _pickLoanType() async {
    if (_prodType == null || _loanTypes.isEmpty) return;
    await _pickOption<String>(
      title: 'نوع التمويل',
      options: _loanTypes,
      current: _loanType,
      onPicked: (v) => setState(() => _loanType = v),
    );
  }

  Future<void> _pickRegion() async {
    await _pickOption<String>(
      title: 'المنطقة',
      options: _regions,
      current: _regionalArea,
      onPicked: (v) => setState(() => _regionalArea = v),
    );
  }

  Future<void> _pickBranch() async {
    if (widget.branchLocked) return;
    await _pickOption<int>(
      title: 'الفرع',
      options: _branches,
      current: _brcode,
      onPicked: (v) async {
        setState(() {
          _brcode = v;
          _loCode = null;
          _officers = const [];
        });
        if (v != null && v > 0) await _loadOfficers(v);
      },
    );
  }

  Future<void> _pickOfficer() async {
    if (_officers.isEmpty) return;
    final options = [
      for (final u in _officers)
        InquiryOption(value: u.usrno, label: u.label),
    ];
    await _pickOption<String>(
      title: 'موظف التمويل',
      options: options,
      current: _loCode,
      onPicked: (v) => setState(() => _loCode = v),
    );
  }

  Future<void> _pickYesNo(String title, String? current, ValueChanged<String?> set) async {
    await _pickOption<String>(
      title: title,
      options: _yesNo,
      current: current,
      onPicked: set,
    );
  }

  Future<void> _pickDate(bool from) async {
    final picked = await pickFlowDate(
      context,
      currentValue: from ? _fromIssueDate : _toIssueDate,
      title: from ? 'تاريخ الإصدار من' : 'تاريخ الإصدار إلى',
    );
    if (picked == null) return;
    setState(() {
      if (from) {
        _fromIssueDate = picked;
      } else {
        _toIssueDate = picked;
      }
    });
  }

  String _labelFor<T>(List<InquiryOption<T>> options, T? value) {
    if (value == null) return '';
    for (final o in options) {
      if (o.value == value) return o.label;
    }
    return '$value';
  }

  String _statusLabel() {
    if (_status == null) return '';
    for (final s in _statuses) {
      if (s.code == _status) return s.nameAr;
    }
    return _status!;
  }

  String _branchLabel() {
    if (_brcode == null) return '';
    return _labelFor(_branches, _brcode);
  }

  String _officerLabel() {
    if (_loCode == null) return '';
    for (final u in _officers) {
      if (u.usrno == _loCode) return u.label;
    }
    return _loCode!;
  }

  String _yesNoLabel(String? code) {
    if (code == null) return '';
    for (final o in _yesNo) {
      if (o.value == code) return o.label;
    }
    return code;
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final maxH = MediaQuery.sizeOf(context).height * 0.88;
    return SizedBox(
      height: maxH,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              textDirection: TextDirection.rtl,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'إغلاق',
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.close_rounded,
                    size: 26.r,
                    color: const Color(0xFF032F64),
                  ),
                ),
                Expanded(
                  child: Text(
                    'تصفية متقدمة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.dinNextArabic,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF032F64),
                    ),
                  ),
                ),
                SizedBox(width: 48.w),
              ],
            ),
            SizedBox(height: 4.h),
            if (_loading)
              Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_loadError != null)
              Expanded(
                child: Center(
                  child: Text(_loadError!, textAlign: TextAlign.center),
                ),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                    FlowChoiceField(
                      label: 'حالة التمويل',
                      value: _statusLabel(),
                      hint: 'اختر الحالة',
                      onTap: _pickStatus,
                    ),
                    SizedBox(height: 10.h),
                    FlowChoiceField(
                      label: 'نوع المنتج',
                      value: _labelFor(_products, _prodType),
                      hint: 'اختر المنتج',
                      onTap: _pickProduct,
                    ),
                    SizedBox(height: 10.h),
                    FlowChoiceField(
                      label: 'نوع التمويل',
                      value: _labelFor(_loanTypes, _loanType),
                      hint: 'اختر نوع التمويل',
                      locked: _prodType == null || _loanTypes.isEmpty,
                      onTap: _pickLoanType,
                    ),
                    SizedBox(height: 10.h),
                    FlowChoiceField(
                      label: 'المنطقة',
                      value: _labelFor(_regions, _regionalArea),
                      hint: 'اختر المنطقة',
                      onTap: _pickRegion,
                    ),
                    SizedBox(height: 10.h),
                    FlowChoiceField(
                      label: 'الفرع',
                      value: _branchLabel(),
                      hint: 'اختر الفرع',
                      locked: widget.branchLocked,
                      onTap: _pickBranch,
                    ),
                    SizedBox(height: 10.h),
                    FlowChoiceField(
                      label: 'موظف التمويل',
                      value: _officerLabel(),
                      hint: 'اختر الموظف',
                      locked: _officers.isEmpty,
                      onTap: _pickOfficer,
                    ),
                    SizedBox(height: 10.h),
                    FlowChoiceField(
                      label: 'تاريخ الصرف من',
                      value: _fromIssueDate ?? '',
                      hint: '00/00/0000',
                      onTap: () => _pickDate(true),
                    ),
                    SizedBox(height: 10.h),
                    FlowChoiceField(
                      label: 'تاريخ الصرف إلى',
                      value: _toIssueDate ?? '',
                      hint: '00/00/0000',
                      onTap: () => _pickDate(false),
                    ),
                    SizedBox(height: 10.h),
                    _rangeFields(
                      'قيمة الموافقة',
                      _fromApprove,
                      _toApprove,
                    ),
                    SizedBox(height: 10.h),
                    _rangeFields('الرصيد', _fromBal, _toBal),
                    SizedBox(height: 10.h),
                    _rangeFields(
                      'أيام التأخير',
                      _fromLate,
                      _toLate,
                      digitsOnly: true,
                    ),
                    SizedBox(height: 10.h),
                    FlowChoiceField(
                      label: 'دفعة التحويل',
                      value: _yesNoLabel(_offloading),
                      hint: 'اختر',
                      onTap: () => _pickYesNo(
                        'دفعة التحويل',
                        _offloading,
                        (v) => setState(() => _offloading = v),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    FlowChoiceField(
                      label: 'قضايا',
                      value: _yesNoLabel(_legal),
                      hint: 'اختر',
                      onTap: () => _pickYesNo(
                        'قضايا',
                        _legal,
                        (v) => setState(() => _legal = v),
                      ),
                    ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 12.h),
            Row(
              textDirection: TextDirection.rtl,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52.h,
                    child: OutlinedButton(
                      onPressed: _loading ? null : _clear,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        textStyle: TextStyle(
                          fontFamily: AppFonts.dinNextArabic,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('مسح'),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: FlowActionButton(
                    label: 'تطبيق',
                    enabled: !_loading && _loadError == null,
                    onPressed: _confirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _rangeFields(
    String label,
    TextEditingController from,
    TextEditingController to, {
    bool digitsOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FlowLabel(label),
        SizedBox(height: 6.h),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: FlowTextField(
                controller: from,
                hint: 'من',
                keyboardType: TextInputType.number,
                digitsOnly: digitsOnly,
                onChanged: (_) {},
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: FlowTextField(
                controller: to,
                hint: 'إلى',
                keyboardType: TextInputType.number,
                digitsOnly: digitsOnly,
                onChanged: (_) {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}
