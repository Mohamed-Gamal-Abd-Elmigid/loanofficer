import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/screens/financing/financing_kit.dart';

class GuarantorInfo {
  const GuarantorInfo(this.values);

  final Map<String, String> values;

  String get nationalId => values['nationalId'] ?? '';
  String get clientNumber => values['clientNumber'] ?? '';
  String get fullName => values['fullName'] ?? '';
  String get order => values['order'] ?? '';
}

class GuarantorDataScreen extends StatefulWidget {
  const GuarantorDataScreen({super.key, this.initial});

  final GuarantorInfo? initial;

  @override
  State<GuarantorDataScreen> createState() => _GuarantorDataScreenState();
}

class _GuarantorDataScreenState extends State<GuarantorDataScreen> {
  final _store = FormStore();
  bool _review = false;
  bool _details = false;
  final Set<String> _open = {'general', 'id'};

  static const _keys = [
    'order',
    'relation',
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

  static const _basicKeys = [
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

  static const _contactKeys = ['phone1', 'phone2', 'email'];

  @override
  void initState() {
    super.initState();
    _review = widget.initial != null;
    final initial = widget.initial?.values ?? const {};
    for (final key in _keys) {
      _store.field(key, initial[key] ?? '');
    }
    if (_review) _open.clear();
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  bool get _idReady => _store.text('nationalId').length == 14;

  bool get _introReady =>
      _store.text('order').isNotEmpty &&
      _store.text('relation').isNotEmpty &&
      _idReady;

  bool get _formReady {
    const phones = {'phone1', 'phone2'};
    return _keys.every((key) {
      final value = _store.text(key);
      if (key == 'nationalId') return value.length == 14;
      if (phones.contains(key)) return value.length == 11;
      return value.isNotEmpty;
    });
  }

  bool _hasAny(Iterable<String> keys) =>
      keys.any((key) => _store.text(key).isNotEmpty);

  VoidCallback? _clear(Iterable<String> keys) {
    if (!_hasAny(keys)) return null;
    return () => setState(() => _store.clearKeys(keys));
  }

  void _toggle(String key) => setState(() {
    if (_open.contains(key)) {
      _open.remove(key);
    } else {
      _open.add(key);
    }
  });

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

  Future<void> _submit({required bool saved}) async {
    final info = GuarantorInfo({
      for (final key in _keys) key: _store.text(key),
    });
    await showFlowSuccess(
      context,
      message: saved
          ? 'لقد تم الحفظ بنجاح'
          : 'لقد قمت باضافة ضامن لطلب التمويل بنجاح',
      note: saved ? null : 'برجاء إستكمال باقي البيانات لانشاء طلب التمويل',
    );
    if (!mounted) return;
    Navigator.of(context).pop(info);
  }

  @override
  Widget build(BuildContext context) {
    final showRest = _details || _review;
    return FlowScaffold(
      pageTitle: 'بيانات الضامن',
      pageIcon: Icons.people_alt,
      body: FlowBody(
        footer: _review
            ? FlowSaveButton(
                enabled: _formReady,
                onPressed: () => _submit(saved: true),
              )
            : FlowActionButton(
                label: showRest ? 'اضافة' : 'استكمال بيانات العميل',
                enabled: showRest ? _formReady : _introReady,
                onPressed: showRest
                    ? () => _submit(saved: false)
                    : () => setState(() {
                        _details = true;
                        _open.add('basic');
                      }),
              ),
        children: [
          FlowSection(
            title: 'بيانات عامة',
            step: '١',
            expanded: _open.contains('general'),
            onToggle: () => _toggle('general'),
            onClear: _open.contains('general')
                ? _clear(const ['order', 'relation'])
                : null,
            child: Column(
              children: [
                FlowChoiceField(
                  label: 'ترتيب الضامن',
                  value: _store.text('order'),
                  hint: 'اختر ترتيب الضامن',
                  onTap: () => _choose('order', 'ترتيب الضامن', const [
                    'الاول',
                    'الثاني',
                    'الثالث',
                    'الرابع',
                  ]),
                ),
                SizedBox(height: 12.h),
                FlowChoiceField(
                  label: 'صلة القرابة بالعميل',
                  value: _store.text('relation'),
                  hint: 'اختر صلة القرابة بالعميل',
                  onTap: () =>
                      _choose('relation', 'صلة القرابة بالعميل', const [
                        'اب',
                        'ام',
                        'اخ',
                        'اخت',
                        'زوج',
                        'زوجة',
                        'ابن',
                        'ابنة',
                      ]),
                ),
              ],
            ),
          ),
          FlowSection(
            title: 'بطاقة الرقم القومي',
            step: '٢',
            expanded: _open.contains('id'),
            onToggle: () => _toggle('id'),
            onClear: _open.contains('id') ? _clear(const ['nationalId']) : null,
            child: Column(
              children: [
                const FlowLabel('الرقم القومي'),
                SizedBox(height: 6.h),
                FlowTextField(
                  controller: _store.field('nationalId'),
                  hint: 'ادخل الرقم القومي المكون من 14 رقم',
                  digitsOnly: true,
                  maxLength: 14,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                ),
                SizedBox(height: 14.h),
                if (showRest) const _UnregisteredNote(),
              ],
            ),
          ),
          if (showRest) ...[
            FlowSection(
              title: 'البيانات الاساسية',
              step: '٣',
              expanded: _open.contains('basic'),
              onToggle: () => _toggle('basic'),
              onClear: _open.contains('basic') ? _clear(_basicKeys) : null,
              child: _basicFields(),
            ),
            FlowSection(
              title: 'عنوان الاقامة',
              step: '٤',
              expanded: _open.contains('home'),
              onToggle: () => _toggle('home'),
              onClear: _open.contains('home')
                  ? _clear(_addressKeys('res'))
                  : null,
              child: _addressFields('res', detailed: true),
            ),
            FlowSection(
              title: 'عنوان البطاقة',
              step: '٥',
              expanded: _open.contains('card'),
              onToggle: () => _toggle('card'),
              onClear: _open.contains('card')
                  ? _clear(_addressKeys('card'))
                  : null,
              child: _addressFields('card', copyFromHome: true),
            ),
            FlowSection(
              title: 'بيانات التواصل',
              step: '٦',
              expanded: _open.contains('contact'),
              onToggle: () => _toggle('contact'),
              onClear: _open.contains('contact') ? _clear(_contactKeys) : null,
              child: _contactFields(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _basicFields() {
    return Column(
      children: [
        _idBanner(_store.text('nationalId')),
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
          controller: _store.field('phone1'),
          hint: '01xxxxxxxxx',
          digitsOnly: true,
          maxLength: 11,
          keyboardType: TextInputType.phone,
          onChanged: (_) => setState(() {}),
          prefix: const _DialCode(),
        ),
        SizedBox(height: 12.h),
        const FlowLabel('تليفون 2'),
        SizedBox(height: 6.h),
        FlowTextField(
          controller: _store.field('phone2'),
          hint: '01xxxxxxxxx',
          digitsOnly: true,
          maxLength: 11,
          keyboardType: TextInputType.phone,
          onChanged: (_) => setState(() {}),
          prefix: const _DialCode(),
        ),
        SizedBox(height: 12.h),
        _labeled('البريد الالكتروني', 'email', 'example@example.com'),
      ],
    );
  }

  Widget _idBanner(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF3C92D6),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          Text(
            value,
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
          SizedBox(width: 6.w),
          const Icon(Icons.badge_outlined, color: AppColors.white, size: 16),
        ],
      ),
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
          Row(
            textDirection: TextDirection.ltr,
            children: [
              const Spacer(),
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF3C92D6),
                  fontWeight: FontWeight.w800,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(Icons.info, color: const Color(0xFF3C92D6), size: 16.r),
            ],
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
          controller: _store.field(key),
          hint: hint,
          digitsOnly: digits,
          keyboardType: digits ? TextInputType.number : TextInputType.text,
          onChanged: (_) => setState(() {}),
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

class _UnregisteredNote extends StatelessWidget {
  const _UnregisteredNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F8EE),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            textDirection: TextDirection.ltr,
            children: [
              const Spacer(),
              Text(
                'الضامن غير مسجل',
                style: TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.w800,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(width: 6.w),
              Icon(Icons.check_circle, color: AppColors.success, size: 16.r),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'الرقم القومي الذي تم إدخاله غير مسجل مسبقاً، يرجى إدخال بيانات الضامن التالية لاستكمال التسجيل',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: const Color(0xFF6AA884),
              fontSize: 12.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
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
