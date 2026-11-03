import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/fund_track_api.dart';
import 'package:loanofficer/core/api/personal_fund_api.dart';
import 'package:loanofficer/core/models/fund_workflow_authority.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';
import 'package:loanofficer/presenter/fund_track/model/personal_fund_form_patch.dart';

/// Workflow gear menu (web `buildRequestOrderMenu` + comment dialog).
class PersonalFundWorkflowActions extends StatelessWidget {
  const PersonalFundWorkflowActions({
    super.key,
    required this.authority,
    required this.patch,
    required this.api,
    required this.stageId,
    required this.serviceId,
    required this.onBeforeApprove,
    required this.onSuccess,
    required this.onError,
  });

  final FundWorkflowAuthority authority;
  final PersonalFundFormPatch patch;
  final PersonalFundApi api;
  final String stageId;
  final String serviceId;
  final Future<bool> Function() onBeforeApprove;
  final VoidCallback onSuccess;
  final void Function(String message) onError;

  static const _labels = <String, String>{
    'SAVE': 'حفظ مؤقت',
    'APPROVED': 'اعتماد',
    'REFUSED': 'رفض للتعديل',
    'DELEGATE': 'تحويل لمرحلة',
    'REJECTED': 'رفض نهائي',
    'CANCELLED': 'إلغاء الطلب',
    'FREEZED': 'تجميد',
    'ISCORE': 'استعلام iScore',
  };

  List<String> get _visibleIds {
    final ids = authority.visibleActions
        .map((e) => '${e['btnId']}'.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (ids.isEmpty) {
      return [
        if (authority.tabEditable('RT_LOAN')) 'SAVE',
      ];
    }
    return ids;
  }

  Future<void> _openMenu(BuildContext context) async {
    final ids = _visibleIds;
    if (ids.isEmpty) return;
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  'إجراءات الطلب',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              for (final id in ids)
                ListTile(
                  title: Text(
                    _labels[id] ?? id,
                    textAlign: TextAlign.right,
                  ),
                  onTap: () => Navigator.pop(ctx, id),
                ),
            ],
          ),
        );
      },
    );
    if (!context.mounted || picked == null) return;
    await _runAction(context, picked);
  }

  Future<void> _runAction(BuildContext context, String actionId) async {
    if (actionId == 'ISCORE') {
      onError('استعلام iScore غير متاح على الموبايل حالياً');
      return;
    }
    if (actionId == 'DELEGATE') {
      await _delegate(context);
      return;
    }
    if (actionId == 'SAVE') {
      try {
        final ok = await onBeforeApprove();
        if (!ok) return;
        await api.wfActionSave(patch.wfSavePayload());
        onSuccess();
      } catch (error) {
        onError('$error');
      }
      return;
    }
    final dialog = await _commentSheet(
      context,
      title: _labels[actionId] ?? actionId,
      askAmount: actionId == 'REFUSED' || actionId == 'REFUSED_AMOUNT',
    );
    if (dialog == null) return;

    try {
      if (actionId == 'APPROVED') {
        final ok = await onBeforeApprove();
        if (!ok) return;
        await api.wfActionApprove(_wfPayload(dialog));
        onSuccess();
        return;
      }
      if (actionId == 'REFUSED' || actionId == 'REFUSED_AMOUNT') {
        await api.wfActionRefuse(_wfPayload(dialog));
        onSuccess();
        return;
      }
      if (actionId == 'REJECTED') {
        await api.wfActionReject(_wfPayload(dialog));
        onSuccess();
        return;
      }
      if (actionId == 'CANCELLED') {
        await api.wfActionCancel(_wfPayload(dialog));
        onSuccess();
        return;
      }
      onError('الإجراء غير مدعوم بعد: $actionId');
    } catch (error) {
      onError('$error');
    }
  }

  Map<String, dynamic> _wfPayload(_WorkflowCommentResult dialog) {
    return {
      'ticketId': patch.ticketId,
      'serviceId': patch.serviceId,
      'prodType': patch.prodType,
      'comment': dialog.comment,
      'amount': dialog.amount,
      'noOfksts': dialog.noOfKsts,
      'stageId': stageId,
    };
  }

  Future<void> _delegate(BuildContext context) async {
    final track = FundTrackApi();
    FundTrackServiceDetail detail;
    try {
      detail = await track.serviceWorkflowReviews(serviceId);
    } catch (error) {
      onError('$error');
      return;
    }
    if (!context.mounted) return;
    final steps = detail.wfSteps;
    if (steps.isEmpty) {
      onError('لا توجد مراحل متاحة للتحويل');
      return;
    }
    final stageIds = await showModalBottomSheet<List<String>>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final selected = <String>{};
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Text(
                      'اختر المرحلة',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (final step in steps)
                          CheckboxListTile(
                            value: selected.contains(step.stageId),
                            title: Text(
                              step.stageNameAr.isEmpty
                                  ? step.stageId
                                  : step.stageNameAr,
                              textAlign: TextAlign.right,
                            ),
                            onChanged: (v) {
                              setState(() {
                                if (v == true) {
                                  selected.add(step.stageId);
                                } else {
                                  selected.remove(step.stageId);
                                }
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: FlowActionButton(
                      label: 'متابعة',
                      enabled: selected.isNotEmpty,
                      onPressed: () =>
                          Navigator.pop(ctx, selected.toList(growable: false)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    if (stageIds == null || stageIds.isEmpty) return;
    try {
      await api.wfRefusedSteps({
        'ticketId': patch.ticketId,
        'serviceId': patch.serviceId,
        'prodType': patch.prodType,
        'steps': stageIds,
      });
      onSuccess();
    } catch (error) {
      onError('$error');
    }
  }

  Future<_WorkflowCommentResult?> _commentSheet(
    BuildContext context, {
    required String title,
    bool askAmount = false,
  }) async {
    final comment = TextEditingController();
    final amount = TextEditingController();
    final ksts = TextEditingController();
    final result = await showModalBottomSheet<_WorkflowCommentResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            bottom: MediaQuery.viewInsetsOf(ctx).bottom + 16.h,
            top: 8.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 12.h),
              FlowTextField(
                controller: comment,
                hint: 'تعليق',
                onChanged: (_) {},
              ),
              if (askAmount) ...[
                SizedBox(height: 8.h),
                FlowTextField(
                  controller: amount,
                  hint: 'المبلغ (اختياري)',
                  keyboardType: TextInputType.number,
                  onChanged: (_) {},
                ),
                SizedBox(height: 8.h),
                FlowTextField(
                  controller: ksts,
                  hint: 'عدد الأقساط (اختياري)',
                  keyboardType: TextInputType.number,
                  onChanged: (_) {},
                ),
              ],
              SizedBox(height: 12.h),
              FlowActionButton(
                label: 'تأكيد',
                enabled: true,
                onPressed: () {
                  Navigator.pop(
                    ctx,
                    _WorkflowCommentResult(
                      comment: comment.text.trim(),
                      amount: amount.text.trim().isEmpty
                          ? null
                          : num.tryParse(amount.text.trim()),
                      noOfKsts: ksts.text.trim().isEmpty
                          ? null
                          : num.tryParse(ksts.text.trim()),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
    comment.dispose();
    amount.dispose();
    ksts.dispose();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (_visibleIds.isEmpty) return const SizedBox.shrink();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openMenu(context),
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 12.r,
                offset: Offset(0, 3.h),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.iconBubble,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  color: AppColors.accent,
                  size: 22.r,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'إجراءات الطلب',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: AppFonts.dinNextArabic,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'اعتماد، رفض، تحويل…',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: AppFonts.dinNextArabic,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.fieldLabel,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_left, color: AppColors.accent, size: 24.r),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

class _WorkflowCommentResult {
  const _WorkflowCommentResult({
    required this.comment,
    this.amount,
    this.noOfKsts,
  });

  final String comment;
  final num? amount;
  final num? noOfKsts;
}
