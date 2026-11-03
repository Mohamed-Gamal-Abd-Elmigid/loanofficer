import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/client_api.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/validation/fmc_validation.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';

import 'package:loanofficer/core/bases/base_state.dart';
import 'package:loanofficer/core/bases/states/base/base_state.dart';
import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/client_data/bloc/client_data_bloc.dart';
import 'package:loanofficer/presenter/client_data/model/client_data_model.dart';

class ClientInfo {
  const ClientInfo(this.values, {this.clientId});

  final Map<String, String> values;
  final String? clientId;

  String get nationalId => values['nationalId'] ?? '';
  String get clientNumber => values['clientNumber'] ?? '';
  String get fullName => values['fullName'] ?? '';
}

enum _ClientSection { id, basic, home, card, contact }

const _clientSectionMenu = [
  (_ClientSection.id, 'بطاقة الرقم القومي', '١'),
  (_ClientSection.basic, 'البيانات الاساسية', '٢'),
  (_ClientSection.home, 'عنوان الاقامة', '٣'),
  (_ClientSection.card, 'عنوان البطاقة', '٤'),
  (_ClientSection.contact, 'بيانات التواصل', '٥'),
];

const _basicKeys = [
  'clientNumber',
  'fullName',
  'first',
  'second',
  'third',
  'fourth',
  'nickname',
  'birth',
  'issue',
  'gender',
  'health',
  'job',
  'religion',
  'nationality',
  'marital',
  'children',
  'education',
];

/// Optional on save (web parity): nickname, job, postal codes.
const _optionalBasicKeys = {'nickname', 'job'};
const _optionalAddressSuffixes = {'Postal'};
const _arabicNameKeys = {'first', 'second', 'third', 'fourth'};

bool _sectionReady(
  FormStore store,
  _ClientSection section, {
  bool newCustomer = false,
}) {
  return _missingFields(store, section, newCustomer: newCustomer).isEmpty;
}

const _basicLabels = {
  'clientNumber': 'رقم العميل',
  'fullName': 'الاسم بالكامل',
  'first': 'الاسم الاول',
  'second': 'الاسم الثاني',
  'third': 'الاسم الثالث',
  'fourth': 'الاسم الرابع',
  'nickname': 'الاسم المستعار',
  'birth': 'تاريخ الميلاد',
  'issue': 'تاريخ اصدار البطاقة',
  'gender': 'النوع',
  'health': 'الحالة الصحية',
  'job': 'وظيفة العميل',
  'religion': 'الديانة',
  'nationality': 'الجنسية',
  'marital': 'الحالة الاجتماعية',
  'children': 'عدد الاطفال',
  'education': 'المؤهل الدراسي',
};

const _addressLabels = {
  'Governorate': 'المحافظة',
  'City': 'المدينة',
  'District': 'المركز / القسم',
  'Street': 'الشارع',
  'Building': 'المبنى',
  'Floor': 'الطابق',
  'Apartment': 'الشقة',
  'Landmark': 'علامة مميزة',
  'Postal': 'الرمز البريدي',
};

List<String> _missingFields(
  FormStore store,
  _ClientSection section, {
  bool newCustomer = false,
}) {
  return switch (section) {
    _ClientSection.id =>
      FmcValidation.requiredNationalId(store.text('nationalId')) == null
          ? const <String>[]
          : const ['الرقم القومي'],
    _ClientSection.basic => [
      for (final key in _basicKeys)
        if (!(newCustomer && key == 'clientNumber'))
          if (!_optionalBasicKeys.contains(key))
            if (_arabicNameKeys.contains(key)
                ? FmcValidation.requiredArabicNamePart(store.text(key)) != null
                : store.text(key).trim().isEmpty)
              _basicLabels[key]!,
    ],
    _ClientSection.home => _missingAddress(store, 'res'),
    _ClientSection.card => _missingAddress(store, 'card'),
    _ClientSection.contact => [
      if (FmcValidation.requiredMobile(store.text('phone1')) != null)
        'تليفون 1',
      if (store.text('phone2').trim().isNotEmpty &&
          FmcValidation.mobile(store.text('phone2')) != null)
        'تليفون 2',
      if (FmcValidation.emailLive(store.text('email')) != null)
        'البريد الالكتروني',
    ],
  };
}

List<String> _missingAddress(FormStore store, String prefix) {
  return [
    for (final entry in _addressLabels.entries)
      if (!_optionalAddressSuffixes.contains(entry.key))
        if (store.text('$prefix${entry.key}').trim().isEmpty) entry.value,
  ];
}

/// Same split Fusion uses when loading `fullname` from CIF.
void applyFullNameParts(FormStore store, String fullName) {
  final parts = fullName
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  String partAt(int index) => index < parts.length ? parts[index] : '';
  store.field('first').text = partAt(0);
  store.field('second').text = partAt(1);
  store.field('third').text = partAt(2);
  store.field('fourth').text = partAt(3);
}

/// Join first–fourth name parts into الاسم بالكامل (new-customer flow).
void composeFullNameFromParts(FormStore store) {
  final parts = [
    store.text('first'),
    store.text('second'),
    store.text('third'),
    store.text('fourth'),
  ].map((part) => part.trim()).where((part) => part.isNotEmpty);
  store.field('fullName').text = parts.join(' ');
}

class ClientDataScene extends StatefulWidget {
  const ClientDataScene({
    super.key,
    this.initial,
    this.lookups,
    this.newCustomer = false,
    this.viewOnly = false,
    this.addressSectionsOnly = false,
  });

  final ClientInfo? initial;
  final ClientLookups? lookups;
  final bool newCustomer;

  /// Read-only browse of all customer sections (no save).
  final bool viewOnly;

  /// Only «عنوان الإقامة» and «عنوان البطاقة» — edit per section, no full-form footer.
  final bool addressSectionsOnly;

  @override
  State<ClientDataScene> createState() => _ClientDataSceneState();
}

class _ClientDataSceneState
    extends BaseState<ClientDataScene, ClientDataBloc, ClientDataModel> {
  final _store = FormStore();
  final _api = ClientApi();
  bool _review = false;
  bool _details = false;
  bool _showErrors = false;
  String? _clientId;
  ClientLookups? _lookups;

  static const _keys = [
    'nationalId',
    'clientNumber',
    'fullName',
    'first',
    'second',
    'third',
    'fourth',
    'nickname',
    'birth',
    'issue',
    'expiry',
    'gender',
    'health',
    'job',
    'religion',
    'nationality',
    'marital',
    'children',
    'education',
    'resGovernorate',
    'resCity',
    'resDistrict',
    'resStreet',
    'resBuilding',
    'resFloor',
    'resApartment',
    'resLandmark',
    'resPostal',
    'cardGovernorate',
    'cardCity',
    'cardDistrict',
    'cardStreet',
    'cardBuilding',
    'cardFloor',
    'cardApartment',
    'cardLandmark',
    'cardPostal',
    'phone1',
    'phone2',
    'email',
  ];

  @override
  void initState() {
    super.initState();
    _lookups = widget.lookups;
    _review = widget.initial != null && !widget.newCustomer;
    _clientId = widget.initial?.clientId;
    final initial = widget.initial?.values ?? const {};
    for (final key in _keys) {
      _store.field(key, initial[key] ?? '');
    }
    if (widget.newCustomer) _details = true;
    if (_review) _details = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_lookups == null) {
        await _ensureLookups();
      } else {
        _resolveLookupLabels();
      }
      if (_review &&
          FmcValidation.requiredNationalId(_store.text('nationalId')) == null) {
        await _reload();
      }
    });
  }

  Future<void> _ensureLookups() async {
    try {
      final lookups = await _api.customerFormLookups();
      if (!mounted) return;
      setState(() {
        _lookups = lookups;
        _resolveLookupLabels();
      });
    } catch (_) {}
  }

  void _apply(Map<String, String> values) {
    for (final entry in values.entries) {
      _store.field(entry.key).text = entry.value;
    }
    _resolveLookupLabels();
  }

  /// Turn stored domain codes (e.g. jobCode `11`) into Arabic labels for UI.
  void _resolveLookupLabels() {
    final lookups = _lookups;
    if (lookups == null) return;
    void resolve(
      String key,
      String Function(String raw) labelFor,
    ) {
      final raw = _store.text(key);
      if (raw.isEmpty) return;
      final label = labelFor(raw);
      if (label.isNotEmpty && label != raw) {
        _store.field(key).text = label;
      }
    }

    resolve('job', lookups.jobLabel);
    resolve('education', lookups.educationLabel);
    resolve('health', lookups.healthLabel);
    resolve('religion', lookups.religionLabel);
    resolve('marital', lookups.socialLabel);
    resolve('nationality', lookups.nationLabel);
    resolve('gender', lookups.genderLabel);
  }

  Future<void> _reload() async {
    try {
      final profile = await _api.openByNationalId(_store.text('nationalId'));
      if (!mounted) return;
      setState(() {
        _clientId = profile.id;
        _details = true;
        _apply(profile.values);
      });
    } catch (error) {
      if (!mounted) return;
      showAuthError(context, error);
    }
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  void _tapSection(_ClientSection section) {
    if (widget.addressSectionsOnly &&
        section != _ClientSection.home &&
        section != _ClientSection.card) {
      return;
    }
    if (!_details && section != _ClientSection.id) {
      showAuthError(context, AuthApiException('أكمل بطاقة الرقم القومي أولاً'));
      return;
    }
    _open(section);
  }

  Iterable<(_ClientSection, String, String)> get _visibleSections {
    if (widget.addressSectionsOnly) {
      return _clientSectionMenu.where(
        (e) => e.$1 == _ClientSection.home || e.$1 == _ClientSection.card,
      );
    }
    return _clientSectionMenu;
  }

  Future<void> _open(_ClientSection section) async {
    final result = await Navigator.of(context).push<_SectionResult>(
      MaterialPageRoute(
        builder: (_) => _ClientSectionScreen(
          store: _store,
          section: section,
          clientId: _clientId,
          showContinue: section == _ClientSection.id && !_details,
          lookups: _lookups,
          readOnly: widget.viewOnly,
          newCustomer: widget.newCustomer,
          editExisting:
              !widget.newCustomer && !widget.viewOnly && widget.initial != null,
        ),
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      if (result.clientId != null) _clientId = result.clientId;
      if (result.continued) _details = true;
      _apply(result.values);
    });
    if (!result.saved) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('تم حفظ القسم')));
  }

  Future<void> _submit({required bool saved}) async {
    final values = {for (final key in _keys) key: _store.text(key)};
    final complete = _clientSectionMenu.every(
      (section) => _sectionReady(
        _store,
        section.$1,
        newCustomer: widget.newCustomer,
      ),
    );
    if (!complete) {
      setState(() => _showErrors = true);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text(FmcValidation.fillFormMessage)),
        );
      return;
    }
    try {
      final id = await _api.saveCustomerForm(
        values: {
          ...values,
          'resStateId': _store.text('resStateId'),
          'resCityId': _store.text('resCityId'),
          'resVillageId': _store.text('resVillageId'),
          'cardStateId': _store.text('cardStateId'),
          'cardCityId': _store.text('cardCityId'),
          'cardVillageId': _store.text('cardVillageId'),
        },
        clientId: _clientId,
        lookups: _lookups,
      );
      if (id != null && id.isNotEmpty) _clientId = id;
    } catch (error) {
      if (!mounted) return;
      showAuthError(context, error);
      return;
    }
    if (!mounted) return;
    final info = ClientInfo(values, clientId: _clientId);
    await showFlowSuccess(
      context,
      message: saved
          ? 'لقد تم الحفظ بنجاح'
          : 'لقد قمت باضافة عميل لطلب التمويل بنجاح',
      note: saved ? null : 'برجاء إستكمال باقي البيانات لانشاء طلب التمويل',
    );
    if (!mounted) return;
    Navigator.of(context).pop(info);
  }

  @override
  Widget buildWidget(
    BuildContext context,
    RenderDataState<ClientDataModel> state,
  ) {
    return FlowScaffold(
      pageTitle: 'بيانات العميل',
      pageIcon: Icons.person,
      body: FlowBody(
        footer: widget.viewOnly || widget.addressSectionsOnly
            ? null
            : _review
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
          ListenableBuilder(
            listenable: _store.listenable(_keys),
            builder: (context, _) {
              return Column(
                children: [
                  for (final (section, title, step) in _visibleSections)
                    FlowMenuTile(
                      title: title,
                      step: step,
                      done: _sectionReady(
                        _store,
                        section,
                        newCustomer: widget.newCustomer,
                      ),
                      details: _showErrors
                          ? _missingFields(
                              _store,
                              section,
                              newCustomer: widget.newCustomer,
                            )
                          : const [],
                      onTap: () => _tapSection(section),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void listenToState(BuildContext context, BaseStates state) {}

  @override
  ClientDataBloc createBloc() => ClientDataBloc(ClientDataModel());
}

class _SectionResult {
  const _SectionResult({
    this.clientId,
    this.continued = false,
    this.saved = false,
    this.values = const {},
  });

  final String? clientId;
  final bool continued;
  final bool saved;
  final Map<String, String> values;
}

class _ClientSectionScreen extends StatefulWidget {
  const _ClientSectionScreen({
    required this.store,
    required this.section,
    required this.showContinue,
    required this.clientId,
    this.lookups,
    this.readOnly = false,
    this.newCustomer = false,
    this.editExisting = false,
  });

  final FormStore store;
  final _ClientSection section;
  final bool showContinue;
  final String? clientId;
  final ClientLookups? lookups;
  final bool readOnly;
  final bool newCustomer;

  /// Existing-customer edit: lock identity / detailed-address fields.
  final bool editExisting;

  @override
  State<_ClientSectionScreen> createState() => _ClientSectionScreenState();
}

class _ClientSectionScreenState extends State<_ClientSectionScreen> {
  final _api = ClientApi();
  final Map<String, List<AddressPlace>> _cities = {};
  final Map<String, List<AddressPlace>> _villages = {};
  bool _showErrors = false;

  FormStore get _store => widget.store;

  String get _title {
    return switch (widget.section) {
      _ClientSection.id => 'بطاقة الرقم القومي',
      _ClientSection.basic => 'البيانات الاساسية',
      _ClientSection.home => 'عنوان الاقامة',
      _ClientSection.card => 'عنوان البطاقة',
      _ClientSection.contact => 'بيانات التواصل',
    };
  }

  List<String> get _clearKeys {
    return switch (widget.section) {
      _ClientSection.id => const [],
      _ClientSection.basic => [
        if (!widget.editExisting) ...['clientNumber', 'fullName'],
        'first',
        'second',
        'third',
        'fourth',
        'nickname',
        'issue',
        'health',
        'job',
        'religion',
        'nationality',
        'marital',
        'children',
        'education',
      ],
      _ClientSection.home => [
        ..._addressKeys('res'),
        'resStateId',
        'resCityId',
        'resVillageId',
      ],
      _ClientSection.card => [
        ..._addressKeys('card'),
        'cardStateId',
        'cardCityId',
        'cardVillageId',
      ],
      _ClientSection.contact => const ['phone1', 'phone2', 'email'],
    };
  }

  List<String> _addressKeys(String prefix) => [
    '${prefix}Governorate',
    '${prefix}City',
    '${prefix}District',
    '${prefix}Street',
    '${prefix}Building',
    '${prefix}Floor',
    '${prefix}Apartment',
    '${prefix}Landmark',
    '${prefix}Postal',
  ];

  bool get _canClear => _clearKeys.any((key) => _store.text(key).isNotEmpty);

  bool get _canSave => _sectionReady(
        _store,
        widget.section,
        newCustomer: widget.newCustomer,
      );

  Listenable get _fields =>
      Listenable.merge([for (final key in _clearKeys) _store.field(key)]);

  Map<String, String> _snapshot(Iterable<String> keys) {
    return {for (final key in keys) key: _store.text(key)};
  }

  Future<void> _save() async {
    if (!_canSave) {
      setState(() => _showErrors = true);
      return;
    }
    final values = _snapshot(_clearKeys);
    if (!mounted) return;
    Navigator.of(context).pop(
      _SectionResult(
        clientId: widget.clientId,
        continued: widget.showContinue,
        saved: true,
        values: values,
      ),
    );
  }

  Future<void> _choose(
    String key,
    String title,
    List<String> options, {
    bool searchable = false,
  }) async {
    final choice = await showChoiceDialog(
      context: context,
      title: title,
      options: options,
      selected: _store.text(key).isEmpty ? null : _store.text(key),
      searchable: searchable,
      searchHint: 'ابحث عن $title',
    );
    if (!mounted || choice == null) return;
    setState(() => _store.field(key).text = choice);
    if (key.endsWith('Governorate')) {
      final prefix = key.replaceFirst('Governorate', '');
      final state = widget.lookups?.stateNamed(choice);
      _store.field('${prefix}City').clear();
      _store.field('${prefix}District').clear();
      _store.field('${prefix}CityId').clear();
      _store.field('${prefix}VillageId').clear();
      _store.field('${prefix}StateId').text = state?.stateId ?? '';
      if (state == null) return;
      final cities = await _api.cities(state);
      if (!mounted) return;
      setState(() {
        _cities[prefix] = cities;
        _villages.remove(prefix);
      });
    }
    if (key.endsWith('City')) {
      final prefix = key.replaceFirst('City', '');
      final state = widget.lookups?.stateNamed(
        _store.text('${prefix}Governorate'),
      );
      AddressPlace? city;
      for (final item in _cities[prefix] ?? const <AddressPlace>[]) {
        if (item.name == choice) city = item;
      }
      _store.field('${prefix}District').clear();
      _store.field('${prefix}VillageId').clear();
      _store.field('${prefix}CityId').text = city?.cityId ?? '';
      if (state == null || city == null) return;
      final villages = await _api.villages(state: state, city: city);
      if (!mounted) return;
      setState(() => _villages[prefix] = villages);
    }
    if (key.endsWith('District')) {
      final prefix = key.replaceFirst('District', '');
      AddressPlace? village;
      for (final item in _villages[prefix] ?? const <AddressPlace>[]) {
        if (item.name == choice) village = item;
      }
      _store.field('${prefix}VillageId').text = village?.cityId ?? '';
    }
  }

  Future<void> _date(String key, String title) async {
    final value = await pickFlowDate(
      context,
      currentValue: _store.text(key),
      title: title,
    );
    if (!mounted || value == null) return;
    setState(() => _store.field(key).text = value);
  }

  void _copyAddress() {
    const pairs = [
      'Governorate',
      'City',
      'District',
      'Street',
      'Building',
      'Floor',
      'Apartment',
      'Landmark',
      'Postal',
      'StateId',
      'CityId',
      'VillageId',
    ];
    setState(() {
      for (final pair in pairs) {
        _store.field('card$pair').text = _store.text('res$pair');
      }
      final cities = _cities['res'];
      final villages = _villages['res'];
      if (cities != null) _cities['card'] = List<AddressPlace>.from(cities);
      if (villages != null) {
        _villages['card'] = List<AddressPlace>.from(villages);
      }
    });
  }

  String _addressLine(String prefix) {
    final building = _store.text('${prefix}Building');
    final street = _store.text('${prefix}Street');
    final district = _store.text('${prefix}District');
    final city = _store.text('${prefix}City');
    final governorate = _store.text('${prefix}Governorate');
    final floor = _store.text('${prefix}Floor');
    final apartment = _store.text('${prefix}Apartment');
    final parts = <String>[];
    if (building.isNotEmpty || street.isNotEmpty) {
      parts.add(
        [
          building,
          if (street.isNotEmpty) 'ش $street',
        ].where((part) => part.isNotEmpty).join(' '),
      );
    }
    if (district.isNotEmpty) parts.add(district);
    if (city.isNotEmpty) parts.add(city);
    if (governorate.isNotEmpty) parts.add(governorate);
    if (floor.isNotEmpty) parts.add('الدور $floor');
    if (apartment.isNotEmpty) parts.add('شقة $apartment');
    return parts.isEmpty ? '—' : parts.join('، ');
  }

  @override
  Widget build(BuildContext context) {
    final fields = _fields;
    return FlowScaffold(
      pageTitle: _title,
      pageIcon: Icons.person,
      body: Column(
        children: [
          Expanded(
            child: FocusScope(
              canRequestFocus: !widget.readOnly,
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.manual,
                children: [
                  if (!widget.readOnly)
                    ListenableBuilder(
                      listenable: fields,
                      builder: (context, _) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: _canClear
                                ? () => _store.clearKeys(_clearKeys)
                                : null,
                            child: Text(
                              'مسح الحقول',
                              style: TextStyle(
                                color: const Color(0xFFE7A0A4),
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  IgnorePointer(
                    ignoring: widget.readOnly,
                    child: Opacity(
                      opacity: widget.readOnly ? 0.72 : 1,
                      child: _body(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!widget.readOnly)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: ListenableBuilder(
                listenable: fields,
                builder: (context, _) {
                  return FlowActionButton(
                    label: widget.showContinue
                        ? 'استكمال بيانات العميل'
                        : 'حفظ',
                    enabled: true,
                    onPressed: _save,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _body() {
    return switch (widget.section) {
      _ClientSection.id => _idFields(),
      _ClientSection.basic => _basicFields(),
      _ClientSection.home => _addressFields('res', detailed: true),
      _ClientSection.card => _addressFields(
        'card',
        detailed: true,
        copyFromHome: true,
      ),
      _ClientSection.contact => _contactFields(),
    };
  }

  Widget _idFields() {
    return Column(
      children: [
        const FlowLabel('الرقم القومي'),
        SizedBox(height: 6.h),
        FlowTextField(
          key: const ValueKey('nationalId'),
          controller: _store.field('nationalId'),
          hint: 'ادخل الرقم القومي المكون من 14 رقم',
          digitsOnly: true,
          maxLength: 14,
          readOnly: true,
          filledColor: const Color(0xFFE9EEF3),
          textColor: const Color(0xFF8E98A4),
          keyboardType: TextInputType.number,
          error: _error(
            FmcValidation.requiredNationalId(_store.text('nationalId')),
          ),
          reserveErrorSpace: _showErrors,
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _basicFields() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFF3C92D6),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            textDirection: TextDirection.ltr,
            children: [
              Text(
                _store.text('nationalId'),
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                'رقم البطاقة',
                style: TextStyle(color: AppColors.white, fontSize: 12.sp),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FlowLabel('الاسم بالكامل'),
                  SizedBox(height: 6.h),
                  FlowTextField(
                    key: const ValueKey('fullName'),
                    controller: _store.field('fullName'),
                    hint: 'الاسم بالكامل',
                    readOnly: widget.readOnly ||
                        widget.editExisting ||
                        widget.newCustomer,
                    error: widget.readOnly ||
                            widget.editExisting ||
                            widget.newCustomer
                        ? null
                        : _error(
                            FmcValidation.required(_store.text('fullName')),
                          ),
                    reserveErrorSpace: widget.readOnly ||
                            widget.editExisting ||
                            widget.newCustomer
                        ? false
                        : _showErrors,
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: widget.newCustomer
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const FlowLabel('رقم العميل'),
                        SizedBox(height: 6.h),
                        FlowTextField(
                          key: const ValueKey('clientNumber'),
                          controller: _store.field('clientNumber'),
                          hint: 'يُنشأ تلقائياً بعد الحفظ',
                          readOnly: true,
                          filledColor: AppColors.card,
                          textColor: AppColors.muted,
                          keyboardType: TextInputType.number,
                          onChanged: (_) {},
                        ),
                      ],
                    )
                  : _labeled(
                      'رقم العميل',
                      'clientNumber',
                      'رقم العميل',
                      digits: true,
                      locked: true,
                    ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _labeled(
                'الاسم الاول',
                'first',
                'الاسم الاول',
                arabicOnly: true,
                maxLength: 15,
                rule: FmcValidation.requiredArabicNamePart,
                onChanged: _onNamePartChanged,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _labeled(
                'الاسم الثاني',
                'second',
                'الاسم الثاني',
                arabicOnly: true,
                maxLength: 15,
                rule: FmcValidation.requiredArabicNamePart,
                onChanged: _onNamePartChanged,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _labeled(
                'الاسم الثالث',
                'third',
                'الاسم الثالث',
                arabicOnly: true,
                maxLength: 15,
                rule: FmcValidation.requiredArabicNamePart,
                onChanged: _onNamePartChanged,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _labeled(
                'الاسم الرابع',
                'fourth',
                'الاسم الرابع',
                arabicOnly: true,
                maxLength: 15,
                rule: FmcValidation.requiredArabicNamePart,
                onChanged: _onNamePartChanged,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _labeled(
          'الاسم المستعار',
          'nickname',
          'الاسم المستعار',
          rule: (_) => null,
        ),
        SizedBox(height: 12.h),
        _dateField('تاريخ الميلاد', 'birth', locked: true),
        SizedBox(height: 12.h),
        _dateField('تاريخ اصدار البطاقة', 'issue'),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _choice(
                'النوع',
                'gender',
                'النوع',
                _options(widget.lookups?.genders, const ['ذكر', 'انثى']),
                locked: true,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _choice(
                'الحالة الصحية',
                'health',
                'الحالة الصحية',
                _options(widget.lookups?.health, const ['جيدة', 'متوسطة']),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        if ((widget.lookups?.jobs ?? const []).isNotEmpty)
          _choice(
            'وظيفة العميل',
            'job',
            'وظيفة العميل',
            widget.lookups!.jobs,
            searchable: true,
            required: false,
          )
        else
          _labeled(
            'وظيفة العميل',
            'job',
            'وظيفة العميل',
            rule: (_) => null,
          ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _choice(
                'الديانة',
                'religion',
                'الديانة',
                _options(widget.lookups?.religions, const ['مسلم', 'مسيحي']),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _choice(
                'الجنسية',
                'nationality',
                'الجنسية',
                _options(widget.lookups?.nations, const ['مصري']),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _choice(
                'الحالة الاجتماعية',
                'marital',
                'الحالة الاجتماعية',
                _options(widget.lookups?.social, const ['اعزب', 'متزوج']),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _labeled(
                'عدد الاطفال',
                'children',
                'عدد الاطفال',
                digits: true,
                maxLength: 2,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _choice(
          'المؤهل الدراسي',
          'education',
          'المؤهل الدراسي',
          _options(widget.lookups?.qualifications, const [
            'دبلوم',
            'بكالوريوس',
          ]),
        ),
      ],
    );
  }

  Widget _addressFields(
    String prefix, {
    bool detailed = false,
    bool copyFromHome = false,
  }) {
    return Column(
      children: [
        if (copyFromHome && !widget.readOnly)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _copyAddress,
              icon: const Icon(Icons.copy, size: 16),
              label: const Text('نسخ من عنوان الاقامة'),
            ),
          ),
        _choice(
          'المحافظة',
          '${prefix}Governorate',
          'اختر المحافظة',
          _options(
            widget.lookups?.states.map((state) => state.name).toList(),
            const ['القاهرة', 'الجيزة', 'الاسكندرية'],
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _choice(
                '${prefix}City',
                '${prefix}City',
                'اختر المدينة',
                _options(
                  _cities[prefix]?.map((city) => city.name).toList(),
                  const ['الجيزة', 'القاهرة'],
                ),
                caption: 'المدينة',
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _choice(
                '${prefix}District',
                '${prefix}District',
                'اختر القسم',
                _options(
                  _villages[prefix]?.map((village) => village.name).toList(),
                  const ['الطالبية', 'الدقي', 'الهرم'],
                ),
                caption: 'المركز / القسم',
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _labeled(
          'الشارع',
          '${prefix}Street',
          'ادخل اسم / رقم الشارع',
          maxLength: 30,
        ),
        SizedBox(height: 12.h),
        _labeled(
          'المبنى',
          '${prefix}Building',
          'ادخل اسم / رقم المبنى',
          maxLength: 20,
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _labeled(
                'الطابق',
                '${prefix}Floor',
                'رقم الطابق',
                digits: true,
                maxLength: 10,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _labeled(
                'الشقة',
                '${prefix}Apartment',
                'رقم الشقة',
                digits: true,
                maxLength: 10,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _labeled('علامة مميزة', '${prefix}Landmark', 'ادخل علامة مميزة'),
        SizedBox(height: 12.h),
        _labeled(
          'الرمز البريدي',
          '${prefix}Postal',
          'ادخل الرمز البريدي',
          digits: true,
          rule: (_) => null,
        ),
        // العنوان تفصيلي at the bottom (derived / non-editable).
        if (detailed) ...[
          SizedBox(height: 12.h),
          _detailBox('العنوان تفصيلي', _addressLine(prefix)),
        ],
      ],
    );
  }

  Widget _contactFields() {
    return Column(
      children: [
        const FlowLabel('تليفون 1'),
        SizedBox(height: 6.h),
        FlowTextField(
          key: const ValueKey('phone1'),
          controller: _store.field('phone1'),
          hint: '01xxxxxxxxx',
          egyptianMobile: true,
          maxLength: 11,
          keyboardType: TextInputType.phone,
          readOnly: widget.readOnly,
          error: widget.readOnly
              ? null
              : _error(FmcValidation.requiredMobile(_store.text('phone1'))),
          reserveErrorSpace: widget.readOnly ? false : _showErrors,
          onChanged: (_) => setState(() {}),
          prefix: const _DialCode(),
        ),
        SizedBox(height: 12.h),
        const FlowLabel('تليفون 2'),
        SizedBox(height: 6.h),
        FlowTextField(
          key: const ValueKey('phone2'),
          controller: _store.field('phone2'),
          hint: '01xxxxxxxxx',
          egyptianMobile: true,
          maxLength: 11,
          keyboardType: TextInputType.phone,
          readOnly: widget.readOnly,
          error: widget.readOnly
              ? null
              : _error(FmcValidation.mobile(_store.text('phone2'))),
          reserveErrorSpace: widget.readOnly ? false : _showErrors,
          onChanged: (_) => setState(() {}),
          prefix: const _DialCode(),
        ),
        SizedBox(height: 12.h),
        _labeled(
          'البريد الالكتروني',
          'email',
          'example@example.com',
          email: true,
          rule: FmcValidation.emailLive,
        ),
      ],
    );
  }

  Widget _detailBox(String title, String body) {
    final text = body.trim().isEmpty ? '—' : body.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FlowLabel(title),
        SizedBox(height: 6.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xFFE9EEF3),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFD5DDE6)),
          ),
          child: Text(
            text,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              color: const Color(0xFF8E98A4),
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  String? _error(String? message) => _showErrors ? message : null;

  void _onNamePartChanged(String _) {
    if (widget.newCustomer) {
      composeFullNameFromParts(_store);
    }
    setState(() {});
  }

  Widget _labeled(
    String label,
    String key,
    String hint, {
    bool digits = false,
    bool arabicOnly = false,
    bool email = false,
    int? maxLength,
    bool locked = false,
    String? Function(String? value)? rule,
    ValueChanged<String>? onChanged,
  }) {
    final dimmed = widget.readOnly || locked;
    final value = _store.text(key);
    final message = dimmed
        ? null
        : (rule ?? FmcValidation.required)(value);
    // Email: show format errors live while typing; others after submit.
    final showError = email
        ? (message != null && value.isNotEmpty)
        : (_showErrors && message != null);
    return Column(
      children: [
        FlowLabel(label),
        SizedBox(height: 6.h),
        FlowTextField(
          key: ValueKey(key),
          controller: _store.field(key),
          hint: hint,
          digitsOnly: digits,
          arabicOnly: arabicOnly,
          emailOnly: email,
          maxLength: maxLength ?? (email ? 100 : null),
          keyboardType: digits
              ? TextInputType.number
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
          onChanged: onChanged ?? (_) => setState(() {}),
        ),
      ],
    );
  }

  List<String> _options(List<String>? fromApi, List<String> fallback) {
    if (widget.lookups != null) return fromApi ?? const [];
    if (fromApi == null || fromApi.isEmpty) return fallback;
    return fromApi;
  }

  Widget _choice(
    String label,
    String key,
    String hint,
    List<String> options, {
    String? caption,
    bool locked = false,
    bool searchable = false,
    bool required = true,
  }) {
    final shown = caption ?? label;
    final dimmed = widget.readOnly || locked;
    return FlowChoiceField(
      label: shown,
      value: _store.text(key),
      hint: hint,
      locked: dimmed,
      error: dimmed || !required
          ? null
          : _error(FmcValidation.required(_store.text(key))),
      reserveErrorSpace: dimmed || !required ? false : _showErrors,
      onTap: () => _choose(key, shown, options, searchable: searchable),
    );
  }

  Widget _dateField(String label, String key, {bool locked = false}) {
    final dimmed = widget.readOnly || locked;
    return FlowChoiceField(
      label: label,
      value: _store.text(key),
      hint: '00/00/0000',
      locked: dimmed,
      error: dimmed ? null : _error(FmcValidation.required(_store.text(key))),
      reserveErrorSpace: dimmed ? false : _showErrors,
      onTap: () => _date(key, label),
    );
  }
}

class _DialCode extends StatelessWidget {
  const _DialCode();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        EgyptFlag(),
        SizedBox(width: 4),
        Text('+20', style: TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
