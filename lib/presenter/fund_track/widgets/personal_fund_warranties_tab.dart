import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/personal_fund_api.dart';
import 'package:loanofficer/core/models/fund_workflow_authority.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/presenter/fund_track/model/grantor_editor_row.dart';
import 'package:loanofficer/presenter/fund_track/widgets/personal_fund_shared_widgets.dart';
import 'package:loanofficer/presenter/fund_track/widgets/personal_fund_tab_chrome.dart';

class PersonalFundWarrantiesTab extends StatefulWidget {
  const PersonalFundWarrantiesTab({
    super.key,
    required this.serviceId,
    required this.custno,
    required this.applicantIdno,
    required this.authority,
    required this.api,
    required this.initialGrantors,
    required this.initialInkind,
    required this.onReload,
    this.loading = false,
  });

  final String serviceId;
  final String custno;
  final String applicantIdno;
  final FundWorkflowAuthority authority;
  final PersonalFundApi api;
  final List<Map<String, dynamic>> initialGrantors;
  final List<Map<String, dynamic>> initialInkind;
  final bool loading;
  final Future<void> Function() onReload;

  @override
  State<PersonalFundWarrantiesTab> createState() =>
      _PersonalFundWarrantiesTabState();
}

class _PersonalFundWarrantiesTabState extends State<PersonalFundWarrantiesTab> {
  List<GrantorEditorRow> _rows = [];

  @override
  void initState() {
    super.initState();
    _rows = widget.initialGrantors.map(GrantorEditorRow.fromApi).toList();
  }

  @override
  void didUpdateWidget(covariant PersonalFundWarrantiesTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialGrantors != widget.initialGrantors) {
      for (final r in _rows) {
        r.dispose();
      }
      _rows = widget.initialGrantors.map(GrantorEditorRow.fromApi).toList();
    }
  }

  @override
  void dispose() {
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  String _relationLabel(GrantorEditorRow row, Map<String, dynamic>? raw) {
    final fromApi = raw?['relationTypeNameAr'] ?? raw?['relationNameAr'];
    if (fromApi != null && '$fromApi'.trim().isNotEmpty) return '$fromApi';
    return row.relationType ?? '—';
  }

  Map<String, dynamic>? _rawAt(int index) {
    if (index < 0 || index >= widget.initialGrantors.length) return null;
    return widget.initialGrantors[index];
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.authority.warrantiesTab) {
      return personalFundScrollableEmpty(
        storageKey: 'personal-fund-tab-warr-empty',
        child: PersonalFundEmptyState(
          icon: personalFundTabIcon('warr'),
          message: 'الضمانات غير متاحة في هذه المرحلة',
          accent: personalFundTabAccent('warr'),
        ),
      );
    }
    if (widget.loading) {
      return personalFundScrollableEmpty(
        storageKey: 'personal-fund-tab-warr-loading',
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }
    return PersonalFundTabPage(
      tabId: 'warr',
      title: 'الضمانات',
      children: [
        personalFundReadonlyBanner('عرض بيانات الضامن فقط — بدون تعديل'),
        if (_rows.isEmpty)
          PersonalFundEmptyState(
            icon: Icons.person_off_outlined,
            message: 'لا يوجد ضامن مسجل على هذا الطلب',
            accent: personalFundTabAccent('warr'),
          )
        else
          for (var i = 0; i < _rows.length; i++) ...[
            _grantorViewCard(i),
            if (i < _rows.length - 1) SizedBox(height: 12.h),
          ],
      ],
    );
  }

  Widget _grantorViewCard(int index) {
    final row = _rows[index];
    final raw = _rawAt(index);
    final name = row.custName.text.trim();
    final id = row.grantIdno.text.trim();
    final title = _rows.length > 1 ? 'ضامن ${index + 1}' : 'الضامن';
    return PersonalFundFormShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.iconBubble,
                child: Icon(
                  Icons.person,
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
                      title,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: AppFonts.dinNextArabic,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.fieldLabel,
                      ),
                    ),
                    Text(
                      name.isEmpty ? '—' : name,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: AppFonts.dinNextArabic,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                PersonalFundLine('الرقم القومي', id),
                PersonalFundLine('صلة القرابة', _relationLabel(row, raw)),
                if (row.orderby.text.trim().isNotEmpty)
                  PersonalFundLine('ترتيب الضامن', row.orderby.text.trim()),
                if (raw?['grantCustNo'] != null &&
                    '${raw!['grantCustNo']}'.trim().isNotEmpty)
                  PersonalFundLine('رقم العميل', '${raw['grantCustNo']}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
