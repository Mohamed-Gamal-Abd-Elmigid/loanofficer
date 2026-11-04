import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/funding_orders_api.dart';
import 'package:loanofficer/core/api/personal_fund_api.dart';
import 'package:loanofficer/core/components/app_loading.dart';
import 'package:loanofficer/core/models/fund_workflow_authority.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/core/validation/fmc_validation.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';
import 'package:loanofficer/presenter/fund_track/model/personal_fund_documents_bundle.dart';
import 'package:loanofficer/presenter/fund_track/model/personal_fund_form_patch.dart';
import 'package:loanofficer/presenter/fund_track/widgets/personal_fund_documents_tab.dart';
import 'package:loanofficer/presenter/fund_track/widgets/personal_fund_fund_tab.dart';
import 'package:loanofficer/presenter/fund_track/widgets/personal_fund_refusal_tab.dart';
import 'package:loanofficer/presenter/fund_track/widgets/personal_fund_shared_widgets.dart';
import 'package:loanofficer/presenter/fund_track/widgets/personal_fund_tab_chrome.dart';
import 'package:loanofficer/presenter/fund_track/widgets/personal_fund_warranties_tab.dart';
import 'package:loanofficer/presenter/fund_track/widgets/personal_fund_workflow_actions.dart';

/// Full personal fund wizard (web `/funding-requests/personal/...`): patch, tabs, authority, save.
class PersonalFundDetailScene extends StatefulWidget {
  const PersonalFundDetailScene({super.key, required this.order});

  final FundingOrderRow order;

  @override
  State<PersonalFundDetailScene> createState() => _PersonalFundDetailSceneState();
}

class _TabMeta {
  const _TabMeta(this.id, this.label, this.role, this.load);

  final String id;
  final String label;
  final String? role;
  final Future<void> Function()? load;
}

class _PersonalFundDetailSceneState extends State<PersonalFundDetailScene>
    with TickerProviderStateMixin {
  final _api = PersonalFundApi();
  TabController? _tabs;
  final _reqAmount = TextEditingController();
  final _reqInstallments = TextEditingController();
  final _approvedAmount = TextEditingController();
  final _approvedInstallments = TextEditingController();
  final _saveComment = TextEditingController();

  Map<String, dynamic> _fund = {};
  FundWorkflowAuthority _authority = FundWorkflowAuthority();
  PersonalFundFormPatch? _patch;
  String? _error;
  bool _coreLoaded = false;

  List<_TabMeta> _tabMetas = const [];
  final _loaded = <String>{};
  final _loadingTabs = <String>{};

  List<Map<String, dynamic>> _grantors = [];
  List<Map<String, dynamic>> _inkind = [];
  PersonalFundDocumentsBundle _docBundle = const PersonalFundDocumentsBundle();
  List<Map<String, dynamic>> _refusals = [];
  String get _previousStatus => widget.order.details.previousStatus;

  @override
  void initState() {
    super.initState();
    _loadCore();
  }

  @override
  void dispose() {
    _tabs?.dispose();
    _reqAmount.dispose();
    _reqInstallments.dispose();
    _approvedAmount.dispose();
    _approvedInstallments.dispose();
    _saveComment.dispose();
    super.dispose();
  }

  void _bindTabs() {
    final metas = <_TabMeta>[
      const _TabMeta('fund', 'بيانات التمويل', 'RT_LOAN', null),
      if (_authority.warrantiesTab)
        _TabMeta('warr', 'الضمانات', 'RT_GRANTS', _loadWarranties),
      if (_authority.documentsTab)
        _TabMeta('docs', 'المستندات', 'RT_DOCS', _loadDocuments),
      if (_authority.refusalTab)
        _TabMeta('refuse', 'أسباب الرفض', 'RT_REJECTS', _loadRefusal),
    ];
    _tabs?.dispose();
    _tabMetas = metas;
    _tabs = TabController(length: metas.length, vsync: this)
      ..addListener(_onTabChanged);
  }

  void _onTabChanged() {
    final c = _tabs;
    if (c == null) return;
    // Start fetch as soon as the tab index changes (don't wait for animation).
    final idx = c.index;
    if (idx < 0 || idx >= _tabMetas.length) return;
    _tabMetas[idx].load?.call();
  }

  bool _tabLoading(String id) =>
      _loadingTabs.contains(id) || !_loaded.contains(id);

  Future<void> _loadCore() async {
    try {
      late Map<String, dynamic> fund;
      var authorityRaw = <String, dynamic>{};
      // One global loader for fund + authority (avoid local + stacked overlays).
      await AppLoading.watch(() async {
        fund = await _api.fundByServiceId(widget.order.serviceId);
        final wfCode = '${fund['wfCode'] ?? widget.order.wfCode}';
        final stepId = widget.order.details.currentStepId.isEmpty
            ? '1'
            : widget.order.details.currentStepId;
        if (wfCode.isNotEmpty) {
          authorityRaw =
              await _api.stepAuthority(wfCode: wfCode, stepId: stepId);
        }
      });
      if (!mounted) return;
      final patch = PersonalFundFormPatch(fundRaw: fund, order: widget.order);
      _reqAmount.text = patch.reqAmount;
      _reqInstallments.text = patch.reqNoOfksts;
      _approvedAmount.text = patch.approvedAmount;
      _approvedInstallments.text = patch.approvedNoOfksts;
      setState(() {
        _fund = fund;
        _authority = FundWorkflowAuthority.fromMap(authorityRaw);
        _patch = patch;
        _coreLoaded = true;
      });
      _bindTabs();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = apiErrorMessage(error);
        _coreLoaded = true;
      });
      _bindTabs();
    }
  }

  Future<void> _loadOnce(String id, Future<void> Function() fn) async {
    if (_loaded.contains(id) || _loadingTabs.contains(id)) return;
    _loadingTabs.add(id);
    if (mounted) setState(() {});
    try {
      await fn();
      _loaded.add(id);
    } finally {
      _loadingTabs.remove(id);
      if (mounted) setState(() {});
    }
  }

  Future<void> _loadWarranties() => _loadOnce('warr', () async {
    var grantors = <Map<String, dynamic>>[];
    try {
      grantors = await _api.personalGrantors(widget.order.serviceId);
    } catch (_) {}

    var inkind = <Map<String, dynamic>>[];
    final custno = '${_fund['custno'] ?? ''}';
    if (custno.isNotEmpty && _authority.tabVisible('RT_GUARANTEES')) {
      try {
        inkind = await _api.inkindGuarantees(custno);
      } catch (_) {}
    }

    if (!mounted) return;
    setState(() {
      _grantors = grantors;
      _inkind = inkind;
    });
  });

  Future<void> _loadDocuments() => _loadOnce('docs', () async {
    final loanType = '${_fund['loanType'] ?? ''}';
    if (loanType.isEmpty) return;
    if (_previousStatus == 'REFUSED' && !_loaded.contains('refuse')) {
      await _loadRefusal();
    }
    var bundle = await _api.stageDocuments(
      serviceId: widget.order.serviceId,
      loanType: loanType,
      prodType: '${_fund['prodType'] ?? '1'}',
      stepId: _patch?.stepId ?? '1',
    );
    if (_previousStatus == 'REFUSED') {
      final docIds = <dynamic>[];
      for (final row in _refusals) {
        final ids = row['ids'];
        if (ids is List) docIds.addAll(ids);
      }
      bundle = docIds.isEmpty
          ? bundle.copyWithAllDisabled()
          : bundle.withRefusalDocIds(docIds);
    }
    if (!mounted) return;
    setState(() => _docBundle = bundle);
  });

  Future<void> _reloadWarranties() async {
    _loaded.remove('warr');
    await _loadWarranties();
  }

  Future<void> _reloadDocuments() async {
    _loaded.remove('docs');
    await _loadDocuments();
  }

  Future<void> _reloadRefusal() async {
    _loaded.remove('refuse');
    await _loadRefusal();
  }

  Future<void> _loadRefusal() => _loadOnce('refuse', () async {
    final ticket = _patch?.ticketId ?? widget.order.ticketId;
    if (ticket.isEmpty) return;
    final rows = await _api.rejectionReasons(ticket);
    if (!mounted) return;
    setState(() => _refusals = rows);
  });

  Future<bool> _saveFundDataSilent() async {
    try {
      await _saveFundData(showToast: false);
      return true;
    } catch (error) {
      _toast(apiErrorMessage(error));
      return false;
    }
  }

  Future<void> _saveFundData({bool showToast = true}) async {
    final patch = _patch;
    if (patch == null) return;
    final maxAmount = int.tryParse('${_fund['maxAmount'] ?? ''}');
    final amountErr = FmcValidation.requestedAmount(
      _reqAmount.text,
      maxAmount,
    );
    if (amountErr != null) {
      if (showToast) _toast(amountErr);
      throw StateError(amountErr);
    }
    try {
      await _api.savePersonalRequest(
        patch.savePayload(
          comment: _saveComment.text.trim(),
          reqAmountOverride: _reqAmount.text.trim(),
          reqNoOfkstsOverride: _reqInstallments.text.trim(),
          approvedAmountOverride: _approvedAmount.text.trim(),
          approvedNoOfkstsOverride: _approvedInstallments.text.trim(),
        ),
      );
      await _api.wfActionSave(
        patch.wfSavePayload(comment: _saveComment.text.trim()),
      );
      if (showToast) _toast('تم حفظ بيانات التمويل');
      await _loadCore();
    } catch (error) {
      if (showToast) {
        _toast(apiErrorMessage(error));
      } else {
        rethrow;
      }
    }
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final tabs = _tabs;
    final tabItems = [
      for (final m in _tabMetas) (id: m.id, label: m.label),
    ];
    return FlowScaffold(
      hideBrandHeader: true,
      pageTitle: 'طلب تمويل فردي',
      pageIcon: Icons.account_balance_wallet_outlined,
      onBack: () => Navigator.of(context).pop(),
      body: !_coreLoaded || tabs == null
          ? const SizedBox.shrink()
          : ColoredBox(
              color: AppColors.page,
              // Order card collapses on scroll; tab bar stays pinned. Scroll up
              // again (including from the tab strip) to reveal the card.
              child: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _OrderHeaderCard(
                            order: widget.order,
                            fund: _fund,
                            patch: _patch,
                          ),
                          if (_patch != null)
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                              child: PersonalFundWorkflowActions(
                                authority: _authority,
                                patch: _patch!,
                                api: _api,
                                stageId: _patch!.stageId,
                                serviceId: _patch!.serviceId,
                                onBeforeApprove: _saveFundDataSilent,
                                onSuccess: () {
                                  _toast('تم تنفيذ الإجراء');
                                  if (mounted) {
                                    Navigator.of(context).pop();
                                  }
                                },
                                onError: _toast,
                              ),
                            ),
                          SizedBox(height: 4.h),
                        ],
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: PersonalFundPinnedTabBarDelegate(
                        controller: tabs,
                        tabs: tabItems,
                        elevated: innerBoxIsScrolled,
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: tabs,
                  children: [
                    for (final m in _tabMetas) _buildTab(m),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTab(_TabMeta meta) {
    switch (meta.id) {
      case 'fund':
        return PersonalFundFundTab(
          order: widget.order,
          fund: _fund,
          patch: _patch!,
          authority: _authority,
          reqAmount: _reqAmount,
          reqInstallments: _reqInstallments,
          approvedAmount: _approvedAmount,
          approvedInstallments: _approvedInstallments,
          saveComment: _saveComment,
          api: _api,
          onSave: _saveFundData,
          error: _error,
        );
      case 'warr':
        return PersonalFundWarrantiesTab(
          serviceId: widget.order.serviceId,
          custno: '${_fund['custno'] ?? ''}',
          applicantIdno: _patch?.idno ?? widget.order.custId,
          authority: _authority,
          api: _api,
          initialGrantors: _grantors,
          initialInkind: _inkind,
          loading: _tabLoading('warr'),
          onReload: _reloadWarranties,
        );
      case 'docs':
        return PersonalFundDocumentsTab(
          bundle: _docBundle,
          authority: _authority,
          api: _api,
          idno: _patch?.idno ?? widget.order.custId,
          serviceId: widget.order.serviceId,
          ticketId: _patch?.ticketId ?? widget.order.ticketId,
          orgId: '${_fund['orgId'] ?? ''}',
          loanType: '${_fund['loanType'] ?? ''}',
          prodType: '${_fund['prodType'] ?? '1'}',
          stepId: _patch?.stepId ?? '1',
          refusedFlow: _previousStatus == 'REFUSED',
          loading: _tabLoading('docs'),
          onReload: _reloadDocuments,
        );
      case 'refuse':
        return PersonalFundRefusalTab(
          ticketId: _patch?.ticketId ?? widget.order.ticketId,
          authority: _authority,
          api: _api,
          initialRows: _refusals,
          refusedFlow: _previousStatus == 'REFUSED',
          loading: _tabLoading('refuse'),
          onReload: _reloadRefusal,
        );
      default:
        return personalFundDisabledTab('—');
    }
  }
}

class _OrderHeaderCard extends StatelessWidget {
  const _OrderHeaderCard({
    required this.order,
    required this.fund,
    required this.patch,
  });

  final FundingOrderRow order;
  final Map<String, dynamic> fund;
  final PersonalFundFormPatch? patch;

  static String _pick(dynamic a, String b) {
    final t = a == null ? '' : '$a'.trim();
    return t.isNotEmpty ? t : b;
  }

  static String _fundText(Map<String, dynamic> fund, List<String> keys) {
    for (final key in keys) {
      final v = fund[key];
      if (v != null && '$v'.trim().isNotEmpty) return '$v'.trim();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final stage = _pick(
      fund['stageNameAr'] ?? fund['currentStageNameAr'],
      order.statusLabel,
    );
    final product = _fundText(fund, [
      'loanTypeNameAr',
      'loanTypeNameEn',
      'loanTypeName',
    ]);
    final amount = patch?.reqAmount.isNotEmpty == true
        ? patch!.reqAmount
        : _pick(fund['requiredValue'], order.requiredValue);
    final installments = patch?.reqNoOfksts.isNotEmpty == true
        ? patch!.reqNoOfksts
        : _fundText(fund, ['requiredNoOfKst', 'requiredNoOfksts']);

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 0),
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 3.h,
            decoration: BoxDecoration(gradient: personalFundBrandGradient),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48.r,
                      height: 48.r,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.iconBubble,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Icon(
                        Icons.person_outline,
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
                            _pick(fund['custName'], order.custName),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: AppFonts.dinNextArabic,
                              color: AppColors.primary,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'رقم الطلب ${_pick(fund['serviceId'], order.serviceId)}',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: AppFonts.dinNextArabic,
                              color: AppColors.fieldLabel,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (_pick(fund['idno'], order.custId).isNotEmpty) ...[
                            SizedBox(height: 2.h),
                            Text(
                              'الرقم القومي ${_pick(fund['idno'], order.custId)}',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: AppFonts.dinNextArabic,
                                color: AppColors.muted,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          if (stage.isNotEmpty) ...[
                            SizedBox(height: 6.h),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(color: AppColors.cardBorder),
                                ),
                                child: Text(
                                  stage,
                                  style: TextStyle(
                                    fontFamily: AppFonts.dinNextArabic,
                                    color: AppColors.primary,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    PersonalFundStatChip(
                      label: 'المنتج',
                      value: product.isEmpty ? '—' : product,
                      compact: true,
                    ),
                    SizedBox(width: 6.w),
                    PersonalFundStatChip(
                      label: 'المبلغ المطلوب',
                      value: amount.isEmpty ? '—' : amount,
                      highlight: true,
                      compact: true,
                    ),
                    SizedBox(width: 6.w),
                    PersonalFundStatChip(
                      label: 'الأقساط',
                      value: installments.isEmpty ? '—' : installments,
                      compact: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
