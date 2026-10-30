import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/screens/financing/financing_kit.dart';

class EstablishmentInfo {
  const EstablishmentInfo(this.values);

  final Map<String, String> values;

  String get name => values['name'] ?? '';
  String get activity => values['activity'] ?? '';
  String get registerNumber => values['registerNumber'] ?? '';
}

class EstablishmentDataScreen extends StatefulWidget {
  const EstablishmentDataScreen({super.key, this.initial});

  final EstablishmentInfo? initial;

  @override
  State<EstablishmentDataScreen> createState() =>
      _EstablishmentDataScreenState();
}

class _EstablishmentDataScreenState extends State<EstablishmentDataScreen> {
  final _store = FormStore();
  bool _review = false;
  final Set<String> _open = {'partners'};

  static const _keys = [
    'name',
    'activity',
    'registerNumber',
    'partnerName',
    'partnerId',
    'partnerBirth',
    'partnerNationality',
    'partnerRole',
    'partnerValue',
    'partnerShare',
    'foundingDate',
    'phone',
    'location',
    'address',
  ];

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

  bool get _canAdd => _keys.every((key) {
    final value = _store.text(key);
    if (key == 'partnerId') return value.length == 14;
    return value.isNotEmpty;
  });

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

  Future<void> _date() async {
    final value = await pickFlowDate(context);
    if (!mounted || value == null) return;
    setState(() => _store.field('partnerBirth').text = value);
  }

  Future<void> _submit({required bool saved}) async {
    final info = EstablishmentInfo({
      for (final key in _keys) key: _store.text(key),
    });
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
  Widget build(BuildContext context) {
    return FlowScaffold(
      pageTitle: 'بيانات المنشأة',
      pageIcon: Icons.storefront_outlined,
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
          FlowSection(
            title: 'بيانات المنشأة',
            step: '١',
            expanded: _open.contains('info'),
            onToggle: () => _toggle('info'),
            child: Column(
              children: [
                _labeled('اسم المنشأة', 'name', 'ادخل اسم المنشأة'),
                SizedBox(height: 12.h),
                _labeled('النشاط', 'activity', 'ادخل نشاط المنشأة'),
                SizedBox(height: 12.h),
                _labeled(
                  'رقم السجل',
                  'registerNumber',
                  'ادخل رقم السجل',
                  digits: true,
                ),
              ],
            ),
          ),
          FlowSection(
            title: 'بيانات التأسيس',
            step: '٢',
            expanded: _open.contains('founding'),
            onToggle: () => _toggle('founding'),
            child: _labeled('تاريخ التأسيس', 'foundingDate', '00/00/0000'),
          ),
          FlowSection(
            title: 'بيانات التواصل',
            step: '٣',
            expanded: _open.contains('contact'),
            onToggle: () => _toggle('contact'),
            child: _labeled(
              'تليفون المنشأة',
              'phone',
              '01xxxxxxxxx',
              digits: true,
            ),
          ),
          FlowSection(
            title: 'موقع المنشأة',
            step: '٤',
            expanded: _open.contains('location'),
            onToggle: () => _toggle('location'),
            child: _labeled('وصف الموقع', 'location', 'ادخل موقع المنشأة'),
          ),
          FlowSection(
            title: 'عنوان المنشأة',
            step: '٥',
            expanded: _open.contains('address'),
            onToggle: () => _toggle('address'),
            child: _labeled('العنوان', 'address', 'ادخل عنوان المنشأة'),
          ),
          FlowSection(
            title: 'بيانات الشركاء',
            step: '٦',
            expanded: _open.contains('partners'),
            onToggle: () => _toggle('partners'),
            onClear: _open.contains('partners')
                ? () => setState(
                    () => _store.clearKeys(const [
                      'partnerName',
                      'partnerId',
                      'partnerBirth',
                      'partnerNationality',
                      'partnerRole',
                      'partnerValue',
                      'partnerShare',
                    ]),
                  )
                : null,
            child: _partners(),
          ),
        ],
      ),
    );
  }

  Widget _partners() {
    return Column(
      children: [
        Row(
          textDirection: TextDirection.ltr,
          children: [
            const Spacer(),
            Text(
              'الشريك الاول',
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
        _labeled('اسم الشريك', 'partnerName', 'ادخل اسم الشريك'),
        SizedBox(height: 12.h),
        _labeled(
          'الرقم القومي للشريك',
          'partnerId',
          'ادخل الرقم القومي المكون من 14 رقم',
          digits: true,
          maxLength: 14,
        ),
        SizedBox(height: 12.h),
        FlowChoiceField(
          label: 'تاريخ الميلاد',
          value: _store.text('partnerBirth'),
          hint: '00/00/0000',
          onTap: _date,
        ),
        SizedBox(height: 12.h),
        FlowChoiceField(
          label: 'الجنسية',
          value: _store.text('partnerNationality'),
          hint: 'الجنسية',
          onTap: () => _choose('partnerNationality', 'الجنسية', const ['مصري']),
        ),
        SizedBox(height: 12.h),
        _labeled('مهامه بالشركة', 'partnerRole', 'ادخل مهامه بالشركة'),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _labeled(
                'نسبة الشراكة',
                'partnerShare',
                'نسبة الشراكة',
                digits: true,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _labeled(
                'قيمة الشراكة',
                'partnerValue',
                'قيمة الشراكة',
                digits: true,
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add_box_outlined),
          label: const Text('اضافة شريك'),
        ),
      ],
    );
  }

  Widget _labeled(
    String label,
    String key,
    String hint, {
    bool digits = false,
    int? maxLength,
  }) {
    return Column(
      children: [
        FlowLabel(label),
        SizedBox(height: 6.h),
        FlowTextField(
          controller: _store.field(key),
          hint: hint,
          digitsOnly: digits,
          maxLength: maxLength,
          keyboardType: digits ? TextInputType.number : TextInputType.text,
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }
}
