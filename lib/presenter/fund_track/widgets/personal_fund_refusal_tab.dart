import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fund_lookups_api.dart';
import 'package:loanofficer/core/api/personal_fund_api.dart';
import 'package:loanofficer/core/models/fund_workflow_authority.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';
import 'package:loanofficer/presenter/fund_track/widgets/personal_fund_shared_widgets.dart';
import 'package:loanofficer/presenter/fund_track/widgets/personal_fund_tab_chrome.dart';

class RefusalEditorRow {
  RefusalEditorRow({
    required this.itemId,
    required this.rejectedComment,
    required this.solvedComment,
    required this.status,
    this.rejectId,
    this.seqNo,
  });

  String? itemId;
  final TextEditingController rejectedComment;
  final TextEditingController solvedComment;
  String? status;
  final String? rejectId;
  final String? seqNo;

  factory RefusalEditorRow.fromApi(Map<String, dynamic> map) {
    return RefusalEditorRow(
      itemId: '${map['itemId'] ?? ''}'.trim().isEmpty
          ? null
          : '${map['itemId']}',
      rejectedComment: TextEditingController(
        text: '${map['rejectedComment'] ?? ''}',
      ),
      solvedComment: TextEditingController(
        text: '${map['solvedComment'] ?? ''}',
      ),
      status: '${map['status'] ?? ''}'.trim().isEmpty ? 'O' : '${map['status']}',
      rejectId: map['rejectId']?.toString(),
      seqNo: map['seqNo']?.toString(),
    );
  }

  Map<String, dynamic> toPayload() {
    return {
      'itemId': itemId,
      'rejectedComment': rejectedComment.text.trim(),
      'solvedComment': solvedComment.text.trim(),
      'status': status ?? 'O',
      if (rejectId != null) 'rejectId': rejectId,
      if (seqNo != null) 'seqNo': seqNo,
      'createDate': _today(),
      'ids': const <int>[],
    };
  }

  static String _today() {
    final n = DateTime.now();
    String p(int v) => v.toString().padLeft(2, '0');
    return '${p(n.day)}/${p(n.month)}/${n.year}';
  }

  void dispose() {
    rejectedComment.dispose();
    solvedComment.dispose();
  }
}

class PersonalFundRefusalTab extends StatefulWidget {
  const PersonalFundRefusalTab({
    super.key,
    required this.ticketId,
    required this.authority,
    required this.api,
    required this.initialRows,
    required this.refusedFlow,
    required this.onReload,
  });

  final String ticketId;
  final FundWorkflowAuthority authority;
  final PersonalFundApi api;
  final List<Map<String, dynamic>> initialRows;
  final bool refusedFlow;
  final Future<void> Function() onReload;

  @override
  State<PersonalFundRefusalTab> createState() => _PersonalFundRefusalTabState();
}

class _PersonalFundRefusalTabState extends State<PersonalFundRefusalTab> {
  final _lookups = FundLookupsApi();
  List<RefusalEditorRow> _rows = [];
  List<FundLookupItem> _reasons = [];
  List<FundLookupItem> _statuses = [];

  bool get _canEdit =>
      widget.authority.tabEditable('RT_REJECTS') && !widget.refusedFlow;

  @override
  void initState() {
    super.initState();
    _rows = widget.initialRows.map(RefusalEditorRow.fromApi).toList();
    _loadLookups();
  }

  @override
  void didUpdateWidget(covariant PersonalFundRefusalTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialRows != widget.initialRows) {
      for (final r in _rows) {
        r.dispose();
      }
      _rows = widget.initialRows.map(RefusalEditorRow.fromApi).toList();
    }
  }

  @override
  void dispose() {
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  Future<void> _loadLookups() async {
    try {
      final reasons = await _lookups.refuseReasons();
      final statuses = await _lookups.refuseStatus();
      if (!mounted) return;
      setState(() {
        _reasons = reasons;
        _statuses = statuses;
      });
    } catch (_) {}
  }

  String _reasonLabel(String? code) {
    if (code == null) return '—';
    for (final r in _reasons) {
      if (r.code == code) return r.nameAr;
    }
    return code;
  }

  String _statusLabel(String? code) {
    if (code == null) return '—';
    for (final s in _statuses) {
      if (s.code == code) return s.nameAr;
    }
    return code;
  }

  void _addRow() {
    setState(() {
      _rows.insert(
        0,
        RefusalEditorRow(
          itemId: null,
          rejectedComment: TextEditingController(),
          solvedComment: TextEditingController(),
          status: 'O',
        ),
      );
    });
  }

  Future<void> _save() async {
    for (final row in _rows) {
      if (row.itemId == null || row.rejectedComment.text.trim().isEmpty) {
        _toast('يرجى إكمال أسباب الرفض');
        return;
      }
    }
    try {
      await widget.api.updateRejection(
        ticketId: widget.ticketId,
        data: _rows.map((e) => e.toPayload()).toList(),
      );
      _toast('تم حفظ أسباب الرفض');
      await widget.onReload();
    } catch (error) {
      _toast(apiErrorMessage(error));
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.authority.refusalTab) {
      return ColoredBox(
        color: AppColors.page,
        child: PersonalFundEmptyState(
          icon: personalFundTabIcon('refuse'),
          message: 'أسباب الرفض غير متاحة',
          accent: personalFundTabAccent('refuse'),
        ),
      );
    }
    return PersonalFundTabPage(
      tabId: 'refuse',
      title: 'أسباب الرفض',
      children: [
        if (widget.refusedFlow)
          personalFundReadonlyBanner('الطلب مرفوض — العرض فقط')
        else if (!_canEdit)
          personalFundReadonlyBanner('عرض أسباب الرفض فقط'),
        if (_rows.isEmpty)
          PersonalFundEmptyState(
            icon: Icons.check_circle_outline,
            message: 'لا توجد أسباب رفض مسجلة',
            accent: personalFundTabAccent('refuse'),
          )
        else
          for (var i = 0; i < _rows.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _rowCard(i),
            ),
        if (_canEdit)
          PersonalFundFormShell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _addRow,
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('إضافة سبب'),
                  ),
                ),
                FlowActionButton(
                  label: 'حفظ أسباب الرفض',
                  enabled: true,
                  onPressed: _save,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _rowCard(int index) {
    final row = _rows[index];
    final editable = _canEdit &&
        widget.authority.controlEditable('RT_REJECTS', 'refuseReasons');
    final statusLabel = _statusLabel(row.status);
    final open = row.status == 'O' || row.status == 'OPEN';

    if (!editable) {
      return PersonalFundInfoCard(
        title: 'سبب الرفض ${index + 1}',
        accent: AppColors.primary,
        lines: [
          PersonalFundLine('بند الرفض', _reasonLabel(row.itemId)),
          if (row.rejectedComment.text.trim().isNotEmpty)
            PersonalFundLine('تعليق الرفض', row.rejectedComment.text.trim()),
          if (row.solvedComment.text.trim().isNotEmpty)
            PersonalFundLine('تعليق المعالجة', row.solvedComment.text.trim()),
          PersonalFundLine(
            'الحالة',
            statusLabel,
            valueColor: open ? AppColors.primary : AppColors.accent,
          ),
        ],
      );
    }

    return PersonalFundFormShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(Icons.report_gmailerrorred_outlined,
                  color: AppColors.primary, size: 22.r),
              SizedBox(width: 8.w),
              Text(
                'سبب ${index + 1}',
                style: TextStyle(
                  fontFamily: AppFonts.dinNextArabic,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.iconBubble,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: open ? AppColors.primary : AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          DropdownButtonFormField<String>(
            value: row.itemId,
            decoration: InputDecoration(
              labelText: 'بند الرفض',
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            items: [
              for (final r in _reasons)
                DropdownMenuItem(value: r.code, child: Text(r.nameAr)),
            ],
            onChanged: (v) => setState(() => row.itemId = v),
          ),
          SizedBox(height: 10.h),
          FlowTextField(
            controller: row.rejectedComment,
            hint: 'تعليق الرفض',
            onChanged: (_) {},
          ),
          SizedBox(height: 10.h),
          FlowTextField(
            controller: row.solvedComment,
            hint: 'تعليق المعالجة',
            onChanged: (_) {},
          ),
          SizedBox(height: 10.h),
          DropdownButtonFormField<String>(
            value: row.status,
            decoration: InputDecoration(
              labelText: 'الحالة',
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            items: [
              for (final s in _statuses)
                DropdownMenuItem(value: s.code, child: Text(s.nameAr)),
            ],
            onChanged: (v) => setState(() => row.status = v),
          ),
        ],
      ),
    );
  }
}
