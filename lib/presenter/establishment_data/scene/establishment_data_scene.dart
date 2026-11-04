import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/client_api.dart';
import 'package:loanofficer/core/api/organization_lookups_api.dart';
import 'package:loanofficer/core/api/personal_fund_api.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/validation/fmc_validation.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';

import 'package:loanofficer/core/bases/base_state.dart';
import 'package:loanofficer/core/bases/states/base/base_state.dart';
import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/establishment_data/bloc/establishment_data_bloc.dart';
import 'package:loanofficer/presenter/establishment_data/model/establishment_data_model.dart';

class EstablishmentInfo {
  const EstablishmentInfo(this.values, {this.partners = const []});

  final Map<String, String> values;
  final List<Map<String, String>> partners;

  String get name => values['name'] ?? '';
  String get activity => values['activity'] ?? values['orgDescr'] ?? '';
  String get registerNumber =>
      values['registerNumber'] ?? values['regNo'] ?? '';
  String get orgId => values['orgId'] ?? '';

  /// Maps Fusion `GET cif/organizations/{orgId}` (+ partners) into form keys.
  factory EstablishmentInfo.fromOrganizationDetail(
    Map<String, dynamic> detail, {
    List<Map<String, dynamic>> partners = const [],
  }) {
    String text(dynamic value) => value == null ? '' : '$value'.trim();
    String first(Map<dynamic, dynamic> row, List<String> keys) {
      for (final key in keys) {
        final value = text(row[key]);
        if (value.isNotEmpty && value.toLowerCase() != 'null') return value;
      }
      return '';
    }

    final address = detail['address'] is Map
        ? Map<String, dynamic>.from(detail['address'] as Map)
        : const <String, dynamic>{};

    var partnerRows = partners;
    if (partnerRows.isEmpty) {
      final embedded = detail['cifCustOrgPartners'];
      if (embedded is List) {
        partnerRows = [
          for (final item in embedded)
            if (item is Map) Map<String, dynamic>.from(item),
        ];
      }
    }

    final orgDescr = first(detail, const [
      'orgDescr',
      'econCode3Descr',
      'econCode2Descr',
      'econCode1Descr',
    ]);
    final regNo = first(detail, const ['regNo']);
    final contactPhone = first(detail, const [
      'contactPhone',
      'phone1',
      'phone2',
    ]);
    final placeType = first(detail, const ['placeTypeDescr', 'placeType']);
    final addTxt = first(address, const ['addTxt']);

    final mappedPartners = [
      for (final partner in partnerRows)
        {
          'partnerName': first(partner, const ['name', 'partnerName']),
          'partnerId': first(partner, const [
            'idno',
            'partnerIdno',
            'partnerId',
          ]),
          'partnerBirth': first(
            partner,
            const ['bod', 'partnerBirth'],
          ).split(' ').first,
          'partnerNationality': first(partner, const [
            'nationCodeDescr',
            'nationCode',
            'partnerNationality',
          ]),
          'partnerRole': first(partner, const [
            'role',
            'roleDescr',
            'partnerRole',
          ]),
          'partnerValue': first(partner, const ['partnerAmt', 'partnerValue']),
          'partnerShare': first(partner, const [
            'partnerRatio',
            'sharePercent',
            'partnerShare',
          ]),
        },
    ];

    return EstablishmentInfo(
      {
        'orgId': first(detail, const ['orgId']),
        'name': first(detail, const ['orgName', 'orgNameAr', 'nameAr']),
        'orgType': first(detail, const ['orgType']),
        'orgTypeDescr': first(detail, const ['orgTypeDescr', 'orgType']),
        'econCode1': first(detail, const ['econCode1']),
        'econCode1Descr': first(detail, const [
          'econCode1Descr',
          'econCode1',
        ]),
        'econCode2': first(detail, const ['econCode2']),
        'econCode2Descr': first(detail, const [
          'econCode2Descr',
          'econCode2',
        ]),
        'econCode3': first(detail, const ['econCode3']),
        'econCode3Descr': first(detail, const [
          'econCode3Descr',
          'econCode3',
        ]),
        'orgDescr': orgDescr,
        'activity': orgDescr,
        'taxFileNo': first(detail, const ['taxFileNo']),
        'regNo': regNo,
        'registerNumber': regNo.isNotEmpty
            ? regNo
            : first(detail, const ['orgId']),
        'regIssueDate': first(detail, const ['regIssueDate']),
        'regExpDate': first(detail, const ['regExpDate']),
        'practiceStartDate': first(detail, const [
          'practiceStartDate',
          'foundingDate',
        ]),
        'foundingDate': first(detail, const [
          'practiceStartDate',
          'regIssueDate',
          'foundingDate',
        ]),
        'orgCapital': first(detail, const ['orgCapital']),
        'countEmployees': first(detail, const ['countEmployees']),
        'companyCategory': first(detail, const ['companyCategory']),
        'companyCategoryDescr': first(detail, const [
          'companyCategoryDescr',
          'companyCategory',
        ]),
        'custIdno': first(detail, const ['custIdno', 'idno', 'custId']),
        'ownerName': first(detail, const [
          'orgOwenrName',
          'orgOwnerName',
          'ownerName',
        ]),
        'contactName': first(detail, const ['contactName']),
        'contactPhone': contactPhone,
        'phone': contactPhone,
        'contactEmail': first(detail, const ['contactEmail']),
        'phone1': first(detail, const ['phone1']),
        'phone2': first(detail, const ['phone2']),
        'email': first(detail, const ['email']),
        // Codes for PUT; Descr for UI.
        'placeType': first(detail, const ['placeType']),
        'placeTypeDescr': first(detail, const [
          'placeTypeDescr',
          'placeType',
        ]),
        'placeOwnership': first(detail, const ['placeOwnership']),
        'placeOwnershipDescr': first(detail, const [
          'placeOwnershipDescr',
          'placeOwnership',
        ]),
        'placeNoOfYears': first(detail, const ['placeNoOfYears']),
        'location': placeType,
        'stateName': first(address, const ['stateName', 'stateCode']),
        'cityName': first(address, const ['cityName', 'cityCode']),
        'villageName': first(address, const ['villageName', 'villageCode']),
        'street': first(address, const ['street']),
        'buildingNo': first(address, const ['buildingNo']),
        'floorNo': first(address, const ['floorNo']),
        'flatno': first(address, const ['flatno', 'flatNo']),
        'addMark': first(address, const ['addMark']),
        'postCode': first(address, const ['postCode']),
        'addTxt': addTxt,
        'address': addTxt,
        'regionId': first(address, const ['regionId']),
        'countryCode': first(address, const ['countryCode', 'countryId']),
        'stateCode': first(address, const ['stateCode']),
        'cityCode': first(address, const ['cityCode']),
        'villageCode': first(address, const ['villageCode']),
      },
      partners: mappedPartners,
    );
  }
}

class EstablishmentOrgOption {
  const EstablishmentOrgOption({required this.id, required this.name});

  final String id;
  final String name;

  static EstablishmentOrgOption? tryParse(Map<String, dynamic> row) {
    String text(dynamic value) => value == null ? '' : '$value'.trim();
    final id = text(row['orgId'] ?? row['id'] ?? row['organizationId']);
    final name = text(
      row['orgNameAr'] ?? row['orgName'] ?? row['nameAr'] ?? row['name'],
    );
    if (id.isEmpty && name.isEmpty) return null;
    return EstablishmentOrgOption(
      id: id.isEmpty ? name : id,
      name: name.isEmpty ? id : name,
    );
  }
}

/// Always dimmed like the web org modal (auto-filled / not user-editable).
const _alwaysLocked = {
  'orgId',
  'econCode1Descr',
  'econCode2Descr',
  'custIdno',
  'ownerName',
};

/// Extra fields locked when editing an existing CIF organization.
const _lockedOnEdit = {
  ..._alwaysLocked,
};

const _partnerFieldKeys = [
  'partnerName',
  'partnerId',
  'partnerBirth',
  'partnerNationality',
  'partnerRole',
  'partnerValue',
  'partnerShare',
];

class EstablishmentDataScene extends StatefulWidget {
  const EstablishmentDataScene({
    super.key,
    this.initial,
    this.nationalId,
    this.organizations = const [],
    this.allowSelectExisting = false,
    this.viewOnly = false,
    this.editExisting = false,
  });

  final EstablishmentInfo? initial;
  final String? nationalId;
  final List<EstablishmentOrgOption> organizations;
  final bool allowSelectExisting;

  /// Dims all fields and hides save/add actions (عرض mode).
  final bool viewOnly;

  /// Existing-org edit: lock رقم المنشأة / القطاعات / صاحب المنشأة / العنوان تفصيلي.
  final bool editExisting;

  @override
  State<EstablishmentDataScene> createState() => _EstablishmentDataSceneState();
}

class _EstablishmentDataSceneState
    extends
        BaseState<
          EstablishmentDataScene,
          EstablishmentDataBloc,
          EstablishmentDataModel
        > {
  final _store = FormStore();
  final _api = PersonalFundApi();
  final _lookupsApi = OrganizationLookupsApi();
  final _clientApi = ClientApi();
  bool _review = false;
  bool _showErrors = false;
  /// Collapsed titles by default; tap opens one section (accordion).
  final Set<String> _open = {};
  late List<EstablishmentOrgOption> _organizations;
  String? _selectedOrgId;
  bool _orgBusy = false;
  final List<FormStore> _partnerStores = [];

  List<OrgLookupItem> _orgTypes = const [];
  List<OrgLookupItem> _economy3 = const [];
  List<OrgLookupItem> _companyCategories = const [];
  List<OrgLookupItem> _placeTypes = const [];
  List<OrgLookupItem> _placeOwnerships = const [];
  List<AddressPlace> _states = const [];
  List<AddressPlace> _cities = const [];
  List<AddressPlace> _villages = const [];
  bool _lookupsBusy = false;

  static const _keys = [
    'orgId',
    'name',
    'orgType',
    'orgTypeDescr',
    'econCode1',
    'econCode1Descr',
    'econCode2',
    'econCode2Descr',
    'econCode3',
    'econCode3Descr',
    'orgDescr',
    'activity',
    'taxFileNo',
    'regNo',
    'registerNumber',
    'regIssueDate',
    'regExpDate',
    'practiceStartDate',
    'foundingDate',
    'orgCapital',
    'countEmployees',
    'companyCategory',
    'companyCategoryDescr',
    'custIdno',
    'ownerName',
    'contactName',
    'contactPhone',
    'phone',
    'contactEmail',
    'phone1',
    'phone2',
    'email',
    'placeType',
    'placeTypeDescr',
    'placeOwnership',
    'placeOwnershipDescr',
    'placeNoOfYears',
    'location',
    'stateName',
    'cityName',
    'villageName',
    'street',
    'buildingNo',
    'floorNo',
    'flatno',
    'addMark',
    'postCode',
    'addTxt',
    'address',
    'regionId',
    'countryCode',
    'stateCode',
    'cityCode',
    'villageCode',
  ];

  /// Only when the parent explicitly allows picking an existing org.
  /// Do not infer from [nationalId] — web create/add shows no org list for a
  /// customer who has not added a منشأة yet.
  bool get _canSelectExisting => widget.allowSelectExisting;

  bool get _editExisting {
    if (widget.viewOnly) return false;
    if (widget.editExisting) return true;
    return _review && (_selectedOrgId ?? _store.text('orgId')).trim().isNotEmpty;
  }

  bool _isLocked(String key) =>
      widget.viewOnly ||
      _alwaysLocked.contains(key) ||
      (_editExisting && _lockedOnEdit.contains(key));

  @override
  void initState() {
    super.initState();
    _organizations = List.of(widget.organizations);
    _review = widget.initial != null;
    final initial = widget.initial?.values ?? const {};
    for (final key in _keys) {
      _store.field(key, initial[key] ?? '');
    }
    _setPartners(widget.initial?.partners ?? const []);
    final initialOrgId = (initial['orgId'] ?? '').trim();
    if (initialOrgId.isNotEmpty) _selectedOrgId = initialOrgId;
    if (widget.nationalId != null &&
        (initial['custIdno'] ?? '').trim().isEmpty) {
      _store.field('custIdno', widget.nationalId!);
    }
    if (!widget.viewOnly && _canSelectExisting && _organizations.isEmpty) {
      _loadOrganizations();
    }
    if (!widget.viewOnly) {
      _loadLookups();
      _ensureOwnerPrefill();
    }
  }

  Future<void> _ensureOwnerPrefill() async {
    final id = (_store.text('custIdno').isNotEmpty
            ? _store.text('custIdno')
            : (widget.nationalId ?? ''))
        .trim();
    if (id.length != 14) return;
    if (_store.text('custIdno').isEmpty) {
      _store.field('custIdno').text = id;
    }
    if (_store.text('ownerName').trim().isNotEmpty) return;
    try {
      final names = await _clientApi.customerNames(id);
      if (!mounted || names.isEmpty) return;
      final fullName = (names.first['fullName'] ?? '').trim();
      if (fullName.isEmpty) return;
      setState(() => _store.field('ownerName').text = fullName);
    } catch (_) {}
  }

  Future<void> _loadLookups() async {
    setState(() => _lookupsBusy = true);
    try {
      final results = await Future.wait([
        _lookupsApi.orgTypes(),
        _lookupsApi.economy3(),
        _lookupsApi.companyCategories(),
        _lookupsApi.placeTypes(),
        _lookupsApi.placeOwnerships(),
        _clientApi.customerFormLookups(),
      ]);
      if (!mounted) return;
      final clientLookups = results[5] as ClientLookups;
      setState(() {
        _orgTypes = results[0] as List<OrgLookupItem>;
        _economy3 = results[1] as List<OrgLookupItem>;
        _companyCategories = results[2] as List<OrgLookupItem>;
        _placeTypes = results[3] as List<OrgLookupItem>;
        _placeOwnerships = results[4] as List<OrgLookupItem>;
        _states = clientLookups.states;
        _lookupsBusy = false;
      });
      await _hydrateAddressLists();
    } catch (_) {
      if (!mounted) return;
      setState(() => _lookupsBusy = false);
    }
  }

  Future<void> _hydrateAddressLists() async {
    final stateName = _store.text('stateName').trim();
    if (stateName.isEmpty || _states.isEmpty) return;
    AddressPlace? state;
    for (final item in _states) {
      if (item.name == stateName) {
        state = item;
        break;
      }
    }
    if (state == null) return;
    if (_store.text('stateCode').isEmpty) {
      _store.field('stateCode').text = state.stateId;
    }
    if (_store.text('regionId').isEmpty && state.regionId.isNotEmpty) {
      _store.field('regionId').text = state.regionId;
    }
    try {
      final cities = await _clientApi.cities(state);
      if (!mounted) return;
      setState(() => _cities = cities);
      final cityName = _store.text('cityName').trim();
      AddressPlace? city;
      for (final item in cities) {
        if (item.name == cityName) {
          city = item;
          break;
        }
      }
      if (city == null) return;
      if (_store.text('cityCode').isEmpty) {
        _store.field('cityCode').text = city.cityId;
      }
      final villages = await _clientApi.villages(state: state, city: city);
      if (!mounted) return;
      setState(() => _villages = villages);
      final villageName = _store.text('villageName').trim();
      for (final item in villages) {
        if (item.name == villageName && _store.text('villageCode').isEmpty) {
          _store.field('villageCode').text = item.cityId;
          break;
        }
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _store.dispose();
    for (final store in _partnerStores) {
      store.dispose();
    }
    super.dispose();
  }

  void _setPartners(List<Map<String, String>> partners) {
    for (final store in _partnerStores) {
      store.dispose();
    }
    _partnerStores.clear();
    final rows = partners.isEmpty ? [const <String, String>{}] : partners;
    for (final row in rows) {
      final store = FormStore();
      for (final key in _partnerFieldKeys) {
        store.field(key, row[key] ?? '');
      }
      _partnerStores.add(store);
    }
  }

  void _addPartner() {
    if (widget.viewOnly) return;
    setState(() {
      final store = FormStore();
      for (final key in _partnerFieldKeys) {
        store.field(key, '');
      }
      _partnerStores.add(store);
      _open.add('partners');
    });
  }

  void _removePartner(int index) {
    if (widget.viewOnly) return;
    if (_partnerStores.length <= 1) {
      // Keep one blank optional row instead of deleting the section.
      setState(() {
        for (final key in _partnerFieldKeys) {
          _partnerStores.first.field(key).clear();
        }
      });
      return;
    }
    setState(() {
      _partnerStores.removeAt(index).dispose();
    });
  }

  bool _partnerRowHasData(FormStore store) {
    for (final key in _partnerFieldKeys) {
      if (store.text(key).trim().isNotEmpty) return true;
    }
    return false;
  }

  Future<void> _loadOrganizations() async {
    final id = widget.nationalId?.trim() ?? '';
    if (id.length != 14) return;
    setState(() => _orgBusy = true);
    try {
      final rows = await _api.organizationsByCustNationalId(id);
      if (!mounted) return;
      setState(() {
        _organizations = [
          for (final row in rows)
            if (EstablishmentOrgOption.tryParse(row) case final option?)
              option,
        ];
        _orgBusy = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _orgBusy = false);
      showAuthError(context, error);
    }
  }

  void _applyInfo(EstablishmentInfo info, {required bool review}) {
    for (final key in _keys) {
      _store.field(key).text = info.values[key] ?? '';
    }
    _setPartners(info.partners);
    final orgId = info.orgId.trim();
    _selectedOrgId = orgId.isEmpty ? null : orgId;
    _review = review;
    _open.clear();
    _cities = const [];
    _villages = const [];
    _hydrateAddressLists();
  }

  Future<void> _selectExistingOrganization() async {
    if (_organizations.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('لا توجد منشآت مرتبطة بهذا الرقم القومي'),
          ),
        );
      return;
    }
    final labels = _organizations.map((org) => org.name).toList();
    String? selectedName;
    for (final org in _organizations) {
      if (org.id == _selectedOrgId) {
        selectedName = org.name;
        break;
      }
    }
    final choice = await showChoiceDialog(
      context: context,
      title: 'المنشأة',
      options: labels,
      selected: selectedName,
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
    await _loadOrganizationDetail(match);
  }

  Future<void> _loadOrganizationDetail(EstablishmentOrgOption org) async {
    setState(() => _orgBusy = true);
    try {
      final detail = await _api.organizationById(org.id);
      List<Map<String, dynamic>> partners = const [];
      try {
        partners = await _api.organizationPartners(org.id);
      } catch (_) {}
      if (!mounted) return;
      final info = EstablishmentInfo.fromOrganizationDetail(
        detail,
        partners: partners,
      );
      final withName = info.name.trim().isEmpty
          ? EstablishmentInfo({
              ...info.values,
              'name': org.name,
              'orgId': org.id,
            }, partners: info.partners)
          : EstablishmentInfo({
              ...info.values,
              if (info.orgId.isEmpty) 'orgId': org.id,
            }, partners: info.partners);
      setState(() {
        _applyInfo(withName, review: true);
        _orgBusy = false;
        _showErrors = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _orgBusy = false);
      showAuthError(context, error);
    }
  }

  void _startNewOrganization() {
    setState(() {
      _applyInfo(const EstablishmentInfo({}), review: false);
      if (widget.nationalId != null) {
        _store.field('custIdno').text = widget.nationalId!;
      }
      _showErrors = false;
    });
  }

  Future<void> _viewSelectedOrganization() async {
    final orgId = (_selectedOrgId ?? _store.text('orgId')).trim();
    if (orgId.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('برجاء اختيار منشأة أولاً')),
        );
      return;
    }
    EstablishmentOrgOption? match;
    for (final org in _organizations) {
      if (org.id == orgId) {
        match = org;
        break;
      }
    }
    match ??= EstablishmentOrgOption(
      id: orgId,
      name: _store.text('name').isEmpty ? orgId : _store.text('name'),
    );
    await _loadOrganizationDetail(match);
  }

  bool get _hasExistingOrgSelection =>
      (_selectedOrgId ?? _store.text('orgId')).trim().isNotEmpty;

  bool get _emailsValid =>
      FmcValidation.emailLive(_store.text('email')) == null &&
      FmcValidation.emailLive(_store.text('contactEmail')) == null;

  bool get _canAdd {
    if (!_emailsValid) return false;
    if (_hasExistingOrgSelection || _editExisting) {
      return FmcValidation.required(_store.text('name')) == null &&
          FmcValidation.required(
                _store.text('regNo').isEmpty
                    ? _store.text('registerNumber')
                    : _store.text('regNo'),
              ) ==
              null;
    }
    final requiredKeys = [
      'name',
      'orgTypeDescr',
      'econCode3Descr',
      'orgDescr',
      'regNo',
      'practiceStartDate',
      'contactPhone',
      'placeTypeDescr',
      'stateName',
      'cityName',
      'villageName',
      'street',
    ];
    for (final key in requiredKeys) {
      final value = key == 'contactPhone' && _store.text(key).isEmpty
          ? _store.text('phone')
          : _store.text(key);
      if (key == 'contactPhone' || key == 'phone') {
        if (FmcValidation.requiredMobile(value) != null) return false;
      } else if (FmcValidation.required(value) != null) {
        return false;
      }
    }
    // بيانات الشركاء optional — empty rows are ignored on save.
    return true;
  }

  String get _selectedOrganizationLabel {
    final selectedId = (_selectedOrgId ?? _store.text('orgId')).trim();
    if (selectedId.isNotEmpty) {
      for (final org in _organizations) {
        if (org.id == selectedId) return org.name;
      }
    }
    final name = _store.text('name').trim();
    if (name.isNotEmpty) return name;
    return '';
  }

  void _toggle(String key) => setState(() {
    // Accordion: one open section at a time for readable org browsing.
    if (_open.contains(key)) {
      _open.remove(key);
      return;
    }
    _open
      ..clear()
      ..add(key);
  });

  Future<void> _pickDate(String key, String title) async {
    if (_isLocked(key)) return;
    final value = await pickFlowDate(
      context,
      currentValue: _store.text(key),
      title: title,
    );
    if (!mounted || value == null) return;
    setState(() => _store.field(key).text = value);
  }

  Future<void> _pickPartnerDate(FormStore store, int index) async {
    if (widget.viewOnly) return;
    final value = await pickFlowDate(
      context,
      currentValue: store.text('partnerBirth'),
      title: 'تاريخ ميلاد الشريك',
    );
    if (!mounted || value == null) return;
    setState(() => store.field('partnerBirth').text = value);
  }

  String _addressLine() {
    final building = _store.text('buildingNo');
    final street = _store.text('street');
    final village = _store.text('villageName');
    final city = _store.text('cityName');
    final state = _store.text('stateName');
    final composed =
        '$building  $street - $village - $city - $state'.trim();
    final existing = _store.text('addTxt').trim();
    if (existing.isNotEmpty &&
        street.isEmpty &&
        village.isEmpty &&
        city.isEmpty &&
        state.isEmpty) {
      return existing;
    }
    return composed.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  Future<void> _submit({required bool saved}) async {
    if (!_canAdd) {
      setState(() => _showErrors = true);
      return;
    }
    final addTxt = _addressLine();
    if (addTxt.isNotEmpty) {
      _store.field('addTxt').text = addTxt;
      _store.field('address').text = addTxt;
    }
    if (_store.text('registerNumber').isEmpty) {
      _store.field('registerNumber').text = _store.text('regNo');
    }
    if (_store.text('phone').isEmpty) {
      _store.field('phone').text = _store.text('contactPhone');
    }
    if (_store.text('activity').isEmpty) {
      _store.field('activity').text = _store.text('orgDescr');
    }
    if (_store.text('foundingDate').isEmpty) {
      _store.field('foundingDate').text = _store.text('practiceStartDate');
    }
    // Keep codes for PUT when UI shows Arabic Descr labels.
    if (_store.text('companyCategory').isEmpty &&
        _store.text('companyCategoryDescr').isNotEmpty) {
      final descr = _store.text('companyCategoryDescr');
      // Prefer original code; if user typed a single letter category keep it.
      if (descr.length == 1) {
        _store.field('companyCategory').text = descr;
      }
    }
    final partners = [
      for (final store in _partnerStores)
        if (_partnerRowHasData(store))
          {for (final key in _partnerFieldKeys) key: store.text(key)},
    ];
    // Keep first partner mirrored on root values for older callers.
    final first = partners.isEmpty ? const <String, String>{} : partners.first;
    final values = {
      for (final key in _keys) key: _store.text(key),
      ...first,
    };
    var info = EstablishmentInfo(values, partners: partners);

    final orgId = values['orgId']?.trim() ?? '';
    try {
      if (_editExisting || (saved && orgId.isNotEmpty)) {
        // Web updateOrg — PUT
        await _api.saveOrganization(values: values, partners: partners);
      } else {
        // Web addOrg — POST so the منشأة is linked to the national ID
        // and appears again when the create form reloads the customer.
        final createdId = await _api.createOrganization(
          values: values,
          partners: partners,
        );
        info = EstablishmentInfo({
          ...values,
          'orgId': createdId,
          if ((values['registerNumber'] ?? '').trim().isEmpty)
            'registerNumber': (values['regNo'] ?? '').trim().isNotEmpty
                ? values['regNo']!.trim()
                : createdId,
        }, partners: partners);
      }
    } catch (error) {
      if (!mounted) return;
      showAuthError(context, error);
      return;
    }

    if (!mounted) return;
    await showFlowSuccess(
      context,
      message: saved
          ? 'لقد تم الحفظ بنجاح'
          : 'لقد قمت باضافة منشأة لطلب التمويل بنجاح',
      note: saved ? null : 'برجاء إستكمال باقي البيانات لانشاء طلب التمويل',
    );
    if (!mounted) return;
    Navigator.of(context).pop(info);
  }

  @override
  Widget buildWidget(
    BuildContext context,
    RenderDataState<EstablishmentDataModel> state,
  ) {
    return FlowScaffold(
      pageTitle: 'بيانات المنشأة',
      pageIcon: Icons.storefront_outlined,
      body: FlowBody(
        footer: widget.viewOnly
            ? null
            : _review || _editExisting
                ? FlowSaveButton(
                    enabled: true,
                    onPressed: () => _submit(saved: true),
                  )
                : FlowActionButton(
                    label: 'اضافة',
                    enabled: true,
                    onPressed: () => _submit(saved: false),
                  ),
        children: [
          if (_canSelectExisting && !widget.viewOnly && !widget.editExisting) ...[
            _OrganizationPicker(
              label: _selectedOrganizationLabel,
              busy: _orgBusy,
              hasSelection:
                  (_selectedOrgId ?? _store.text('orgId')).trim().isNotEmpty,
              onSelect: _selectExistingOrganization,
              onAdd: _startNewOrganization,
              onView: _viewSelectedOrganization,
            ),
            SizedBox(height: 14.h),
          ],
          FocusScope(
            canRequestFocus: !widget.viewOnly,
            child: Column(
                  children: [
                    FlowSection(
                      title: 'بيانات المنشأة',
                      step: '١',
                      expanded: _open.contains('info'),
                      onToggle: () => _toggle('info'),
                      child: Column(
                        children: [
                          _labeled('إسم المنشأة', 'name', 'ادخل اسم المنشأة'),
                          SizedBox(height: 12.h),
                          _labeled(
                            'رقم المنشأة',
                            'orgId',
                            'رقم المنشأة',
                            locked: true,
                          ),
                          SizedBox(height: 12.h),
                          _choice(
                            'نوع المنشأة',
                            descrKey: 'orgTypeDescr',
                            codeKey: 'orgType',
                            hint: 'نوع المنشأة',
                            items: _orgTypes,
                          ),
                          SizedBox(height: 12.h),
                          _labeled(
                            'القطاع الإقتصادي',
                            'econCode1Descr',
                            'القطاع الإقتصادي',
                            locked: true,
                          ),
                          SizedBox(height: 12.h),
                          _labeled(
                            'القطاع التحليلي',
                            'econCode2Descr',
                            'القطاع التحليلي',
                            locked: true,
                          ),
                          SizedBox(height: 12.h),
                          _choice(
                            'القطاع الفرعي',
                            descrKey: 'econCode3Descr',
                            codeKey: 'econCode3',
                            hint: 'القطاع الفرعي',
                            items: _economy3,
                            onSelected: _onEconomy3Selected,
                          ),
                          SizedBox(height: 12.h),
                          _labeled(
                            'وصف طبيعة المنشأة',
                            'orgDescr',
                            'وصف طبيعة المنشأة',
                          ),
                        ],
                      ),
                    ),
                    FlowSection(
                      title: 'بيانات التأسيس',
                      step: '٢',
                      expanded: _open.contains('founding'),
                      onToggle: () => _toggle('founding'),
                      child: Column(
                        children: [
                          _labeled(
                            'الرقم الضريبي',
                            'taxFileNo',
                            'الرقم الضريبي',
                            digits: true,
                            optional: true,
                          ),
                          SizedBox(height: 12.h),
                          _labeled('رقم السجل', 'regNo', 'رقم السجل'),
                          SizedBox(height: 12.h),
                          _dateField(
                            'تاريخ السجل',
                            'regIssueDate',
                            optional: true,
                          ),
                          SizedBox(height: 12.h),
                          _dateField(
                            'تاريخ نهاية السجل',
                            'regExpDate',
                            optional: true,
                          ),
                          SizedBox(height: 12.h),
                          _dateField(
                            'تاريخ مزاولة النشاط',
                            'practiceStartDate',
                          ),
                          SizedBox(height: 12.h),
                          _labeled(
                            'رأس مال المنشأة',
                            'orgCapital',
                            'رأس مال المنشأة',
                            digits: true,
                            optional: true,
                          ),
                          SizedBox(height: 12.h),
                          _labeled(
                            'عدد العاملين',
                            'countEmployees',
                            'عدد العاملين',
                            digits: true,
                            optional: true,
                          ),
                          SizedBox(height: 12.h),
                          _choice(
                            'تصنيف حجم المؤسسة',
                            descrKey: 'companyCategoryDescr',
                            codeKey: 'companyCategory',
                            hint: 'تصنيف حجم المؤسسة',
                            items: _companyCategories,
                            optional: true,
                          ),
                        ],
                      ),
                    ),
                    FlowSection(
                      title: 'بيانات التواصل',
                      step: '٣',
                      expanded: _open.contains('contact'),
                      onToggle: () => _toggle('contact'),
                      child: Column(
                        children: [
                          _labeled(
                            'الرقم القومي لصاحب المنشأة',
                            'custIdno',
                            'الرقم القومي',
                            digits: true,
                            maxLength: 14,
                            locked: true,
                            rule: FmcValidation.requiredNationalId,
                          ),
                          SizedBox(height: 12.h),
                          _labeled(
                            'إسم صاحب المنشأة',
                            'ownerName',
                            'إسم صاحب المنشأة',
                            locked: true,
                          ),
                          SizedBox(height: 12.h),
                          _labeled(
                            'جهة التواصل',
                            'contactName',
                            'جهة التواصل',
                            optional: true,
                          ),
                          SizedBox(height: 12.h),
                          _labeled(
                            'موبايل',
                            'contactPhone',
                            '01xxxxxxxxx',
                            egyptianMobile: true,
                            maxLength: 11,
                            rule: FmcValidation.requiredMobile,
                          ),
                          SizedBox(height: 12.h),
                          _labeled(
                            'البريد الإلكتروني لجهة التواصل',
                            'contactEmail',
                            'example@example.com',
                            optional: true,
                            email: true,
                            rule: FmcValidation.emailLive,
                          ),
                          SizedBox(height: 12.h),
                          _labeled(
                            'موبايل 2',
                            'phone1',
                            '01xxxxxxxxx',
                            egyptianMobile: true,
                            maxLength: 11,
                            optional: true,
                            rule: FmcValidation.mobile,
                          ),
                          SizedBox(height: 12.h),
                          _labeled(
                            'تليفون ارضى',
                            'phone2',
                            'تليفون ارضى',
                            digits: true,
                            optional: true,
                          ),
                          SizedBox(height: 12.h),
                          _labeled(
                            'البريد الإلكتروني',
                            'email',
                            'example@example.com',
                            optional: true,
                            email: true,
                            rule: FmcValidation.emailLive,
                          ),
                        ],
                      ),
                    ),
                    FlowSection(
                      title: 'موقع المنشأة',
                      step: '٤',
                      expanded: _open.contains('location'),
                      onToggle: () => _toggle('location'),
                      child: Column(
                        children: [
                          _choice(
                            'نوع موقع المنشأة',
                            descrKey: 'placeTypeDescr',
                            codeKey: 'placeType',
                            hint: 'نوع موقع المنشأة',
                            items: _placeTypes,
                          ),
                          SizedBox(height: 12.h),
                          _choice(
                            'ملكية موقع المنشأة',
                            descrKey: 'placeOwnershipDescr',
                            codeKey: 'placeOwnership',
                            hint: 'ملكية موقع المنشأة',
                            items: _placeOwnerships,
                            optional: true,
                          ),
                          SizedBox(height: 12.h),
                          _labeled(
                            'عدد السنوات فى موقع المنشأة الحالى',
                            'placeNoOfYears',
                            'عدد السنوات',
                            digits: true,
                            optional: true,
                          ),
                        ],
                      ),
                    ),
                    FlowSection(
                      title: 'عنوان المنشأة',
                      step: '٥',
                      expanded: _open.contains('address'),
                      onToggle: () => _toggle('address'),
                      child: Column(
                        children: [
                          _detailBox('العنوان تفصيلي', _addressLine()),
                          _addressChoice(
                            'المحافظة',
                            nameKey: 'stateName',
                            hint: 'اختر المحافظة',
                            options: _states.map((e) => e.name).toList(),
                            onSelected: _onStateSelected,
                          ),
                          SizedBox(height: 12.h),
                          _addressChoice(
                            'المدينة',
                            nameKey: 'cityName',
                            hint: 'اختر المدينة',
                            options: _cities.map((e) => e.name).toList(),
                            onSelected: _onCitySelected,
                            enabled: _store.text('stateName').isNotEmpty,
                          ),
                          SizedBox(height: 12.h),
                          _addressChoice(
                            'المركز / القسم',
                            nameKey: 'villageName',
                            hint: 'اختر المركز / القسم',
                            options: _villages.map((e) => e.name).toList(),
                            onSelected: _onVillageSelected,
                            enabled: _store.text('cityName').isNotEmpty,
                          ),
                          SizedBox(height: 12.h),
                          _labeled(
                            'الشارع',
                            'street',
                            'الشارع',
                            maxLength: 30,
                          ),
                          SizedBox(height: 12.h),
                          _labeled(
                            'المبنى',
                            'buildingNo',
                            'المبنى',
                            maxLength: 20,
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(
                                child: _labeled(
                                  'الطابق',
                                  'floorNo',
                                  'الطابق',
                                  digits: true,
                                  maxLength: 10,
                                  optional: true,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: _labeled(
                                  'الشقة',
                                  'flatno',
                                  'الشقة',
                                  digits: true,
                                  maxLength: 10,
                                  optional: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          _labeled(
                            'علامة مميزة',
                            'addMark',
                            'علامة مميزة',
                            optional: true,
                          ),
                          SizedBox(height: 12.h),
                          _labeled(
                            'الرمز البريدي',
                            'postCode',
                            'الرمز البريدي',
                            digits: true,
                            optional: true,
                          ),
                        ],
                      ),
                    ),
                    FlowSection(
                      title: 'بيانات الشركاء',
                      step: '٦',
                      expanded: _open.contains('partners'),
                      onToggle: () => _toggle('partners'),
                      child: _partners(),
                    ),
                  ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _partners() {
    return Column(
      children: [
        for (var i = 0; i < _partnerStores.length; i++) ...[
          if (i > 0) SizedBox(height: 18.h),
          Row(
            textDirection: TextDirection.ltr,
            children: [
              if (!widget.viewOnly && _partnerStores.length > 1)
                IconButton(
                  onPressed: () => _removePartner(i),
                  icon: Icon(
                    Icons.delete_outline,
                    color: const Color(0xFFE14B4B),
                    size: 20.r,
                  ),
                )
              else
                const Spacer(),
              if (!widget.viewOnly && _partnerStores.length > 1)
                const Spacer(),
              Text(
                'الشريك ${_arabicOrdinal(i + 1)}',
                style: TextStyle(
                  color: const Color(0xFF3C92D6),
                  fontWeight: FontWeight.w800,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(width: 6.w),
              Icon(Icons.person, color: AppColors.accent, size: 18.r),
            ],
          ),
          SizedBox(height: 10.h),
          _partnerFields(_partnerStores[i], i),
        ],
        if (!widget.viewOnly) ...[
          SizedBox(height: 14.h),
          OutlinedButton.icon(
            onPressed: _addPartner,
            icon: const Icon(Icons.add_box_outlined),
            label: const Text('اضافة شريك'),
          ),
        ],
      ],
    );
  }

  Widget _partnerFields(FormStore store, int index) {
    return Column(
      children: [
        _partnerLabeled(
          store,
          'اسم الشريك',
          'partnerName',
          'ادخل اسم الشريك',
          optional: true,
        ),
        SizedBox(height: 12.h),
        _partnerLabeled(
          store,
          'الرقم القومي للشريك',
          'partnerId',
          'ادخل الرقم القومي المكون من 14 رقم',
          digits: true,
          maxLength: 14,
          optional: true,
          rule: (value) {
            final text = (value ?? '').trim();
            if (text.isEmpty) return null;
            return FmcValidation.requiredNationalId(text);
          },
        ),
        SizedBox(height: 12.h),
        FlowChoiceField(
          label: 'تاريخ الميلاد',
          value: store.text('partnerBirth'),
          hint: '00/00/0000',
          locked: widget.viewOnly,
          error: null,
          reserveErrorSpace: false,
          onTap: () => _pickPartnerDate(store, index),
        ),
        SizedBox(height: 12.h),
        FlowChoiceField(
          label: 'الجنسية',
          value: store.text('partnerNationality'),
          hint: 'الجنسية',
          locked: widget.viewOnly,
          error: null,
          reserveErrorSpace: false,
          onTap: () async {
            if (widget.viewOnly) return;
            final choice = await showChoiceDialog(
              context: context,
              title: 'الجنسية',
              options: const ['مصري'],
              selected: store.text('partnerNationality').isEmpty
                  ? null
                  : store.text('partnerNationality'),
            );
            if (!mounted || choice == null) return;
            setState(() => store.field('partnerNationality').text = choice);
          },
        ),
        SizedBox(height: 12.h),
        _partnerLabeled(
          store,
          'مهامه بالشركة',
          'partnerRole',
          'ادخل مهامه بالشركة',
          optional: true,
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _partnerLabeled(
                store,
                'نسبة الشراكة',
                'partnerShare',
                'نسبة الشراكة',
                digits: true,
                optional: true,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _partnerLabeled(
                store,
                'قيمة الشراكة',
                'partnerValue',
                'قيمة الشراكة',
                digits: true,
                optional: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _arabicOrdinal(int n) {
    const labels = [
      'الاول',
      'الثاني',
      'الثالث',
      'الرابع',
      'الخامس',
      'السادس',
      'السابع',
      'الثامن',
      'التاسع',
      'العاشر',
    ];
    if (n >= 1 && n <= labels.length) return labels[n - 1];
    return '$n';
  }

  Widget _detailBox(String title, String body) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F3FC),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF3C92D6),
              fontWeight: FontWeight.w800,
              fontSize: 13.sp,
            ),
          ),
          Text(
            body.isEmpty ? '—' : body,
            textAlign: TextAlign.right,
            style: TextStyle(color: const Color(0xFF3C92D6), fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  String? _error(String? message) => _showErrors ? message : null;

  OrgLookupItem? _itemByLabel(List<OrgLookupItem> items, String label) {
    final text = label.trim();
    if (text.isEmpty) return null;
    for (final item in items) {
      if (item.label == text || item.code == text) return item;
    }
    return null;
  }

  Future<void> _onEconomy3Selected(OrgLookupItem item) async {
    setState(() {
      _store.field('econCode3').text = item.code;
      _store.field('econCode3Descr').text = item.label;
      _store.field('econCode1').clear();
      _store.field('econCode1Descr').clear();
      _store.field('econCode2').clear();
      _store.field('econCode2Descr').clear();
    });
    try {
      final parents = await _lookupsApi.economy3Enhanced(item.code);
      if (!mounted || parents == null) return;
      setState(() {
        _store.field('econCode1').text = parents.code1;
        _store.field('econCode1Descr').text =
            parents.name1.isEmpty ? parents.code1 : parents.name1;
        _store.field('econCode2').text = parents.code2;
        _store.field('econCode2Descr').text =
            parents.name2.isEmpty ? parents.code2 : parents.name2;
        if (parents.name3.isNotEmpty) {
          _store.field('econCode3Descr').text = parents.name3;
        }
      });
    } catch (_) {}
  }

  Future<void> _onStateSelected(String name) async {
    AddressPlace? state;
    for (final item in _states) {
      if (item.name == name) {
        state = item;
        break;
      }
    }
    setState(() {
      _store.field('stateName').text = name;
      _store.field('stateCode').text = state?.stateId ?? '';
      _store.field('regionId').text = state?.regionId ?? '';
      _store.field('cityName').clear();
      _store.field('cityCode').clear();
      _store.field('villageName').clear();
      _store.field('villageCode').clear();
      _cities = const [];
      _villages = const [];
    });
    if (state == null) return;
    try {
      final cities = await _clientApi.cities(state);
      if (!mounted) return;
      setState(() => _cities = cities);
    } catch (_) {}
  }

  Future<void> _onCitySelected(String name) async {
    AddressPlace? state;
    for (final item in _states) {
      if (item.name == _store.text('stateName')) {
        state = item;
        break;
      }
    }
    AddressPlace? city;
    for (final item in _cities) {
      if (item.name == name) {
        city = item;
        break;
      }
    }
    setState(() {
      _store.field('cityName').text = name;
      _store.field('cityCode').text = city?.cityId ?? '';
      _store.field('villageName').clear();
      _store.field('villageCode').clear();
      _villages = const [];
    });
    if (state == null || city == null) return;
    try {
      final villages = await _clientApi.villages(state: state, city: city);
      if (!mounted) return;
      setState(() => _villages = villages);
    } catch (_) {}
  }

  void _onVillageSelected(String name) {
    AddressPlace? village;
    for (final item in _villages) {
      if (item.name == name) {
        village = item;
        break;
      }
    }
    setState(() {
      _store.field('villageName').text = name;
      _store.field('villageCode').text = village?.cityId ?? '';
    });
  }

  Widget _choice(
    String label, {
    required String descrKey,
    required String codeKey,
    required String hint,
    required List<OrgLookupItem> items,
    Future<void> Function(OrgLookupItem item)? onSelected,
    bool optional = false,
  }) {
    final locked = _isLocked(descrKey) || widget.viewOnly;
    final value = _store.text(descrKey);
    return FlowChoiceField(
      label: label,
      value: value,
      hint: _lookupsBusy && items.isEmpty ? 'جاري التحميل…' : hint,
      locked: locked,
      error: locked || optional
          ? null
          : _error(FmcValidation.required(value)),
      reserveErrorSpace: locked || optional ? false : _showErrors,
      onTap: () async {
        if (locked) return;
        final labels = [for (final item in items) item.label];
        if (labels.isEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('لا توجد خيارات متاحة حالياً')),
            );
          return;
        }
        final choice = await showChoiceDialog(
          context: context,
          title: label,
          options: labels,
          selected: value.isEmpty ? null : value,
          searchable: true,
          searchHint: 'بحث…',
        );
        if (!mounted || choice == null) return;
        final item = _itemByLabel(items, choice);
        if (item == null) return;
        if (onSelected != null) {
          await onSelected(item);
          return;
        }
        setState(() {
          _store.field(codeKey).text = item.code;
          _store.field(descrKey).text = item.label;
          if (codeKey == 'placeType') {
            _store.field('location').text = item.label;
          }
        });
      },
    );
  }

  Widget _addressChoice(
    String label, {
    required String nameKey,
    required String hint,
    required List<String> options,
    required void Function(String name) onSelected,
    bool enabled = true,
  }) {
    final locked = widget.viewOnly || !enabled;
    final value = _store.text(nameKey);
    return FlowChoiceField(
      label: label,
      value: value,
      hint: hint,
      locked: locked,
      error: locked ? null : _error(FmcValidation.required(value)),
      reserveErrorSpace: locked ? false : _showErrors,
      onTap: () async {
        if (locked) return;
        if (options.isEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  enabled
                      ? 'لا توجد خيارات متاحة حالياً'
                      : 'اختر المحافظة أولاً',
                ),
              ),
            );
          return;
        }
        final choice = await showChoiceDialog(
          context: context,
          title: label,
          options: options,
          selected: value.isEmpty ? null : value,
          searchable: true,
          searchHint: 'بحث…',
        );
        if (!mounted || choice == null) return;
        onSelected(choice);
      },
    );
  }

  Widget _dateField(String label, String key, {bool optional = false}) {
    final locked = _isLocked(key);
    return FlowChoiceField(
      label: label,
      value: _store.text(key),
      hint: '00/00/0000',
      locked: locked,
      error: locked || optional
          ? null
          : _error(FmcValidation.required(_store.text(key))),
      reserveErrorSpace: locked || optional ? false : _showErrors,
      onTap: () => _pickDate(key, label),
    );
  }

  Widget _labeled(
    String label,
    String key,
    String hint, {
    bool digits = false,
    bool email = false,
    bool egyptianMobile = false,
    int? maxLength,
    bool locked = false,
    bool optional = false,
    String? Function(String? value)? rule,
  }) {
    final dimmed = widget.viewOnly || locked || _isLocked(key);
    String? Function(String? value)? effectiveRule = rule;
    if (optional && rule == null) {
      effectiveRule = (_) => null;
    }
    final value = _store.text(key);
    final message = dimmed
        ? null
        : (effectiveRule ?? FmcValidation.required)(value);
    final showError = email
        ? (message != null && value.isNotEmpty)
        : (_showErrors && message != null);
    return Column(
      children: [
        FlowLabel(label),
        SizedBox(height: 6.h),
        FlowTextField(
          controller: _store.field(key),
          hint: hint,
          digitsOnly: digits && !egyptianMobile,
          emailOnly: email,
          egyptianMobile: egyptianMobile,
          maxLength: maxLength ?? (email ? 100 : null),
          keyboardType: egyptianMobile || digits
              ? TextInputType.phone
              : email
              ? TextInputType.emailAddress
              : TextInputType.text,
          readOnly: dimmed,
          error: showError ? message : null,
          reserveErrorSpace: dimmed
              ? false
              : email
              ? true
              : _showErrors,
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _partnerLabeled(
    FormStore store,
    String label,
    String key,
    String hint, {
    bool digits = false,
    int? maxLength,
    bool optional = true,
    String? Function(String? value)? rule,
  }) {
    final value = store.text(key);
    final message = widget.viewOnly
        ? null
        : optional && rule == null
            ? null
            : (rule ?? FmcValidation.required)(value);
    final showError = message != null && (optional ? value.isNotEmpty : _showErrors);
    return Column(
      children: [
        FlowLabel(label),
        SizedBox(height: 6.h),
        FlowTextField(
          controller: store.field(key),
          hint: hint,
          digitsOnly: digits,
          maxLength: maxLength,
          keyboardType: digits ? TextInputType.number : TextInputType.text,
          readOnly: widget.viewOnly,
          error: showError ? message : null,
          reserveErrorSpace: false,
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  @override
  void listenToState(BuildContext context, BaseStates state) {}

  @override
  EstablishmentDataBloc createBloc() =>
      EstablishmentDataBloc(EstablishmentDataModel());
}

class _OrganizationPicker extends StatelessWidget {
  const _OrganizationPicker({
    required this.label,
    required this.busy,
    required this.hasSelection,
    required this.onSelect,
    required this.onAdd,
    required this.onView,
  });

  final String label;
  final bool busy;
  final bool hasSelection;
  final VoidCallback onSelect;
  final VoidCallback onAdd;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: Text(
                  'المنشأة',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: const Color(0xFF032F64),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'عرض بيانات المنشأة',
                onPressed: busy || !hasSelection ? null : onView,
                icon: Icon(
                  Icons.visibility_outlined,
                  color: hasSelection
                      ? AppColors.accent
                      : const Color(0xFFC5CED6),
                  size: 22.r,
                ),
              ),
              IconButton(
                tooltip: 'اضافة منشأة جديدة',
                onPressed: busy ? null : onAdd,
                icon: Icon(Icons.add, color: AppColors.accent, size: 24.r),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          InkWell(
            onTap: busy ? null : onSelect,
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: const Color(0xFFD5DDE6)),
              ),
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: const Color(0xFF9AA8B8),
                    size: 22.r,
                  ),
                  Expanded(
                    child: Text(
                      label.isEmpty ? 'اختر منشأة موجودة' : label,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: label.isEmpty
                            ? const Color(0xFF9AA8B8)
                            : const Color(0xFF2C2C2C),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (busy) ...[
            SizedBox(height: 8.h),
            Row(
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
                  'جاري تحميل بيانات المنشأة…',
                  style: TextStyle(
                    color: AppColors.fieldLabel,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
