import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/screens/financing/client_data_screen.dart';
import 'package:loanofficer/screens/financing/documents_screen.dart';
import 'package:loanofficer/screens/financing/establishment_data_screen.dart';
import 'package:loanofficer/screens/financing/financing_kit.dart';
import 'package:loanofficer/screens/financing/guarantor_data_screen.dart';

class NewIndividualRequestScreen extends StatefulWidget {
  const NewIndividualRequestScreen({super.key});

  @override
  State<NewIndividualRequestScreen> createState() =>
      _NewIndividualRequestScreenState();
}

class _NewIndividualRequestScreenState
    extends State<NewIndividualRequestScreen> {
  final _amount = TextEditingController();
  final _installments = TextEditingController();
  String? _product;
  ClientInfo? _client;
  EstablishmentInfo? _establishment;
  final List<GuarantorInfo> _guarantors = [];
  DocumentsInfo? _documents;

  bool get _financingReady =>
      _product != null &&
      _amount.text.trim().isNotEmpty &&
      _installments.text.trim().isNotEmpty;

  @override
  void dispose() {
    _amount.dispose();
    _installments.dispose();
    super.dispose();
  }

  Future<void> _pickProduct() async {
    final choice = await showChoiceDialog(
      context: context,
      title: 'اختر المنتج التمويلي',
      subtitle: 'اختر المنتج التمويلي الذي يرغب به العميل',
      options: financingProducts,
      selected: _product,
    );
    if (!mounted || choice == null) return;
    setState(() => _product = choice);
  }

  Future<void> _openClient() async {
    final result = await Navigator.of(context).push<ClientInfo>(
      MaterialPageRoute(builder: (_) => ClientDataScreen(initial: _client)),
    );
    if (!mounted || result == null) return;
    setState(() => _client = result);
  }

  Future<void> _openEstablishment() async {
    final result = await Navigator.of(context).push<EstablishmentInfo>(
      MaterialPageRoute(
        builder: (_) => EstablishmentDataScreen(initial: _establishment),
      ),
    );
    if (!mounted || result == null) return;
    setState(() => _establishment = result);
  }

  Future<void> _openGuarantor([int? index]) async {
    final result = await Navigator.of(context).push<GuarantorInfo>(
      MaterialPageRoute(
        builder: (_) => GuarantorDataScreen(
          initial: index == null ? null : _guarantors[index],
        ),
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      if (index == null) {
        _guarantors.add(result);
      } else {
        _guarantors[index] = result;
      }
    });
  }

  Future<void> _openDocuments() async {
    final result = await Navigator.of(context).push<DocumentsInfo>(
      MaterialPageRoute(
        builder: (_) => DocumentsScreen(
          initial: _documents,
          client: _client,
          establishment: _establishment,
          guarantor: _guarantors.isEmpty ? null : _guarantors.first,
        ),
      ),
    );
    if (!mounted || result == null) return;
    setState(() => _documents = result.count == 0 ? null : result);
  }

  Future<void> _sendRequest() async {
    await showFlowSuccess(
      context,
      message: 'لقد قمت بإنشاء وإرسال طلب التمويل بنجاح',
      note: 'الطلب الان في مرحلة المراجعة\nيمكنك متابعة الطلب من صفحة\nمتابعة طلبات التمويل',
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      pageTitle: 'طلب تمويل فردي جديد',
      pageIcon: Icons.add,
      onBack: () => Navigator.of(context).pop(),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        children: [
          _FinancingCard(
            product: _product,
            amount: _amount,
            installments: _installments,
            clientDone: _client != null,
            establishmentDone: _establishment != null,
            guarantorDone: _guarantors.isNotEmpty,
            documentsDone: _documents != null,
            onProduct: _pickProduct,
            onChanged: () => setState(() {}),
          ),
          SizedBox(height: 14.h),
          if (_client == null)
            _StepCard(
              title: 'بيانات العميل',
              step: '٢',
              label: 'اضف عميل',
              enabled: _financingReady,
              onPressed: _openClient,
            )
          else
            _PersonCard(
              name: _client!.fullName,
              subtitle: _client!.clientNumber,
              barLabel: 'رقم البطاقة',
              barValue: _client!.nationalId,
              icon: Icons.person,
              onTap: _openClient,
            ),
          SizedBox(height: 14.h),
          if (_establishment == null)
            _StepCard(
              title: 'بيانات المنشأة',
              step: '٣',
              label: 'اضف منشأة',
              enabled: _client != null,
              onPressed: _openEstablishment,
            )
          else
            _PersonCard(
              name: _establishment!.name,
              subtitle: _establishment!.activity,
              barLabel: 'رقم السجل',
              barValue: _establishment!.registerNumber,
              icon: Icons.storefront_outlined,
              onTap: _openEstablishment,
            ),
          SizedBox(height: 14.h),
          if (_guarantors.isEmpty)
            _StepCard(
              title: 'بيانات الضامن',
              step: '٤',
              label: 'اضف ضامن',
              enabled: _establishment != null,
              onPressed: _openGuarantor,
            )
          else ...[
            for (var index = 0; index < _guarantors.length; index++) ...[
              _PersonCard(
                name: _guarantors[index].fullName,
                subtitle: _guarantors[index].clientNumber,
                barLabel: 'رقم البطاقة',
                barValue: _guarantors[index].nationalId,
                icon: Icons.person,
                onTap: () => _openGuarantor(index),
                chips: [
                  _Tag(
                    'ضامن',
                    const Color(0xFFE5F8EC),
                    const Color(0xFF1F8A4C),
                  ),
                  _Tag(
                    'ترتيبه: ${_guarantors[index].order}',
                    const Color(0xFF8E3B3B),
                    AppColors.white,
                  ),
                ],
              ),
              SizedBox(height: 14.h),
            ],
            _AddAnotherButton(onPressed: _openGuarantor),
          ],
          SizedBox(height: 14.h),
          if (_documents == null)
            _StepCard(
              title: 'تحميل المستندات',
              step: '٥',
              label: 'تحميل المستندات',
              enabled: _guarantors.isNotEmpty,
              onPressed: _openDocuments,
            )
          else ...[
            _PersonCard(
              name: 'مستندات الطلب',
              subtitle: '${_documents!.count} مستند',
              barLabel: '',
              barValue: '',
              icon: Icons.description_outlined,
              showBar: false,
              onTap: _openDocuments,
            ),
            SizedBox(height: 14.h),
            FlowActionButton(
              label: 'ارسال الطلب',
              enabled: true,
              onPressed: _sendRequest,
            ),
          ],
        ],
      ),
    );
  }
}

class _FinancingCard extends StatelessWidget {
  const _FinancingCard({
    required this.product,
    required this.amount,
    required this.installments,
    required this.clientDone,
    required this.establishmentDone,
    required this.guarantorDone,
    required this.documentsDone,
    required this.onProduct,
    required this.onChanged,
  });

  final String? product;
  final TextEditingController amount;
  final TextEditingController installments;
  final bool clientDone;
  final bool establishmentDone;
  final bool guarantorDone;
  final bool documentsDone;
  final VoidCallback onProduct;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.ltr,
            children: [
              const Spacer(),
              Text(
                'بيانات التمويل',
                style: TextStyle(
                  color: const Color(0xFFE14B4B),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 22.r,
                height: 22.r,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFE14B4B),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '١',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 22.h, color: AppColors.line),
          FlowChoiceField(
            label: 'المنتج التمويلي',
            value: product ?? '',
            hint: 'اختر المنتج المطلوب',
            onTap: onProduct,
          ),
          SizedBox(height: 14.h),
          const FlowLabel('المبلغ المطلوب'),
          SizedBox(height: 6.h),
          FlowTextField(
            controller: amount,
            hint: 'ادخل المبلغ',
            digitsOnly: true,
            keyboardType: TextInputType.number,
            onChanged: (_) => onChanged(),
            prefix: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const EgyptFlag(),
                SizedBox(width: 4.w),
                Text(
                  'ج.م',
                  style: TextStyle(
                    color: const Color(0xFF5C6F8A),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          const FlowLabel('عدد الاقساط'),
          SizedBox(height: 6.h),
          FlowTextField(
            controller: installments,
            hint: 'ادخل عدد الاقساط',
            digitsOnly: true,
            keyboardType: TextInputType.number,
            onChanged: (_) => onChanged(),
          ),
          SizedBox(height: 14.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFE7F3FC),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFB9D7F2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    const Spacer(),
                    Text(
                      'لاستكمال طلب التمويل',
                      style: TextStyle(
                        color: const Color(0xFF3C92D6),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Icon(
                      Icons.info,
                      color: const Color(0xFF3C92D6),
                      size: 16.r,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                _CheckLine(
                  clientDone
                      ? 'تم ادخال بيانات العميل'
                      : 'قم بادخال بيانات العميل',
                  clientDone,
                ),
                _CheckLine(
                  establishmentDone
                      ? 'تم بادخال بيانات المنشأة'
                      : 'قم بادخال بيانات المنشأة',
                  establishmentDone,
                ),
                _CheckLine(
                  guarantorDone
                      ? 'تم ادخال بيانات الضامن'
                      : 'قم بادخال بيانات الضامن',
                  guarantorDone,
                ),
                _CheckLine(
                  documentsDone
                      ? 'تم تحميل المستندات المطلوبة'
                      : 'قم بتحميل المستندات المطلوبة',
                  documentsDone,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckLine extends StatelessWidget {
  const _CheckLine(this.text, this.done);

  final String text;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          const Spacer(),
          Text(
            text,
            style: TextStyle(
              color: const Color(0xFF3C92D6),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 6.w),
          Icon(
            done ? Icons.check_circle : Icons.circle,
            size: done ? 14.r : 6.r,
            color: done ? AppColors.success : const Color(0xFF3C92D6),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.title,
    required this.step,
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  final String title;
  final String step;
  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 16.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.ltr,
            children: [
              const Spacer(),
              Text(
                title,
                style: TextStyle(
                  color: const Color(0xFFE14B4B),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                width: 22.r,
                height: 22.r,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFE14B4B),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  step,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          FlowActionButton(
            label: label,
            enabled: enabled,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

class _PersonCard extends StatelessWidget {
  const _PersonCard({
    required this.name,
    required this.subtitle,
    required this.barLabel,
    required this.barValue,
    required this.icon,
    required this.onTap,
    this.chips = const [],
    this.showBar = true,
  });

  final String name;
  final String subtitle;
  final String barLabel;
  final String barValue;
  final IconData icon;
  final VoidCallback onTap;
  final List<Widget> chips;
  final bool showBar;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF7F8FA),
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Padding(
          padding: EdgeInsets.all(14.w),
          child: Column(
            children: [
              Row(
                textDirection: TextDirection.ltr,
                children: [
                  Icon(
                    Icons.chevron_left,
                    color: const Color(0xFFC5CED6),
                    size: 26.r,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          name.isEmpty ? '—' : name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF2C2C2C),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 12.sp,
                          ),
                        ),
                        if (chips.isNotEmpty) ...[
                          SizedBox(height: 6.h),
                          Wrap(
                            spacing: 6.w,
                            alignment: WrapAlignment.end,
                            textDirection: TextDirection.rtl,
                            children: chips,
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  CircleAvatar(
                    radius: 18.r,
                    backgroundColor: AppColors.iconBubble,
                    child: Icon(icon, color: AppColors.accent, size: 18.r),
                  ),
                ],
              ),
              if (showBar) ...[
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3C92D6),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    textDirection: TextDirection.ltr,
                    children: [
                      Text(
                        barValue,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        barLabel,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      const Icon(
                        Icons.badge_outlined,
                        color: AppColors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text, this.background, this.foreground);

  final String text;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: foreground,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _AddAnotherButton extends StatelessWidget {
  const _AddAnotherButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF2C2C2C),
          side: const BorderSide(color: Color(0xFF2C2C2C), width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800),
        ),
        icon: const Icon(Icons.add_box_outlined, size: 18),
        label: const Text('اضافة ضامن اخر'),
      ),
    );
  }
}
