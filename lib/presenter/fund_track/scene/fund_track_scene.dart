import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fund_track_api.dart';
import 'package:loanofficer/core/api/funding_orders_api.dart';
import 'package:loanofficer/core/bases/base_state.dart';
import 'package:loanofficer/core/bases/states/base/base_state.dart';
import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/core/validation/fmc_validation.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';
import 'package:loanofficer/presenter/fund_track/bloc/fund_track_bloc.dart';
import 'package:loanofficer/presenter/fund_track/event/fund_track_event.dart';
import 'package:loanofficer/presenter/fund_track/model/fund_track_model.dart';
import 'package:loanofficer/presenter/fund_track/scene/fund_track_detail_scene.dart';
import 'package:loanofficer/presenter/fund_track/scene/personal_fund_detail_scene.dart';
import 'package:loanofficer/presenter/fund_track/state/fund_track_state.dart';

class FundTrackScene extends StatefulWidget {
  const FundTrackScene({super.key, this.embedInShell = false});

  final bool embedInShell;

  @override
  State<FundTrackScene> createState() => _FundTrackSceneState();
}

class _FundTrackSceneState
    extends BaseState<FundTrackScene, FundTrackBloc, FundTrackModel> {
  final _filter = TextEditingController();
  final _wfApi = FundTrackApi();
  bool _sortCreatedDesc = true;
  int _pageIndex = 0;
  int _pageSize = 10;
  static const _pageSizes = [10, 25, 50];

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  List<FundingOrderRow> _visibleOrders(FundTrackModel data) {
    final q = _filter.text.trim().toLowerCase();
    var list = List<FundingOrderRow>.from(data.orders);
    if (q.isNotEmpty) {
      list = list.where((row) {
        return row.serviceId.toLowerCase().contains(q) ||
            row.custId.toLowerCase().contains(q) ||
            row.custName.toLowerCase().contains(q) ||
            row.createdDate.toLowerCase().contains(q);
      }).toList();
    }
    list.sort((a, b) {
      final cmp = a.createdDate.compareTo(b.createdDate);
      return _sortCreatedDesc ? -cmp : cmp;
    });
    return list;
  }

  List<FundingOrderRow> _pageOrders(List<FundingOrderRow> all) {
    if (all.isEmpty) return const [];
    final maxPage = (all.length - 1) ~/ _pageSize;
    if (_pageIndex > maxPage) _pageIndex = maxPage;
    final start = _pageIndex * _pageSize;
    final end = (start + _pageSize).clamp(0, all.length);
    return all.sublist(start, end);
  }

  Future<void> _openOrderDetails(FundingOrderRow order) async {
    if (!order.isPersonalFund) {
      _toast('تفاصيل هذا النوع من الطلبات غير متاحة حالياً على الموبايل');
      return;
    }
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => PersonalFundDetailScene(order: order),
      ),
    );
    emit(LoadFundOrdersEvent());
  }

  Future<void> _openAdminTrack() async {
    final cust = TextEditingController();
    final service = TextEditingController();
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16.w,
            8.h,
            16.w,
            16.h + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'تتبع الطلبات (إدارة)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 12.h),
              FlowTextField(
                controller: cust,
                hint: 'رقم البطاقة',
                digitsOnly: true,
                maxLength: 14,
                keyboardType: TextInputType.number,
                onChanged: (_) {},
              ),
              SizedBox(height: 10.h),
              FlowTextField(
                controller: service,
                hint: 'رقم التمويل',
                digitsOnly: true,
                keyboardType: TextInputType.number,
                onChanged: (_) {},
              ),
              SizedBox(height: 14.h),
              FlowActionButton(
                label: 'بحث',
                enabled: true,
                onPressed: () async {
                  final custErr = FmcValidation.fundTrackCustId(cust.text);
                  final svcErr = FmcValidation.fundTrackServiceId(service.text);
                  if (custErr != null || svcErr != null) {
                    _toast(FmcValidation.fillFormMessage);
                    return;
                  }
                  Navigator.pop(context);
                  try {
                    final rows = await _wfApi.findWorkflowServices(
                      custIdno: cust.text.trim(),
                      serviceId: service.text.trim(),
                    );
                    if (!mounted) return;
                    if (rows.isEmpty) {
                      _toast('لا توجد نتائج');
                      return;
                    }
                    final first = rows.first;
                    await Navigator.of(this.context).push<void>(
                      MaterialPageRoute(
                        builder: (_) =>
                            FundTrackDetailScene(serviceId: first.serviceId),
                      ),
                    );
                  } catch (error) {
                    _toast(apiErrorMessage(error));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
    cust.dispose();
    service.dispose();
  }

  _StatusStyle _statusStyle(String code) {
    switch (code.toUpperCase()) {
      case 'SAVED':
        return const _StatusStyle(
          background: Color(0xFFFEF3C7),
          foreground: Color(0xFF92400E),
        );
      case 'APPROVED':
        return const _StatusStyle(
          background: Color(0xFFD1FAE5),
          foreground: Color(0xFF065F46),
        );
      case 'REFUSED':
      case 'REFUSED_FOR_UPDATE':
      case 'REFUSED_AMOUNT':
        return const _StatusStyle(
          background: Color(0xFFFCE7F3),
          foreground: Color(0xFFBE185D),
        );
      default:
        return const _StatusStyle(
          background: Color(0xFFFFEDD5),
          foreground: Color(0xFF9A3412),
        );
    }
  }

  @override
  Widget buildWidget(
    BuildContext context,
    RenderDataState<FundTrackModel> state,
  ) {
    final allOrders = _visibleOrders(state.data);
    final orders = _pageOrders(allOrders);
    final total = allOrders.length;
    final pageCount = total == 0 ? 1 : ((total - 1) ~/ _pageSize) + 1;
    return FlowScaffold(
      embedInShell: widget.embedInShell,
      pageTitle: widget.embedInShell ? null : 'متابعة الطلبات',
      pageIcon: Icons.fact_check_outlined,
      onBack: () => Navigator.of(context).pop(),
      body: ColoredBox(
        color: AppColors.page,
        child: ListView(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
          children: [
            Row(
              textDirection: TextDirection.ltr,
              children: [
                IconButton(
                  onPressed: () => emit(LoadFundOrdersEvent()),
                  icon: Icon(
                    Icons.refresh,
                    color: AppColors.accent,
                    size: 22.r,
                  ),
                ),
                IconButton(
                  onPressed: _openAdminTrack,
                  icon: Icon(Icons.tune, color: AppColors.accent, size: 22.r),
                ),
                Expanded(
                  child: FlowTextField(
                    controller: _filter,
                    hint: 'بحث في الطلبات',
                    onChanged: (_) => setState(() => _pageIndex = 0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Material(
              color: const Color(0xFFE7F3FC),
              borderRadius: BorderRadius.circular(12.r),
              child: InkWell(
                onTap: () =>
                    setState(() => _sortCreatedDesc = !_sortCreatedDesc),
                borderRadius: BorderRadius.circular(12.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Icon(
                        _sortCreatedDesc
                            ? Icons.arrow_downward_rounded
                            : Icons.arrow_upward_rounded,
                        size: 20.r,
                        color: const Color(0xFF032F64),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'ترتيب حسب تاريخ الإنشاء',
                        style: TextStyle(
                          color: const Color(0xFF032F64),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            if (total == 0)
              Padding(
                padding: EdgeInsets.only(top: 32.h),
                child: Text(
                  'لا توجد طلبات في صندوق الوارد',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF9AA3AE),
                    fontSize: 14.sp,
                  ),
                ),
              )
            else ...[
              for (final order in orders)
                _OrderCard(
                  order: order,
                  status: _statusStyle(order.statusCode),
                  onOpen: () => _openOrderDetails(order),
                ),
              SizedBox(height: 8.h),
              _FundTrackPaginationFooter(
                pageIndex: _pageIndex,
                pageCount: pageCount,
                pageSize: _pageSize,
                totalRecords: total,
                pageSizes: _pageSizes,
                onPageSize: (size) => setState(() {
                  _pageSize = size;
                  _pageIndex = 0;
                }),
                onPrev: () => setState(() {
                  if (_pageIndex > 0) _pageIndex--;
                }),
                onNext: () => setState(() {
                  if (_pageIndex < pageCount - 1) _pageIndex++;
                }),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void listenToState(BuildContext context, BaseStates state) {
    if (state is FundTrackMessage) _toast(state.message);
  }

  @override
  FundTrackBloc createBloc() => FundTrackBloc(FundTrackModel());
}

class _StatusStyle {
  const _StatusStyle({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}

class _FundTrackPaginationFooter extends StatelessWidget {
  const _FundTrackPaginationFooter({
    required this.pageIndex,
    required this.pageCount,
    required this.pageSize,
    required this.totalRecords,
    required this.pageSizes,
    required this.onPageSize,
    required this.onPrev,
    required this.onNext,
  });

  final int pageIndex;
  final int pageCount;
  final int pageSize;
  final int totalRecords;
  final List<int> pageSizes;
  final ValueChanged<int> onPageSize;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final start = totalRecords == 0 ? 0 : pageIndex * pageSize + 1;
    final end = (start + pageSize - 1).clamp(0, totalRecords);
    final canPrev = pageIndex > 0;
    final canNext = pageIndex < pageCount - 1;

    return Container(
      margin: EdgeInsets.only(top: 4.h, bottom: 8.h),
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFFD7E6F4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3D92D6).withValues(alpha: 0.08),
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 34.r,
                height: 34.r,
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F3FC),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.view_list_rounded,
                  size: 18.r,
                  color: AppColors.accent,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'تصفح الطلبات',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: AppFonts.dinNextArabic,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF032F64),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'عرض $start–$end من $totalRecords',
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: AppFonts.dinNextArabic,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.fieldLabel,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              _FundTrackPageSizeChip(
                pageSize: pageSize,
                pageSizes: pageSizes,
                onChanged: onPageSize,
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              _FundTrackNavButton(
                label: 'السابق',
                icon: Icons.chevron_right_rounded,
                enabled: canPrev,
                onPressed: onPrev,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Container(
                  height: 44.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F8FC),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFFD7E6F4)),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontFamily: AppFonts.dinNextArabic,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF032F64),
                      ),
                      children: [
                        TextSpan(text: 'صفحة '),
                        TextSpan(
                          text: '${pageIndex + 1}',
                          style: TextStyle(color: AppColors.accent),
                        ),
                        TextSpan(
                          text: ' من $pageCount',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.fieldLabel,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              _FundTrackNavButton(
                label: 'التالي',
                icon: Icons.chevron_left_rounded,
                enabled: canNext,
                onPressed: onNext,
                filled: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FundTrackPageSizeChip extends StatelessWidget {
  const _FundTrackPageSizeChip({
    required this.pageSize,
    required this.pageSizes,
    required this.onChanged,
  });

  final int pageSize;
  final List<int> pageSizes;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE7F3FC),
      borderRadius: BorderRadius.circular(12.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          final picked = await showFlowOptionSheet<int>(
            context: context,
            title: 'عدد الطلبات في الصفحة',
            current: pageSize,
            clearable: false,
            options: [
              for (final size in pageSizes)
                FlowPickerOption(value: size, label: '$size طلب'),
            ],
          );
          if (picked != null) onChanged(picked);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              Text(
                '$pageSize',
                style: TextStyle(
                  fontFamily: AppFonts.dinNextArabic,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accent,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                '/صفحة',
                style: TextStyle(
                  fontFamily: AppFonts.dinNextArabic,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3C7BA8),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18.r,
                color: AppColors.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FundTrackNavButton extends StatelessWidget {
  const _FundTrackNavButton({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.onPressed,
    this.filled = false,
  });

  final String label;
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
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
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(12.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        child: Container(
          height: 44.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: !enabled
                  ? const Color(0xFFE6E8EE)
                  : filled
                  ? AppColors.accent
                  : const Color(0xFFB8DCF5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              Icon(icon, size: 22.r, color: fg),
              SizedBox(width: 2.w),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppFonts.dinNextArabic,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.status,
    required this.onOpen,
  });

  final FundingOrderRow order;
  final _StatusStyle status;
  final VoidCallback onOpen;

  static String _display(String value) =>
      value.trim().isEmpty ? '—' : value.trim();

  @override
  Widget build(BuildContext context) {
    final order = this.order;
    final d = order.details;
    final amount = order.requiredValue.isEmpty
        ? '—'
        : '${order.requiredValue} ج.م';
    final created = order.createdDate.isNotEmpty
        ? order.createdDate
        : d.createdDate;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        _display(order.custName),
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF032F64),
                          height: 1.35,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: status.background,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        _display(order.statusLabel),
                        style: TextStyle(
                          color: status.foreground,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7FA),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFFE4E9F0)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _OrderMetric(
                              label: 'رقم الطلب',
                              value: _display(order.serviceId),
                              icon: Icons.confirmation_number_outlined,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _OrderMetric(
                              label: 'رقم البطاقة / السجل',
                              value: _display(order.custId),
                              icon: Icons.badge_outlined,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: _OrderMetric(
                              label: 'المبلغ المطلوب',
                              value: amount,
                              icon: Icons.payments_outlined,
                              emphasize: true,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _OrderMetric(
                              label: 'تاريخ الإنشاء',
                              value: _display(created),
                              icon: Icons.calendar_today_outlined,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: _OrderMetric(
                              label: 'نوع التمويل',
                              value: _display(order.loanTypeName),
                              icon: Icons.category_outlined,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _OrderMetric(
                              label: 'إسم الفرع',
                              value: _display(order.branchName),
                              icon: Icons.storefront_outlined,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F3FC),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFFB8DCF5)),
                  ),
                  child: Column(
                    children: [
                      _DetailLine(
                        icon: Icons.support_agent_outlined,
                        label: 'مسؤول التمويل',
                        value: d.createdUsrName,
                      ),
                      _DetailLine(
                        icon: Icons.send_outlined,
                        label: 'مرسل من مستخدم',
                        value: d.previousUsrName,
                      ),
                      _DetailLine(
                        icon: Icons.admin_panel_settings_outlined,
                        label: 'صلاحية المستخدم',
                        value: d.previousRoleName,
                      ),
                      _DetailLine(
                        icon: Icons.chat_bubble_outline,
                        label: 'تعليق آخر مستخدم',
                        value: d.previousComment,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
                SizedBox(
                  width: double.infinity,
                  height: 46.h,
                  child: FlowActionButton(
                    label: 'عرض وتعديل الطلب',
                    enabled: order.isPersonalFund,
                    onPressed: onOpen,
                  ),
                ),
                if (!order.isPersonalFund) ...[
                  SizedBox(height: 6.h),
                  Text(
                    'تفاصيل هذا النوع من الطلبات غير متاحة حالياً على الموبايل',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF9AA3AE),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderMetric extends StatelessWidget {
  const _OrderMetric({
    required this.label,
    required this.value,
    required this.icon,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE8EDF2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16.r, color: AppColors.accent),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF9AA3AE),
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: emphasize ? 13.sp : 12.sp,
              fontWeight: FontWeight.w800,
              color: emphasize
                  ? AppColors.accent
                  : const Color(0xFF032F64),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.r, color: const Color(0xFF3C92D6)),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: const Color(0xFF9AA3AE),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2C2C2C),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
