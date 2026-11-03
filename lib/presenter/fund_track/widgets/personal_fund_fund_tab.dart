import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/client_api.dart';
import 'package:loanofficer/core/api/funding_orders_api.dart';
import 'package:loanofficer/core/api/personal_fund_api.dart';
import 'package:loanofficer/core/models/fund_workflow_authority.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/core/validation/fmc_validation.dart';
import 'package:loanofficer/presenter/client_data/scene/client_data_scene.dart';
import 'package:loanofficer/presenter/establishment_data/scene/establishment_data_scene.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';
import 'package:loanofficer/presenter/fund_track/model/personal_fund_form_patch.dart';
import 'package:loanofficer/presenter/fund_track/widgets/personal_fund_shared_widgets.dart';
import 'package:loanofficer/presenter/fund_track/widgets/personal_fund_tab_chrome.dart';
import 'package:loanofficer/presenter/personal_fund_inquiry/widgets/inquiry_organization_profile.dart';

class PersonalFundFundTab extends StatefulWidget {
  const PersonalFundFundTab({
    super.key,
    required this.order,
    required this.fund,
    required this.patch,
    required this.authority,
    required this.reqAmount,
    required this.reqInstallments,
    required this.approvedAmount,
    required this.approvedInstallments,
    required this.saveComment,
    required this.api,
    required this.onSave,
    this.error,
  });

  final FundingOrderRow order;
  final Map<String, dynamic> fund;
  final PersonalFundFormPatch patch;
  final FundWorkflowAuthority authority;
  final TextEditingController reqAmount;
  final TextEditingController reqInstallments;
  final TextEditingController approvedAmount;
  final TextEditingController approvedInstallments;
  final TextEditingController saveComment;
  final PersonalFundApi api;
  final Future<void> Function() onSave;
  final String? error;

  @override
  State<PersonalFundFundTab> createState() => _PersonalFundFundTabState();
}

class _PersonalFundFundTabState extends State<PersonalFundFundTab> {
  final _clients = ClientApi();
  List<Map<String, dynamic>> _orgs = [];
  String? _selectedOrgId;

  bool get _orgRequired =>
      '${widget.fund['orgFlag'] ?? ''}'.trim().toUpperCase() == 'Y';

  static String _orgIdFromMap(Map<String, dynamic> org) {
    return '${org['orgId'] ?? org['id'] ?? ''}'.trim();
  }

  /// API may return duplicate `orgId` rows — Flutter dropdown requires unique values.
  List<Map<String, dynamic>> get _uniqueOrgs {
    final seen = <String>{};
    final out = <Map<String, dynamic>>[];
    for (final org in _orgs) {
      final id = _orgIdFromMap(org);
      if (id.isEmpty || seen.contains(id)) continue;
      seen.add(id);
      out.add(org);
    }
    return out;
  }

  String? get _dropdownOrgValue {
    final options = _uniqueOrgs;
    if (options.isEmpty) return null;
    final ids = options.map(_orgIdFromMap).toSet();
    final selected = _selectedOrgId?.trim();
    if (selected != null && selected.isNotEmpty && ids.contains(selected)) {
      return selected;
    }
    final fromFund = '${widget.fund['orgId'] ?? ''}'.trim();
    if (fromFund.isNotEmpty && ids.contains(fromFund)) return fromFund;
    if (options.length == 1) return _orgIdFromMap(options.first);
    return null;
  }

  @override
  void initState() {
    super.initState();
    _selectedOrgId = '${widget.fund['orgId'] ?? ''}'.trim().isEmpty
        ? null
        : '${widget.fund['orgId']}';
    _loadOrgs();
  }

  Future<void> _loadOrgs() async {
    final id = widget.patch.idno;
    if (id.length != 14) return;
    try {
      final rows = await widget.api.organizationsByIdno(id);
      if (!mounted) return;
      setState(() {
        _orgs = rows;
        final resolved = _dropdownOrgValue;
        if (resolved != null) _selectedOrgId = resolved;
      });
    } catch (_) {}
  }

  String? get _effectiveOrgId {
    final fromFund = '${widget.fund['orgId'] ?? ''}'.trim();
    if (_selectedOrgId != null && _selectedOrgId!.trim().isNotEmpty) {
      return _selectedOrgId!.trim();
    }
    if (fromFund.isNotEmpty) return fromFund;
    return null;
  }

  bool get _showOrganizationField {
    final patch = widget.patch;
    if (patch.idno.length != 14) return false;
    if (_effectiveOrgId != null && _effectiveOrgId!.isNotEmpty) return true;
    if (_orgLabel().trim().isNotEmpty && _orgLabel().trim() != '—') {
      return true;
    }
    if (_orgs.isNotEmpty) return true;
    return widget.authority.organizationTab ||
        _orgRequired ||
        widget.authority.tabVisible('RT_ORG');
  }

  Future<void> _openCustomerView() async {
    final id = widget.patch.idno;
    if (FmcValidation.nationalId(id) != null) {
      _toast('برجاء إدخال رقم قومي صحيح');
      return;
    }
    ClientLookups? lookups;
    try {
      final names = await _clients.customerNames(id);
      if (names.isEmpty) {
        lookups = await _clients.customerFormLookups();
      }
    } catch (_) {}
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ClientDataScene(
          initial: ClientInfo({
            'nationalId': id,
            'fullName': widget.patch.customerName,
          }),
          lookups: lookups,
          viewOnly: true,
        ),
      ),
    );
  }

  Future<void> _openCustomerAddressEdit() async {
    final id = widget.patch.idno;
    if (FmcValidation.nationalId(id) != null) {
      _toast('برجاء إدخال رقم قومي صحيح');
      return;
    }
    final custEditable = widget.authority.tabEditable('RT_CUST');
    if (!custEditable) {
      _toast('تعديل العنوان غير متاح في هذه المرحلة');
      return;
    }
    ClientLookups? lookups;
    try {
      lookups = await _clients.customerFormLookups();
    } catch (_) {}
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ClientDataScene(
          initial: ClientInfo({
            'nationalId': id,
            'fullName': widget.patch.customerName,
          }),
          lookups: lookups,
          addressSectionsOnly: true,
        ),
      ),
    );
  }

  Future<void> _openOrganizationView() async {
    final orgId = _effectiveOrgId;
    if (orgId == null || orgId.isEmpty) {
      _toast('لا توجد منشأة مرتبطة بهذا الطلب');
      return;
    }
    InquiryOrganizationProfileScene.openForFund(
      context,
      idno: widget.patch.idno,
      orgId: orgId,
    );
  }

  Future<void> _openOrganizationEdit() async {
    if (!widget.authority.tabEditable('RT_ORG')) {
      _toast('تعديل المنشأة غير متاح في هذه المرحلة');
      return;
    }
    if (widget.patch.customerName.isEmpty) {
      _toast('برجاء إكمال بيانات العميل أولاً');
      return;
    }
    final orgId = _effectiveOrgId;
    if (orgId == null || orgId.isEmpty) {
      _toast('لا توجد منشأة لتعديلها — أضف المنشأة من الويب أو إنشاء الطلب');
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EstablishmentDataScene(
          initial: EstablishmentInfo({
            'registerNumber': orgId,
            'name': _orgLabel(),
          }),
        ),
      ),
    );
    await _loadOrgs();
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String _fundText(List<String> keys) =>
      personalFundFundText(widget.fund, keys);

  String _orgLabel() {
    final id = _effectiveOrgId;
    if (id == null) return _fundText(['orgNameAr', 'orgName']);
    for (final org in _uniqueOrgs) {
      if (_orgIdFromMap(org) == id) {
        return '${org['orgNameAr'] ?? org['nameAr'] ?? id}';
      }
    }
    final name = _fundText(['orgNameAr', 'orgName']);
    if (name.isNotEmpty) return name;
    return id;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.error != null) {
      return Center(child: Text(widget.error!, textAlign: TextAlign.center));
    }
    final patch = widget.patch;
    final auth = widget.authority;
    final showCustActions =
        auth.customerDataTab || patch.idno.isNotEmpty;
    final custEditable = auth.tabEditable('RT_CUST');
    final showOrgField = _showOrganizationField;
    final orgEditable = auth.tabEditable('RT_ORG');
    final orgDropdownEditable =
        auth.controlEditable('RT_LOAN', 'fundInfo.orgId');
    return PersonalFundTabPage(
      tabId: 'fund',
      title: 'بيانات التمويل',
      showSectionHeader: false,
      children: [
        if (!auth.tabEditable('RT_LOAN'))
          personalFundReadonlyBanner(
            'بيانات التمويل للعرض فقط في هذه المرحلة',
          ),
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Text(
            'ملخص المبالغ',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            PersonalFundStatChip(
              label: 'قيمة القسط',
              value: _fundText(['kstValue', 'kstAmt']),
              highlight: true,
              compact: true,
            ),
            SizedBox(width: 6.w),
            PersonalFundStatChip(
              label: 'إجمالي التمويل',
              value: _fundText([
                'fundingTotalAmount',
                'pTotalAmount',
                'totalAmount',
              ]),
              compact: true,
            ),
            SizedBox(width: 6.w),
            PersonalFundStatChip(
              label: 'صافي للعميل',
              value: _fundText([
                'pNetDeliveredToCust',
                'netDeliverToCust',
              ]),
              compact: true,
            ),
          ],
        ),
        SizedBox(height: 10.h),
        PersonalFundFormShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PersonalFundFormSection(
                title: 'بيانات الطلب',
                icon: Icons.tag_outlined,
                children: [
                  PersonalFundReadonlyValue(
                    label: 'رقم الطلب',
                    value: patch.serviceId,
                  ),
                  PersonalFundFormGrid(
                    children: [
                      PersonalFundAuthorityReadonly(
                        label: 'المنتج التمويلي',
                    value: _fundText([
                      'loanTypeNameAr',
                      'loanTypeNameEn',
                      'loanTypeName',
                    ]),
                    authority: auth,
                    tabRole: 'RT_LOAN',
                    controlPath: 'fundInfo.loanType',
                  ),
                  PersonalFundField(
                    label: 'المبلغ المطلوب',
                    controller: widget.reqAmount,
                    authority: auth,
                    tabRole: 'RT_LOAN',
                    controlPath: 'fundInfo.reqAmount',
                    keyboardType: TextInputType.number,
                  ),
                  PersonalFundField(
                    label: 'عدد الأقساط المطلوبة',
                    controller: widget.reqInstallments,
                    authority: auth,
                    tabRole: 'RT_LOAN',
                    controlPath: 'fundInfo.reqNoOfksts',
                    keyboardType: TextInputType.number,
                  ),
                    ],
                  ),
                ],
              ),
              PersonalFundFormSection(
                title: 'العميل والمنشأة',
                icon: Icons.person_outline,
                children: [
                  PersonalFundFormGrid(
                    children: [
                  PersonalFundReadonlyValue(
                    label: 'رقم البطاقة',
                    value: patch.idno,
                  ),
                  PersonalFundLabeledField(
                    label: 'إسم العميل',
                    trailing: showCustActions
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            textDirection: TextDirection.rtl,
                            children: [
                              PersonalFundIconAction(
                                icon: Icons.visibility_outlined,
                                tooltip: 'عرض بيانات العميل',
                                onPressed: _openCustomerView,
                              ),
                              SizedBox(width: 6.w),
                              PersonalFundIconAction(
                                icon: Icons.edit_outlined,
                                tooltip: 'تعديل عنوان البطاقة والإقامة',
                                enabled: custEditable,
                                onPressed: custEditable
                                    ? _openCustomerAddressEdit
                                    : null,
                              ),
                            ],
                          )
                        : null,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 13.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Text(
                        patch.customerName.isEmpty ? '—' : patch.customerName,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ),
                  if (showOrgField)
                    PersonalFundLabeledField(
                      label: 'المنشأة',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        textDirection: TextDirection.rtl,
                        children: [
                          PersonalFundIconAction(
                            icon: Icons.visibility_outlined,
                            tooltip: 'عرض بيانات المنشأة',
                            enabled: _effectiveOrgId?.isNotEmpty == true,
                            onPressed: _effectiveOrgId?.isNotEmpty == true
                                ? _openOrganizationView
                                : null,
                          ),
                          SizedBox(width: 6.w),
                          PersonalFundIconAction(
                            icon: Icons.edit_outlined,
                            tooltip: 'تعديل بيانات المنشأة',
                            enabled: orgEditable,
                            onPressed:
                                orgEditable ? _openOrganizationEdit : null,
                          ),
                        ],
                      ),
                      child: _uniqueOrgs.isNotEmpty &&
                              orgDropdownEditable &&
                              _dropdownOrgValue != null
                          ? DropdownButtonFormField<String>(
                              value: _dropdownOrgValue,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.card,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              items: [
                                for (final org in _uniqueOrgs)
                                  DropdownMenuItem(
                                    value: _orgIdFromMap(org),
                                    child: Text(
                                      '${org['orgNameAr'] ?? org['nameAr'] ?? _orgIdFromMap(org)}',
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                              ],
                              onChanged: orgDropdownEditable
                                  ? (v) => setState(() => _selectedOrgId = v)
                                  : null,
                            )
                          : Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 13.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F5F7),
                                borderRadius: BorderRadius.circular(12.r),
                                border:
                                    Border.all(color: const Color(0xFFD5DDE6)),
                              ),
                              child: Text(
                                _orgLabel(),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                    ),
                    ],
                  ),
                ],
              ),
              PersonalFundFormSection(
                title: 'المخاطر والعروض',
                icon: Icons.analytics_outlined,
                children: [
                  PersonalFundFormGrid(
                    children: [
                  PersonalFundAuthorityReadonly(
                    label: 'المخاطر',
                    value: _fundText(['risk', 'riskNameAr']),
                    authority: auth,
                    tabRole: 'RT_LOAN',
                    controlPath: 'fundInfo.risk',
                  ),
                  PersonalFundAuthorityReadonly(
                    label: 'حالة الحظر',
                    value: _fundText(['riskState', 'blackListState']),
                    authority: auth,
                    tabRole: 'RT_LOAN',
                    controlPath: 'fundInfo.riskState',
                  ),
                  PersonalFundAuthorityReadonly(
                    label: 'العروض',
                    value: _fundText(['promotionName', 'offers', 'promotion']),
                    authority: auth,
                    tabRole: 'RT_LOAN',
                    controlPath: 'fundInfo.promotionName',
                  ),
                    ],
                  ),
                ],
              ),
              PersonalFundFormSection(
                title: 'ملخص المبالغ',
                icon: Icons.calculate_outlined,
                children: [
                  PersonalFundFormGrid(
                    children: [
                  PersonalFundAuthorityReadonly(
                    label: 'قيمة القسط',
                    value: _fundText(['kstValue', 'kstAmt']),
                    authority: auth,
                    tabRole: 'RT_LOAN',
                    controlPath: 'fundInfo.kstValue',
                  ),
                  PersonalFundAuthorityReadonly(
                    label: 'إجمالي قيمة التمويل',
                    value: _fundText([
                      'fundingTotalAmount',
                      'pTotalAmount',
                      'totalAmount',
                    ]),
                    authority: auth,
                    tabRole: 'RT_LOAN',
                    controlPath: 'fundInfo.fundingTotalAmount',
                  ),
                  PersonalFundAuthorityReadonly(
                    label: 'المصاريف المضافة',
                    value: _fundText(['pAddedValue', 'addedValue']),
                    authority: auth,
                    tabRole: 'RT_LOAN',
                    controlPath: 'fundInfo.pAddedValue',
                  ),
                  PersonalFundAuthorityReadonly(
                    label: 'صافي القيمة المسلمة للعميل',
                    value: _fundText([
                      'pNetDeliveredToCust',
                      'netDeliverToCust',
                      'pNetDelivered',
                    ]),
                    authority: auth,
                    tabRole: 'RT_LOAN',
                    controlPath: 'fundInfo.pNetDeliveredToCust',
                  ),
                  PersonalFundAuthorityReadonly(
                    label: 'قيمة التمويل',
                    value: patch.reqAmount.isNotEmpty
                        ? patch.reqAmount
                        : _fundText(['requiredValue']),
                    authority: auth,
                    tabRole: 'RT_LOAN',
                    controlPath: 'fundInfo.requiredValue',
                  ),
                  PersonalFundField(
                    label: 'القيمة النهائية للتمويل',
                    controller: widget.approvedAmount,
                    authority: auth,
                    tabRole: 'RT_LOAN',
                    controlPath: 'fundInfo.approvedAmount',
                    keyboardType: TextInputType.number,
                  ),
                  PersonalFundField(
                    label: 'أقساط معتمدة',
                    controller: widget.approvedInstallments,
                    authority: auth,
                    tabRole: 'RT_LOAN',
                    controlPath: 'fundInfo.approvedNoOfksts',
                    keyboardType: TextInputType.number,
                  ),
                    ],
                  ),
                ],
              ),
              ..._extraAuthorityFields(auth),
            ],
          ),
        ),
        if (auth.tabEditable('RT_LOAN'))
          PersonalFundFormShell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FlowTextField(
                  controller: widget.saveComment,
                  hint: 'تعليق الحفظ (اختياري)',
                  onChanged: (_) {},
                ),
                SizedBox(height: 12.h),
                FlowActionButton(
                  label: 'حفظ بيانات التمويل',
                  enabled: true,
                  onPressed: widget.onSave,
                ),
              ],
            ),
          ),
      ],
    );
  }

  List<Widget> _extraAuthorityFields(FundWorkflowAuthority auth) {
    const labels = {
      'fundInfo.loanType': 'كود المنتج',
      'fundInfo.wfCode': 'مسار العمل',
      'fundInfo.brCode': 'الفرع',
      'fundInfo.pNetDeliveredToCust': 'صافي للعميل',
      'fundInfo.pAddedValue': 'قيمة مضافة',
      'fundInfo.fundingTotalAmount': 'إجمالي التمويل',
    };
    final rules = auth.tabFieldRules('RT_LOAN');
    final out = <Widget>[];
    for (final rule in rules) {
      final id =
          '${rule['fieldId'] ?? rule['controlName'] ?? rule['fieldName'] ?? ''}';
      if (id.isEmpty) continue;
      if (!auth.controlVisible('RT_LOAN', id)) continue;
      if (id.contains('reqAmount') ||
          id.contains('reqNoOfksts') ||
          id.contains('approvedAmount') ||
          id.contains('approvedNoOfksts')) {
        continue;
      }
      final key = id.contains('.') ? id.split('.').last : id;
      final value = widget.fund[key] ?? widget.fund[_camel(key)];
      if (value == null || '$value'.trim().isEmpty) continue;
      out.add(
        PersonalFundReadonlyValue(
          label: labels[id] ?? id,
          value: '$value',
        ),
      );
    }
    return out;
  }

  String? _camel(String key) {
    if (key == 'loanType') return 'loanType';
    return null;
  }
}
