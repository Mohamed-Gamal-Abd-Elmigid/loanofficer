import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/client_api.dart';
import 'package:loanofficer/core/api/fmc_session.dart';
import 'package:loanofficer/core/api/personal_fund_api.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/validation/fmc_validation.dart';
import 'package:loanofficer/presenter/client_data/scene/client_data_scene.dart';
import 'package:loanofficer/presenter/establishment_data/scene/establishment_data_scene.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';
import 'package:loanofficer/core/bases/base_state.dart';
import 'package:loanofficer/core/bases/states/base/base_state.dart';
import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/new_individual_request/bloc/new_individual_request_bloc.dart';
import 'package:loanofficer/presenter/new_individual_request/model/new_individual_request_model.dart';
import 'package:loanofficer/presenter/new_individual_request/national_id_customer_flow.dart';

class NewIndividualRequestScene extends StatefulWidget {
  const NewIndividualRequestScene({super.key, this.embedInShell = false});

  final bool embedInShell;

  @override
  State<NewIndividualRequestScene> createState() =>
      _NewIndividualRequestSceneState();
}

class _NewIndividualRequestSceneState
    extends
        BaseState<
          NewIndividualRequestScene,
          NewIndividualRequestBloc,
          NewIndividualRequestModel
        > {
  final _amount = TextEditingController();
  final _installments = TextEditingController();
  final _nationalId = TextEditingController();
  final _clientName = TextEditingController();
  FundingProduct? _product;
  ClientInfo? _client;
  EstablishmentInfo? _establishment;
  EstablishmentOrgOption? _selectedOrg;
  List<EstablishmentOrgOption> _organizations = const [];
  String? _checkedNationalId;
  final _nationalIdFlow = NationalIdCustomerFlow();
  final _personalFundApi = PersonalFundApi();
  bool _showAllErrors = false;
  bool _nationalIdLookupBusy = false;
  bool _orgLookupBusy = false;
  bool _amountTouched = false;
  bool _submitting = false;

  String? _shown(String? error) {
    if (error == null || !_showAllErrors) return null;
    return error;
  }

  String? _shownAmount(String? error) {
    if (error == null) return null;
    if (_showAllErrors || _amountTouched) return error;
    return null;
  }

  String? get _productError => FmcValidation.required(_product?.name);

  String? get _amountError =>
      FmcValidation.requestedAmount(_amount.text, _product?.maxAmount);

  static const _installmentOptions = ['6', '12', '18', '24'];

  String? get _installmentsError {
    final count = _installments.text.trim();
    if (count.isEmpty) return FmcValidation.requiredMessage;
    if (!_installmentOptions.contains(count)) {
      return 'عدد الاقساط يجب ان يكون 6 او 12 او 18 او 24';
    }
    return null;
  }

  String? get _nationalIdError =>
      FmcValidation.requiredNationalId(_nationalId.text);

  bool get _hasOrganization =>
      _selectedOrg != null ||
      (_establishment?.orgId.trim().isNotEmpty ?? false) ||
      (_establishment?.name.trim().isNotEmpty ?? false);

  String? get _establishmentError {
    if (_product?.orgRequired != true || _hasOrganization) return null;
    return FmcValidation.requiredMessage;
  }

  String? get _clientError {
    if (_client != null) return null;
    return FmcValidation.requiredMessage;
  }

  @override
  void dispose() {
    _amount.dispose();
    _installments.dispose();
    _nationalId.dispose();
    _clientName.dispose();
    super.dispose();
  }

  void _showValidation(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickProduct(List<FundingProduct> products) async {
    final choice = await showChoiceDialog(
      context: context,
      title: 'اختر المنتج التمويلي',
      subtitle: 'اختر المنتج التمويلي الذي يرغب به العميل',
      options: products.map((product) => product.name).toList(),
      selected: _product?.name,
    );
    if (!mounted) return;
    if (choice == null) return;
    FundingProduct? selected;
    for (final product in products) {
      if (product.name == choice) {
        selected = product;
        break;
      }
    }
    setState(() => _product = selected);
  }

  Future<void> _pickInstallments() async {
    final choice = await showChoiceDialog(
      context: context,
      title: 'عدد الاقساط',
      options: _installmentOptions,
      selected: _installments.text.isEmpty ? null : _installments.text,
    );
    if (!mounted || choice == null) return;
    setState(() => _installments.text = choice);
  }

  Future<void> _openEstablishment({bool createNew = false}) async {
    final nationalId = _nationalId.text.trim();
    final result = await Navigator.of(context).push<EstablishmentInfo>(
      MaterialPageRoute(
        builder: (_) => EstablishmentDataScene(
          initial: createNew ? null : _establishment,
          nationalId: nationalId.length == 14 ? nationalId : null,
          organizations: _organizations,
          allowSelectExisting: _client != null && !createNew,
        ),
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      _establishment = result;
      final orgId = result.orgId.trim();
      if (orgId.isNotEmpty) {
        _selectedOrg = EstablishmentOrgOption(
          id: orgId,
          name: result.name.isEmpty ? orgId : result.name,
        );
        if (!_organizations.any((org) => org.id == orgId)) {
          _organizations = [..._organizations, _selectedOrg!];
        }
      }
    });
  }

  Future<void> _loadOrganizationsForCustomer(String nationalId) async {
    setState(() {
      _orgLookupBusy = true;
      _selectedOrg = null;
    });
    try {
      var rows =
          await _personalFundApi.organizationsByCustNationalId(nationalId);
      if (rows.isEmpty) {
        rows = await _personalFundApi.organizationsByIdno(nationalId);
      }
      if (!mounted || _nationalId.text.trim() != nationalId) return;
      final options = <EstablishmentOrgOption>[
        for (final row in rows)
          if (EstablishmentOrgOption.tryParse(row) case final option?) option,
      ];
      setState(() {
        _organizations = options;
        _selectedOrg = null;
        _establishment = null;
        _orgLookupBusy = false;
      });
    } catch (error) {
      if (!mounted || _nationalId.text.trim() != nationalId) return;
      setState(() {
        _organizations = const [];
        _orgLookupBusy = false;
      });
      showAuthError(context, error);
    }
  }

  Future<void> _pickOrganization() async {
    if (_organizations.isEmpty) {
      _showValidation('لا توجد منشآت مرتبطة بهذا الرقم القومي');
      return;
    }
    final choice = await showChoiceDialog(
      context: context,
      title: 'المنشأة',
      options: _organizations.map((org) => org.name).toList(),
      selected: _selectedOrg?.name,
      searchable: true,
      searchHint: 'بحث…',
    );
    if (!mounted || choice == null) return;
    EstablishmentOrgOption? match;
    for (final org in _organizations) {
      if (org.name == choice) {
        match = org;
        break;
      }
    }
    if (match == null) return;
    setState(() {
      _selectedOrg = match;
      _establishment = EstablishmentInfo({
        'orgId': match!.id,
        'name': match.name,
        'registerNumber': match.id,
      });
    });
  }

  Future<void> _viewOrganization() async {
    final orgId = (_selectedOrg?.id ?? _establishment?.orgId ?? '').trim();
    if (orgId.isEmpty) {
      _showValidation('برجاء اختيار منشأة أولاً');
      return;
    }
    final nationalId = _nationalId.text.trim();
    try {
      final bundle = await _personalFundApi.organizationInquiry(
        idno: nationalId,
        orgId: orgId,
      );
      if (!mounted) return;
      final info = EstablishmentInfo.fromOrganizationDetail(
        bundle.detail,
        partners: bundle.partners,
      );
      final withName = info.name.trim().isEmpty
          ? EstablishmentInfo({
              ...info.values,
              'name': _selectedOrg?.name ?? orgId,
              'orgId': orgId,
            })
          : info;
      await Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => EstablishmentDataScene(
            initial: withName,
            nationalId: nationalId.length == 14 ? nationalId : null,
            organizations: _organizations,
            viewOnly: true,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      showAuthError(context, error);
    }
  }

  Future<void> _viewClient() async {
    if (_client == null) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => ClientDataScene(
          initial: _client,
          viewOnly: true,
        ),
      ),
    );
  }

  Future<void> _editClient() async {
    if (_client == null) return;
    ClientLookups? lookups;
    try {
      lookups = await ClientApi().customerFormLookups();
    } catch (_) {}
    if (!mounted) return;
    final result = await Navigator.of(context).push<ClientInfo>(
      MaterialPageRoute(
        builder: (_) => ClientDataScene(
          initial: _client,
          lookups: lookups,
        ),
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      _client = result;
      _clientName.text = result.fullName;
      if (result.nationalId.isNotEmpty) {
        _nationalId.text = result.nationalId;
        _checkedNationalId = result.nationalId;
      }
    });
  }

  Future<void> _addOrganization() => _openEstablishment(createNew: true);

  Future<void> _editOrganization() async {
    final orgId = (_selectedOrg?.id ?? _establishment?.orgId ?? '').trim();
    final nationalId = _nationalId.text.trim();
    EstablishmentInfo? initial = _establishment;
    if (orgId.isNotEmpty &&
        (initial == null ||
            initial.name.trim().isEmpty ||
            initial.orgId.trim().isEmpty ||
            initial.values['econCode1Descr'] == null)) {
      try {
        final bundle = await _personalFundApi.organizationInquiry(
          idno: nationalId,
          orgId: orgId,
        );
        if (!mounted) return;
        initial = EstablishmentInfo.fromOrganizationDetail(
          bundle.detail,
          partners: bundle.partners,
        );
        if (initial.name.trim().isEmpty) {
          initial = EstablishmentInfo({
            ...initial.values,
            'name': _selectedOrg?.name ?? orgId,
            'orgId': orgId,
          }, partners: initial.partners);
        }
      } catch (error) {
        if (!mounted) return;
        showAuthError(context, error);
        return;
      }
    }
    final result = await Navigator.of(context).push<EstablishmentInfo>(
      MaterialPageRoute(
        builder: (_) => EstablishmentDataScene(
          initial: initial,
          nationalId: nationalId.length == 14 ? nationalId : null,
          organizations: _organizations,
          editExisting: orgId.isNotEmpty,
        ),
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      _establishment = result;
      final id = result.orgId.trim();
      if (id.isNotEmpty) {
        _selectedOrg = EstablishmentOrgOption(
          id: id,
          name: result.name.isEmpty ? id : result.name,
        );
        if (!_organizations.any((org) => org.id == id)) {
          _organizations = [..._organizations, _selectedOrg!];
        }
      }
    });
  }

  void _clearClientLookup() {
    _client = null;
    _checkedNationalId = null;
    _clientName.clear();
    _organizations = const [];
    _establishment = null;
    _selectedOrg = null;
    _orgLookupBusy = false;
  }

  void _onNationalIdChanged() {
    final id = _nationalId.text.trim();
    if (id.length != 14 || FmcValidation.nationalId(id) != null) {
      if (_client != null || _checkedNationalId != null) {
        setState(_clearClientLookup);
      }
      return;
    }
    _lookupNationalId();
  }

  /// Fusion: `cif/customers/names` then existing ⇒ show name/id inline; else new-customer cycle.
  Future<void> _lookupNationalId() async {
    final id = _nationalId.text.trim();
    if (id.length != 14 || FmcValidation.nationalId(id) != null) return;
    if (_nationalIdLookupBusy || id == _checkedNationalId) return;
    setState(() => _nationalIdLookupBusy = true);
    _checkedNationalId = id;
    try {
      final resolution = await _nationalIdFlow.resolve(id);
      if (!mounted || _nationalId.text.trim() != id) return;
      switch (resolution) {
        case NationalIdExistingCustomer(
            :final nationalId,
            :final clientId,
            :final fullName,
          ):
          setState(() {
            _client = ClientInfo(
              {
                'nationalId': nationalId,
                'fullName': fullName,
                'clientNumber': clientId,
              },
              clientId: clientId.isEmpty ? null : clientId,
            );
            _clientName.text = fullName;
            _establishment = null;
            _selectedOrg = null;
            _organizations = const [];
          });
          await _loadOrganizationsForCustomer(nationalId);
        case NationalIdNewCustomer(:final nationalId, :final check, :final lookups):
          if (!check.accepted) {
            _checkedNationalId = null;
            final msg = check.message.trim().isNotEmpty
                ? check.message.trim()
                : FmcValidation.nationalIdMessage;
            _showValidation(msg);
            return;
          }
          setState(() {
            _client = null;
            _clientName.clear();
            _organizations = const [];
            _establishment = null;
            _selectedOrg = null;
          });
          await _openNewCustomer(
            nationalId,
            check: check,
            lookups: lookups,
          );
      }
    } catch (error) {
      if (!mounted || _nationalId.text.trim() != id) return;
      _checkedNationalId = null;
      showAuthError(context, error);
    } finally {
      if (mounted) setState(() => _nationalIdLookupBusy = false);
      final latest = _nationalId.text.trim();
      if (mounted && latest != id && latest.length == 14) {
        _lookupNationalId();
      }
    }
  }

  /// Web opens ADD-CUSTOMER-MODAL with checkIdno + lookups prefilled.
  Future<void> _openNewCustomer(
    String id, {
    required NationalIdCheck check,
    ClientLookups? lookups,
  }) async {
    if (!mounted || _nationalId.text.trim() != id) return;
    final gender = lookups?.genderName(check.genderCode) ?? '';
    final result = await Navigator.of(context).push<ClientInfo>(
      MaterialPageRoute(
        builder: (_) => ClientDataScene(
          newCustomer: true,
          lookups: lookups,
          initial: ClientInfo({
            'nationalId': id,
            'birth': check.birth,
            'gender': gender,
          }),
        ),
      ),
    );
    if (!mounted || result == null) {
      _checkedNationalId = null;
      return;
    }
    setState(() {
      _client = result;
      _clientName.text = result.fullName;
      if (result.nationalId.isNotEmpty) {
        _nationalId.text = result.nationalId;
        _checkedNationalId = result.nationalId;
      }
    });
  }

  Future<Map<String, dynamic>> _buildCreatePayload() async {
    final login = await FmcSession.instance.readLogin();
    final amount = int.tryParse(_amount.text.trim()) ?? _amount.text.trim();
    final installments =
        int.tryParse(_installments.text.trim()) ?? _installments.text.trim();
    final orgIdRaw =
        (_selectedOrg?.id ?? _establishment?.orgId ?? '').trim();
    final orgId = int.tryParse(orgIdRaw) ?? (orgIdRaw.isEmpty ? null : orgIdRaw);
    final idno = _nationalId.text.trim();
    return {
      'prodType': 1,
      'loanType': _product?.loanType,
      'ticketId': null,
      'reqAmount': amount,
      'reqNoOfksts': installments,
      'idno': int.tryParse(idno) ?? idno,
      'orgId': orgId,
      'brCode': login?['brCode'],
      'serviceId': null,
    };
  }

  Future<void> _sendRequest() async {
    final blocked =
        _productError ??
        _amountError ??
        _installmentsError ??
        _nationalIdError ??
        _clientError ??
        _establishmentError;
    if (blocked != null) {
      setState(() => _showAllErrors = true);
      _showValidation(FmcValidation.fillFormMessage);
      return;
    }
    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      final payload = await _buildCreatePayload();
      await _personalFundApi.savePersonalRequest(payload);
      if (!mounted) return;
      await showFlowSuccess(
        context,
        message: 'لقد قمت بإنشاء وإرسال طلب التمويل بنجاح',
        note:
            'الطلب الان في مرحلة المراجعة\nيمكنك متابعة الطلب من صفحة\nمتابعة طلبات التمويل',
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      showAuthError(context, error);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget buildWidget(
    BuildContext context,
    RenderDataState<NewIndividualRequestModel> state,
  ) {
    final existingCustomer = _client != null;
    return FlowScaffold(
      embedInShell: widget.embedInShell,
      pageTitle: widget.embedInShell ? null : 'إنشاء طلب تمويل فردي',
      pageIcon: Icons.add,
      onBack: () => Navigator.of(context).pop(),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        children: [
          _CreateRequestForm(
            product: _product?.name ?? '',
            productError: _shown(_productError),
            amount: _amount,
            amountError: _shownAmount(_amountError),
            installments: _installments.text,
            installmentsError: _shown(_installmentsError),
            nationalId: _nationalId,
            nationalIdError: _shown(_nationalIdError),
            clientName: _clientName,
            existingCustomer: existingCustomer,
            organizationLabel: _selectedOrg?.name ?? '',
            organizationError: _shown(_establishmentError),
            organizationBusy: _orgLookupBusy,
            hasOrganizationSelection: _selectedOrg != null,
            reserveErrorSpace: _showAllErrors,
            nationalIdLookupBusy: _nationalIdLookupBusy,
            onProduct: () => _pickProduct(state.data.products),
            onInstallments: _pickInstallments,
            onViewClient: existingCustomer ? _viewClient : null,
            onAddClient: existingCustomer ? _editClient : null,
            onPickOrganization: existingCustomer ? _pickOrganization : null,
            onViewOrganization:
                existingCustomer && _selectedOrg != null
                    ? _viewOrganization
                    : null,
            onAddOrganization: existingCustomer
                ? (_selectedOrg != null ? _editOrganization : _addOrganization)
                : null,
            onChanged: (field) {
              setState(() {
                if (field == 'amount') _amountTouched = true;
              });
              if (field == 'nationalId') _onNationalIdChanged();
            },
          ),
          SizedBox(height: 18.h),
          FlowActionButton(
            label: 'انشاء طلب',
            enabled: !_submitting,
            onPressed: _sendRequest,
          ),
        ],
      ),
    );
  }

  @override
  void listenToState(BuildContext context, BaseStates state) {}

  @override
  NewIndividualRequestBloc createBloc() =>
      NewIndividualRequestBloc(NewIndividualRequestModel());
}

/// Web-parity create form: product / amount / installments, then
/// national ID / client name / establishment.
class _CreateRequestForm extends StatelessWidget {
  const _CreateRequestForm({
    required this.product,
    required this.productError,
    required this.amount,
    required this.amountError,
    required this.installments,
    required this.installmentsError,
    required this.nationalId,
    required this.nationalIdError,
    required this.clientName,
    required this.existingCustomer,
    required this.organizationLabel,
    required this.organizationBusy,
    required this.hasOrganizationSelection,
    required this.onProduct,
    required this.onInstallments,
    required this.onChanged,
    this.organizationError,
    this.onViewClient,
    this.onAddClient,
    this.onPickOrganization,
    this.onViewOrganization,
    this.onAddOrganization,
    this.nationalIdLookupBusy = false,
    this.reserveErrorSpace = false,
  });

  final String product;
  final String? productError;
  final TextEditingController amount;
  final String? amountError;
  final String installments;
  final String? installmentsError;
  final TextEditingController nationalId;
  final String? nationalIdError;
  final TextEditingController clientName;
  final bool existingCustomer;
  final String organizationLabel;
  final String? organizationError;
  final bool organizationBusy;
  final bool hasOrganizationSelection;
  final VoidCallback onProduct;
  final VoidCallback onInstallments;
  final VoidCallback? onViewClient;
  final VoidCallback? onAddClient;
  final VoidCallback? onPickOrganization;
  final VoidCallback? onViewOrganization;
  final VoidCallback? onAddOrganization;
  final ValueChanged<String> onChanged;
  final bool nationalIdLookupBusy;
  final bool reserveErrorSpace;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FormSection(
          title: 'بيانات التمويل',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FlowChoiceField(
                label: 'المنتج التمويلي',
                value: product,
                hint: 'المنتج التمويلي',
                error: productError,
                reserveErrorSpace: reserveErrorSpace,
                onTap: onProduct,
              ),
              SizedBox(height: 12.h),
              const FlowLabel('المبلغ المطلوب'),
              SizedBox(height: 6.h),
              FlowTextField(
                controller: amount,
                hint: 'المبلغ المطلوب',
                digitsOnly: true,
                keyboardType: TextInputType.number,
                error: amountError,
                reserveErrorSpace: reserveErrorSpace || amountError != null,
                onChanged: (_) => onChanged('amount'),
              ),
              SizedBox(height: 12.h),
              FlowChoiceField(
                label: 'عدد الأقساط المطلوبة',
                value: installments,
                hint: 'عدد الأقساط المطلوبة',
                error: installmentsError,
                reserveErrorSpace: reserveErrorSpace,
                onTap: onInstallments,
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        _FormSection(
          title: 'العميل والمنشأة',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const FlowLabel('رقم البطاقة'),
              SizedBox(height: 6.h),
              FlowTextField(
                controller: nationalId,
                hint: 'رقم البطاقة',
                digitsOnly: true,
                maxLength: 14,
                keyboardType: TextInputType.number,
                error: nationalIdError,
                reserveErrorSpace: reserveErrorSpace,
                onChanged: (_) => onChanged('nationalId'),
              ),
              if (nationalIdLookupBusy) ...[
                SizedBox(height: 8.h),
                _InlineBusy(label: 'جاري التحقق من الرقم القومي…'),
              ],
              SizedBox(height: 14.h),
              const FlowLabel('إسم العميل'),
              SizedBox(height: 6.h),
              _ReadonlyBox(
                text: clientName.text,
                hint: 'إسم العميل',
                enabled: existingCustomer,
              ),
              SizedBox(height: 8.h),
              _TwinActionButtons(
                viewLabel: 'عرض',
                addLabel: 'تعديل',
                onView: existingCustomer ? onViewClient : null,
                onAdd: existingCustomer ? onAddClient : null,
              ),
              SizedBox(height: 14.h),
              const FlowLabel('المنشأة'),
              SizedBox(height: 6.h),
              _OrgDropdownBox(
                label: organizationLabel,
                enabled: existingCustomer && !organizationBusy,
                selected: hasOrganizationSelection,
                error: organizationError != null,
                onTap: onPickOrganization,
              ),
              SizedBox(height: 8.h),
              _TwinActionButtons(
                viewLabel: 'عرض',
                addLabel: hasOrganizationSelection ? 'تعديل' : 'اضافة',
                addIcon: hasOrganizationSelection
                    ? Icons.edit_outlined
                    : Icons.add_box_outlined,
                onView: existingCustomer && hasOrganizationSelection
                    ? onViewOrganization
                    : null,
                onAdd: existingCustomer ? onAddOrganization : null,
              ),
              if (organizationBusy) ...[
                SizedBox(height: 8.h),
                const _InlineBusy(label: 'جاري تحميل المنشآت…'),
              ],
              if (organizationError != null) ...[
                SizedBox(height: 4.h),
                Text(
                  organizationError!,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: const Color(0xFFE14B4B),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F3FC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
            ),
            child: Text(
              title,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: const Color(0xFF032F64),
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _TwinActionButtons extends StatelessWidget {
  const _TwinActionButtons({
    required this.viewLabel,
    required this.addLabel,
    this.addIcon = Icons.edit_outlined,
    this.onView,
    this.onAdd,
  });

  final String viewLabel;
  final String addLabel;
  final IconData addIcon;
  final VoidCallback? onView;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: _ActionButton(
            label: viewLabel,
            icon: Icons.visibility_outlined,
            filled: false,
            onPressed: onView,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _ActionButton(
            label: addLabel,
            icon: addIcon,
            filled: true,
            onPressed: onAdd,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.filled,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final bg = !enabled
        ? const Color(0xFFF0F2F5)
        : filled
        ? AppColors.accent
        : AppColors.white;
    final fg = !enabled
        ? const Color(0xFFC5CED6)
        : filled
        ? AppColors.white
        : AppColors.accent;
    return SizedBox(
      height: 44.h,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledForegroundColor: const Color(0xFFC5CED6),
          disabledBackgroundColor: const Color(0xFFF0F2F5),
          side: BorderSide(
            color: enabled
                ? AppColors.accent
                : const Color(0xFFD5DDE6),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        icon: Icon(icon, size: 18.r),
        label: Text(label),
      ),
    );
  }
}

class _ReadonlyBox extends StatelessWidget {
  const _ReadonlyBox({
    required this.text,
    required this.hint,
    required this.enabled,
  });

  final String text;
  final String hint;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final filled = text.trim().isNotEmpty;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: enabled && filled
            ? AppColors.white
            : const Color(0xFFF3F5F8),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: filled ? const Color(0xFFB9D7F2) : AppColors.cardBorder,
        ),
      ),
      child: Text(
        filled ? text : hint,
        textAlign: TextAlign.right,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: filled ? const Color(0xFF032F64) : AppColors.hint,
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          height: 1.35,
        ),
      ),
    );
  }
}

class _OrgDropdownBox extends StatelessWidget {
  const _OrgDropdownBox({
    required this.label,
    required this.enabled,
    required this.selected,
    required this.error,
    this.onTap,
  });

  final String label;
  final bool enabled;
  final bool selected;
  final bool error;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: enabled
                ? (selected ? const Color(0xFFF8FBFE) : AppColors.white)
                : const Color(0xFFF3F5F8),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: error
                  ? const Color(0xFFE14B4B)
                  : selected
                  ? AppColors.accent
                  : AppColors.cardBorder,
              width: selected || error ? 1.4 : 1,
            ),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: Text(
                  selected ? label : 'المنشأة',
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected
                        ? const Color(0xFF032F64)
                        : AppColors.hint,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: enabled ? AppColors.accent : AppColors.muted,
                size: 24.r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InlineBusy extends StatelessWidget {
  const _InlineBusy({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        SizedBox(
          width: 16.r,
          height: 16.r,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.accent,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            color: AppColors.fieldLabel,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

