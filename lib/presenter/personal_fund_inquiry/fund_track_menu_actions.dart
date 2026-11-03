import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fund_track_api.dart';
import 'package:loanofficer/presenter/fund_track/scene/fund_track_detail_scene.dart';

/// Fusion `fund-track` row menu (`p-menu` / three dots).
class FundTrackMenuActions {
  FundTrackMenuActions(this.context, {FundTrackApi? api})
      : _api = api ?? FundTrackApi();

  final BuildContext context;
  final FundTrackApi _api;

  static const menuItems = <({String id, String label, IconData icon})>[
    (id: 'FUND-QUERY-DATA', label: 'اجراءات مراجعة الطلب', icon: Icons.fact_check_outlined),
    (id: 'FUND-MOVE-STEP', label: 'تحويل الطلب لمرحلة أخرى', icon: Icons.swap_horiz),
    (id: 'FUND-RESET', label: 'اعادة تهئية الطلب', icon: Icons.restart_alt),
    (id: 'LOAN-OFFICER_EDIT', label: 'تعديل مسؤول التمويل', icon: Icons.person_outline),
    (id: 'UPDATE-REVIEWER', label: 'تغيير مستخدم المراجعة', icon: Icons.manage_accounts_outlined),
    (id: 'UNFREEZED', label: 'الغاء تجميد الطلب', icon: Icons.ac_unit_outlined),
    (id: 'DELETE', label: 'حذف طلب تمويل', icon: Icons.delete_outline),
    (id: 'UPDATE_USER', label: 'تعديل مستخدم', icon: Icons.switch_account_outlined),
  ];

  Future<void> run(String actionId, FundTrackRow row, VoidCallback onRefresh) async {
    switch (actionId) {
      case 'FUND-QUERY-DATA':
        await _openQueryData(row);
      case 'FUND-MOVE-STEP':
        await _moveStep(row, onRefresh);
      case 'FUND-RESET':
        await _reset(row, onRefresh);
      case 'LOAN-OFFICER_EDIT':
        await _editLoanOfficer(row, onRefresh);
      case 'UPDATE-REVIEWER':
        await _updateReviewer(row, onRefresh);
      case 'UNFREEZED':
        await _unfreeze(row, onRefresh);
      case 'DELETE':
        await _delete(row, onRefresh);
      case 'UPDATE_USER':
        await _updateUser(row, onRefresh);
    }
  }

  Future<void> _openQueryData(FundTrackRow row) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => FundTrackDetailScene(serviceId: row.serviceId),
      ),
    );
  }

  Future<void> _moveStep(FundTrackRow row, VoidCallback onRefresh) async {
    FundTrackServiceDetail detail;
    try {
      detail = await _api.serviceWorkflowReviews(row.serviceId);
    } catch (error) {
      _toast(apiErrorMessage(error));
      return;
    }
    if (!context.mounted) return;
    if (detail.wfSteps.isEmpty) {
      _toast('لا توجد مراحل');
      return;
    }
    final comment = TextEditingController();
    String? stageId;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('تحويل الطلب إلي مرحلة معينة'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: stageId,
                    decoration: const InputDecoration(labelText: 'كود المرحلة'),
                    items: [
                      for (final s in detail.wfSteps)
                        DropdownMenuItem(
                          value: s.stageId,
                          child: Text(
                            s.stageNameAr.isEmpty ? s.stageId : s.stageNameAr,
                            textAlign: TextAlign.right,
                          ),
                        ),
                    ],
                    onChanged: (v) => setState(() => stageId = v),
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: comment,
                    decoration: const InputDecoration(labelText: 'التعليق'),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ')),
            ],
          );
        },
      ),
    );
    final commentText = comment.text.trim();
    comment.dispose();
    if (ok != true || stageId == null || stageId!.isEmpty) return;
    try {
      await _api.moveToStep({
        'amount': null,
        'comment': commentText,
        'noOfksts': null,
        'prodType': detail.prodType.isEmpty ? row.prodType : detail.prodType,
        'serviceId': row.serviceId,
        'stageId': stageId,
        'ticketId': detail.ticketId.isEmpty ? row.ticketId : detail.ticketId,
      });
      _toast('تم تحويل الطلب');
      onRefresh();
    } catch (error) {
      _toast(apiErrorMessage(error));
    }
  }

  Future<void> _reset(FundTrackRow row, VoidCallback onRefresh) async {
    final ok = await _confirm('اعادة تهئية الطلب', 'هل تريد إعادة تهيئة هذا الطلب؟');
    if (!ok) return;
    try {
      await _api.resetTicket(ticketId: row.ticketId);
      _toast('تمت إعادة التهيئة');
      onRefresh();
    } catch (error) {
      _toast(apiErrorMessage(error));
    }
  }

  Future<void> _editLoanOfficer(FundTrackRow row, VoidCallback onRefresh) async {
    List<BranchUser> officers;
    try {
      officers = await _api.loanOfficersByBranch(row.brcode);
    } catch (error) {
      _toast(apiErrorMessage(error));
      return;
    }
    if (!context.mounted) return;
    String? usrno;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('تعديل مسؤول التمويل'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('الحالي: ${row.loCodeName.isEmpty ? '—' : row.loCodeName}'),
                SizedBox(height: 12.h),
                DropdownButtonFormField<String>(
                  value: usrno,
                  decoration: const InputDecoration(labelText: 'مسؤول التمويل الجديد'),
                  items: [
                    for (final u in officers)
                      DropdownMenuItem(value: u.usrno, child: Text(u.label)),
                  ],
                  onChanged: (v) => setState(() => usrno = v),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ')),
            ],
          );
        },
      ),
    );
    if (ok != true || usrno == null) return;
    try {
      await _api.changeLoanOfficer(ticketId: row.ticketId, newUsrNo: usrno!);
      _toast('تم تحديث مسؤول التمويل');
      onRefresh();
    } catch (error) {
      _toast(apiErrorMessage(error));
    }
  }

  Future<void> _updateReviewer(FundTrackRow row, VoidCallback onRefresh) async {
    TicketReviewerInfo info;
    try {
      info = await _api.ticketReviewer(row.ticketId);
    } catch (error) {
      _toast(apiErrorMessage(error));
      return;
    }
    if (!context.mounted) return;
    String? newUsrNo;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('تغيير مستخدم المراجعة'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _readOnly('المراجع الحالي', info.currentUsrnoName),
                  _readOnly('مرحلة المراجعة', info.currentStageDescr),
                  _readOnly('الدور', info.currentRoleDescr),
                  SizedBox(height: 8.h),
                  DropdownButtonFormField<String>(
                    value: newUsrNo,
                    decoration: const InputDecoration(labelText: 'المراجع الجديد'),
                    items: [
                      for (final u in info.users)
                        DropdownMenuItem(value: u.usrno, child: Text(u.label)),
                    ],
                    onChanged: (v) => setState(() => newUsrNo = v),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ')),
            ],
          );
        },
      ),
    );
    if (ok != true || newUsrNo == null) return;
    try {
      await _api.changeTicketReviewer(
        ticketId: row.ticketId,
        newUsrNo: newUsrNo!,
      );
      _toast('تم تغيير المراجع');
      onRefresh();
    } catch (error) {
      _toast(apiErrorMessage(error));
    }
  }

  Future<void> _unfreeze(FundTrackRow row, VoidCallback onRefresh) async {
    final ok = await _confirm('الغاء تجميد الطلب', 'هل تريد إلغاء تجميد هذا الطلب؟');
    if (!ok) return;
    try {
      await _api.unfreezeRequest({
        'amount': null,
        'serviceId': row.serviceId,
        'prodType': row.prodType,
        'noOfksts': null,
        'ticketId': row.ticketId,
        'comment': null,
        'stageId': null,
      });
      _toast('تم إلغاء التجميد');
      onRefresh();
    } catch (error) {
      _toast(apiErrorMessage(error));
    }
  }

  Future<void> _delete(FundTrackRow row, VoidCallback onRefresh) async {
    final ok = await _confirm('حذف طلب تمويل', 'هل تريد حذف طلب التمويل؟');
    if (!ok) return;
    try {
      await _api.cancelWorkflowRequest(serviceId: row.serviceId);
      _toast('تم حذف الطلب');
      onRefresh();
    } catch (error) {
      _toast(apiErrorMessage(error));
    }
  }

  Future<void> _updateUser(FundTrackRow row, VoidCallback onRefresh) async {
    List<TicketUser> fromUsers;
    try {
      fromUsers = await _api.usersForTicket(row.ticketId);
    } catch (error) {
      _toast(apiErrorMessage(error));
      return;
    }
    if (!context.mounted) return;
    String? fromUsrNo;
    String? toUsrNo;
    List<BranchUser> toUsers = [];
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('تعديل مستخدم'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: fromUsrNo,
                    decoration: const InputDecoration(labelText: 'من مستخدم'),
                    items: [
                      for (final u in fromUsers)
                        DropdownMenuItem(value: u.usrno, child: Text(u.label)),
                    ],
                    onChanged: (v) async {
                      setState(() {
                        fromUsrNo = v;
                        toUsrNo = null;
                        toUsers = [];
                      });
                      if (v == null) return;
                      final match = fromUsers.firstWhere((e) => e.usrno == v);
                      try {
                        final list = await _api.usersByBranch(match.brcode);
                        if (ctx.mounted) {
                          setState(() => toUsers = list);
                        }
                      } catch (_) {}
                    },
                  ),
                  SizedBox(height: 8.h),
                  DropdownButtonFormField<String>(
                    value: toUsrNo,
                    decoration: const InputDecoration(labelText: 'الي مستخدم'),
                    items: [
                      for (final u in toUsers)
                        DropdownMenuItem(value: u.usrno, child: Text(u.label)),
                    ],
                    onChanged: (v) => setState(() => toUsrNo = v),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حفظ')),
            ],
          );
        },
      ),
    );
    if (ok != true || fromUsrNo == null || toUsrNo == null) return;
    try {
      await _api.changeWorkflowUser(
        ticketId: row.ticketId,
        fromUsrNo: fromUsrNo!,
        toUsrNo: toUsrNo!,
      );
      _toast('تم تعديل المستخدم');
      onRefresh();
    } catch (error) {
      _toast(apiErrorMessage(error));
    }
  }

  Widget _readOnly(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text('$label: ${value.isEmpty ? '—' : value}', textAlign: TextAlign.right),
    );
  }

  Future<bool> _confirm(String title, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('لا')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('نعم')),
        ],
      ),
    );
    return result == true;
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
