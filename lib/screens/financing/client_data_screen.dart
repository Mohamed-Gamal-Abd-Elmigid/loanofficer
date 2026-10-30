import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/client_api.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/screens/financing/financing_kit.dart';

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
  'expiry',
  'gender',
  'health',
  'job',
  'religion',
  'nationality',
  'marital',
  'children',
  'education',
];

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

bool _filled(FormStore store, Iterable<String> keys) {
  return keys.every((key) => store.text(key).isNotEmpty);
}

bool _sectionReady(FormStore store, _ClientSection section) {
  return switch (section) {
    _ClientSection.id => store.text('nationalId').length == 14,
    _ClientSection.basic => _filled(store, _basicKeys),
    _ClientSection.home => _filled(store, _addressKeys('res')),
    _ClientSection.card => _filled(store, _addressKeys('card')),
    _ClientSection.contact =>
      store.text('phone1').length == 11 &&
          store.text('phone2').length == 11 &&
          store.text('email').isNotEmpty,
  };
}

class ClientDataScreen extends StatefulWidget {
  const ClientDataScreen({super.key, this.initial});

  final ClientInfo? initial;

  @override
  State<ClientDataScreen> createState() => _ClientDataScreenState();
}

class _ClientDataScreenState extends State<ClientDataScreen> {
  final _store = FormStore();
  final _api = ClientApi();
  bool _review = false;
  bool _details = false;
  String? _clientId;

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
    _review = widget.initial != null;
    _clientId = widget.initial?.clientId;
    final initial = widget.initial?.values ?? const {};
    for (final key in _keys) {
      _store.field(key, initial[key] ?? '');
    }
    if (_review) _details = true;
    if (_review && _store.text('nationalId').length == 14) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _reload());
    }
  }

  void _apply(Map<String, String> values) {
    for (final entry in values.entries) {
      _store.field(entry.key).text = entry.value;
    }
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

  bool get _canAdd =>
      _store.text('nationalId').length == 14 &&
      _store.text('fullName').isNotEmpty &&
      _store.text('phone1').length == 11;

  void _tapSection(_ClientSection section) {
    if (!_details && section != _ClientSection.id) {
      showAuthError(context, AuthApiException('أكمل بطاقة الرقم القومي أولاً'));
      return;
    }
    _open(section);
  }

  Future<void> _open(_ClientSection section) async {
    final result = await Navigator.of(context).push<_SectionResult>(
      MaterialPageRoute(
        builder: (_) => _ClientSectionScreen(
          store: _store,
          section: section,
          clientId: _clientId,
          showContinue: section == _ClientSection.id && !_details,
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
    final message = result.existed
        ? 'تم تحميل بيانات العميل المحفوظة'
        : 'تم حفظ القسم';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit({required bool saved}) async {
    final info = ClientInfo({
      for (final key in _keys) key: _store.text(key),
    }, clientId: _clientId);
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
  Widget build(BuildContext context) {
    return FlowScaffold(
      pageTitle: 'بيانات العميل',
      pageIcon: Icons.person,
      body: FlowBody(
        footer: _review
            ? FlowSaveButton(
                enabled: _canAdd,
                onPressed: () => _submit(saved: true),
              )
            : FlowActionButton(
                label: 'اضافة',
                enabled: _canAdd,
                onPressed: () => _submit(saved: false),
              ),
        children: [
          ListenableBuilder(
            listenable: _store.listenable(_keys),
            builder: (context, _) {
              return Column(
                children: [
                  for (final (section, title, step) in _clientSectionMenu)
                    FlowMenuTile(
                      title: title,
                      step: step,
                      done: _sectionReady(_store, section),
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
}

class _SectionResult {
  const _SectionResult({
    this.clientId,
    this.continued = false,
    this.saved = false,
    this.existed = false,
    this.values = const {},
  });

  final String? clientId;
  final bool continued;
  final bool saved;
  final bool existed;
  final Map<String, String> values;
}

class _ClientSectionScreen extends StatefulWidget {
  const _ClientSectionScreen({
    required this.store,
    required this.section,
    required this.showContinue,
    required this.clientId,
  });

  final FormStore store;
  final _ClientSection section;
  final bool showContinue;
  final String? clientId;

  @override
  State<_ClientSectionScreen> createState() => _ClientSectionScreenState();
}

class _ClientSectionScreenState extends State<_ClientSectionScreen> {
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
      _ClientSection.id => const ['nationalId'],
      _ClientSection.basic => const [
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
      ],
      _ClientSection.home => _addressKeys('res'),
      _ClientSection.card => _addressKeys('card'),
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

  bool get _canSave => _sectionReady(_store, widget.section);

  Listenable get _fields =>
      Listenable.merge([for (final key in _clearKeys) _store.field(key)]);

  Map<String, String> _snapshot(Iterable<String> keys) {
    return {for (final key in keys) key: _store.text(key)};
  }

  Future<void> _save() async {
    final api = ClientApi();
    try {
      if (widget.section == _ClientSection.id && widget.showContinue) {
        final profile = await api.openByNationalId(_store.text('nationalId'));
        if (!mounted) return;
        Navigator.of(context).pop(
          _SectionResult(
            clientId: profile.id,
            continued: true,
            saved: true,
            existed: profile.existed,
            values: profile.values,
          ),
        );
        return;
      }
      final clientId = widget.clientId;
      if (clientId == null) {
        showAuthError(context, AuthApiException('احفظ الرقم القومي أولاً'));
        return;
      }
      final values = _snapshot(_clearKeys);
      switch (widget.section) {
        case _ClientSection.id:
          await api.updateNationalId(
            clientId: clientId,
            nationalId: _store.text('nationalId'),
          );
        case _ClientSection.basic:
          await api.saveBasic(clientId: clientId, values: values);
        case _ClientSection.home:
          await api.saveResidence(clientId: clientId, values: values);
        case _ClientSection.card:
          await api.saveCardAddress(clientId: clientId, values: values);
        case _ClientSection.contact:
          await api.saveContact(clientId: clientId, values: values);
      }
      if (!mounted) return;
      Navigator.of(context).pop(const _SectionResult(saved: true));
    } catch (error) {
      if (!mounted) return;
      showAuthError(context, error);
    }
  }

  Future<void> _choose(String key, String title, List<String> options) async {
    final choice = await showChoiceDialog(
      context: context,
      title: title,
      options: options,
      selected: _store.text(key).isEmpty ? null : _store.text(key),
    );
    if (!mounted || choice == null) return;
    setState(() => _store.field(key).text = choice);
  }

  Future<void> _date(String key) async {
    final value = await pickFlowDate(context);
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
    ];
    setState(() {
      for (final pair in pairs) {
        _store.field('card$pair').text = _store.text('res$pair');
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
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
              children: [
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
                _body(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: ListenableBuilder(
              listenable: fields,
              builder: (context, _) {
                return FlowActionButton(
                  label: widget.showContinue
                      ? 'استكمال بيانات العميل'
                      : 'اضافة',
                  enabled: _canSave,
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
      _ClientSection.card => _addressFields('card', copyFromHome: true),
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
          keyboardType: TextInputType.number,
          onChanged: (_) {},
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
              child: _labeled('الاسم بالكامل', 'fullName', 'الاسم بالكامل'),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _labeled(
                'رقم العميل',
                'clientNumber',
                'رقم العميل',
                digits: true,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _labeled('الاسم الاول', 'first', 'الاسم الاول')),
            SizedBox(width: 10.w),
            Expanded(child: _labeled('الاسم الثاني', 'second', 'الاسم الثاني')),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _labeled('الاسم الثالث', 'third', 'الاسم الثالث')),
            SizedBox(width: 10.w),
            Expanded(child: _labeled('الاسم الرابع', 'fourth', 'الاسم الرابع')),
          ],
        ),
        SizedBox(height: 12.h),
        _labeled('الاسم المستعار', 'nickname', 'الاسم المستعار'),
        SizedBox(height: 12.h),
        _dateField('تاريخ الميلاد', 'birth'),
        SizedBox(height: 12.h),
        _dateField('تاريخ اصدار البطاقة', 'issue'),
        SizedBox(height: 12.h),
        _dateField('تاريخ الانتهاء', 'expiry'),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _choice('النوع', 'gender', 'النوع', const ['ذكر', 'انثى']),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _choice('الحالة الصحية', 'health', 'الحالة الصحية', const [
                'جيدة',
                'متوسطة',
              ]),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _labeled('وظيفة العميل', 'job', 'وظيفة العميل'),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _choice('الديانة', 'religion', 'الديانة', const [
                'مسلم',
                'مسيحي',
              ]),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _choice('الجنسية', 'nationality', 'الجنسية', const [
                'مصري',
              ]),
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
                const ['اعزب', 'متزوج'],
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _labeled(
                'عدد الاطفال',
                'children',
                'عدد الاطفال',
                digits: true,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _choice('المؤهل الدراسي', 'education', 'المؤهل الدراسي', const [
          'دبلوم',
          'بكالوريوس',
        ]),
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
        if (detailed) _detailBox('العنوان تفصيلي', _addressLine(prefix)),
        if (copyFromHome)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _copyAddress,
              icon: const Icon(Icons.copy, size: 16),
              label: const Text('نسخ من عنوان الاقامة'),
            ),
          ),
        _choice('المحافظة', '${prefix}Governorate', 'اختر المحافظة', const [
          'القاهرة',
          'الجيزة',
          'الاسكندرية',
        ]),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _choice(
                '${prefix}City',
                '${prefix}City',
                'اختر المدينة',
                const ['الجيزة', 'القاهرة'],
                caption: 'المدينة',
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _choice(
                '${prefix}District',
                '${prefix}District',
                'اختر القسم',
                const ['الطالبية', 'الدقي', 'الهرم'],
                caption: 'المركز / القسم',
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _labeled('الشارع', '${prefix}Street', 'ادخل اسم / رقم الشارع'),
        SizedBox(height: 12.h),
        _labeled('المبنى', '${prefix}Building', 'ادخل اسم / رقم المبنى'),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _labeled('الطابق', '${prefix}Floor', 'رقم الطابق')),
            SizedBox(width: 10.w),
            Expanded(
              child: _labeled('الشقة', '${prefix}Apartment', 'رقم الشقة'),
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
        ),
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
          digitsOnly: true,
          maxLength: 11,
          keyboardType: TextInputType.phone,
          onChanged: (_) {},
          prefix: const _DialCode(),
        ),
        SizedBox(height: 12.h),
        const FlowLabel('تليفون 2'),
        SizedBox(height: 6.h),
        FlowTextField(
          key: const ValueKey('phone2'),
          controller: _store.field('phone2'),
          hint: '01xxxxxxxxx',
          digitsOnly: true,
          maxLength: 11,
          keyboardType: TextInputType.phone,
          onChanged: (_) {},
          prefix: const _DialCode(),
        ),
        SizedBox(height: 12.h),
        _labeled('البريد الالكتروني', 'email', 'example@example.com'),
      ],
    );
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
            body,
            textAlign: TextAlign.right,
            style: TextStyle(color: const Color(0xFF3C92D6), fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Widget _labeled(
    String label,
    String key,
    String hint, {
    bool digits = false,
  }) {
    return Column(
      children: [
        FlowLabel(label),
        SizedBox(height: 6.h),
        FlowTextField(
          key: ValueKey(key),
          controller: _store.field(key),
          hint: hint,
          digitsOnly: digits,
          keyboardType: digits ? TextInputType.number : TextInputType.text,
          onChanged: (_) {},
        ),
      ],
    );
  }

  Widget _choice(
    String label,
    String key,
    String hint,
    List<String> options, {
    String? caption,
  }) {
    final shown = caption ?? label;
    return FlowChoiceField(
      label: shown,
      value: _store.text(key),
      hint: hint,
      onTap: () => _choose(key, shown, options),
    );
  }

  Widget _dateField(String label, String key) {
    return FlowChoiceField(
      label: label,
      value: _store.text(key),
      hint: '00/00/0000',
      onTap: () => _date(key),
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
