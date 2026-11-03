import 'dart:async';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/core/validation/fmc_validation.dart';

String formatFlowDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

DateTime _clampDate(DateTime value, DateTime min, DateTime max) {
  if (value.isBefore(min)) return min;
  if (value.isAfter(max)) return max;
  return value;
}

/// Bottom sheet date picker (Fusion `dd/MM/yyyy`). Default scroll position: **today**
/// unless [currentValue] / [initialDate] is set.
Future<String?> pickFlowDate(
  BuildContext context, {
  String? currentValue,
  DateTime? initialDate,
  DateTime? minDate,
  DateTime? maxDate,
  String title = 'اختر التاريخ',
}) async {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final min = minDate ?? DateTime(1950);
  final max = maxDate ?? DateTime(now.year + 20, 12, 31);

  final parsed = FmcValidation.fusionDate(currentValue?.trim());
  var initial = initialDate ?? parsed ?? today;
  initial = _clampDate(
    DateTime(initial.year, initial.month, initial.day),
    min,
    max,
  );

  final completer = Completer<DateTime?>();
  final preview = ValueNotifier<DateTime>(initial);
  var selectedDate = initial;
  late BottomPicker picker;

  final viewHeight = MediaQuery.sizeOf(context).height;
  // Header + actions need ~220px; wheels need at least ~216px (Cupertino default).
  final sheetHeight = (viewHeight * 0.58).clamp(400.0, viewHeight * 0.85);

  void dismiss([DateTime? result]) {
    if (!completer.isCompleted) completer.complete(result);
    picker.dismiss();
  }

  picker = BottomPicker.date(
    dismissable: true,
    useSafeArea: true,
    initialDateTime: initial,
    minDateTime: min,
    maxDateTime: max,
    dateOrder: DatePickerDateOrder.dmy,
    layoutOrientation: TextDirection.rtl,
    backgroundColor: AppColors.white,
    height: sheetHeight,
    itemExtent: 38,
    pickerThemeData: CupertinoTextThemeData(
      dateTimePickerTextStyle: TextStyle(
        fontFamily: AppFonts.dinNextArabic,
        fontSize: 20.sp,
        color: AppColors.navy,
        fontWeight: FontWeight.w700,
      ),
    ),
    pickerTextStyle: TextStyle(
      fontFamily: AppFonts.dinNextArabic,
      fontSize: 20.sp,
      color: AppColors.navy,
      fontWeight: FontWeight.w700,
    ),
    onChange: (value) {
      if (value is! DateTime) return;
      selectedDate = DateTime(value.year, value.month, value.day);
      preview.value = selectedDate;
    },
    headerBuilder: (ctx) => _FlowDatePickerHeader(
      title: title,
      preview: preview,
      todayLabel: formatFlowDate(today),
      onClose: () => dismiss(null),
    ),
    buttonBuilder: (p, ctx) => _FlowDatePickerActions(
      onCancel: () => dismiss(null),
      onConfirm: () {
        final fromPicker = p.currentValue;
        if (fromPicker is DateTime) {
          selectedDate = DateTime(
            fromPicker.year,
            fromPicker.month,
            fromPicker.day,
          );
        }
        dismiss(selectedDate);
      },
    ),
    onDismiss: (_) {
      if (!completer.isCompleted) completer.complete(null);
    },
  );

  final sheetContext =
      Navigator.of(context, rootNavigator: true).overlay?.context ?? context;
  picker.show(sheetContext);
  final picked = await completer.future;
  preview.dispose();
  if (picked == null) return null;
  return formatFlowDate(picked);
}

class _FlowDatePickerHeader extends StatelessWidget {
  const _FlowDatePickerHeader({
    required this.title,
    required this.preview,
    required this.todayLabel,
    required this.onClose,
  });

  final String title;
  final ValueNotifier<DateTime> preview;
  final String todayLabel;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 8.h),
        Center(
          child: Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.borderSoft,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          textDirection: TextDirection.ltr,
          children: [
            IconButton(
              onPressed: onClose,
              icon: Icon(Icons.close_rounded, color: AppColors.fieldLabel, size: 22.r),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: AppFonts.dinNextArabic,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        ValueListenableBuilder<DateTime>(
          valueListenable: preview,
          builder: (context, date, _) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: AppColors.iconBubble,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.calendar_today_rounded,
                      color: AppColors.accent,
                      size: 20.r,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'التاريخ المحدد',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: AppFonts.dinNextArabic,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.fieldLabel,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          formatFlowDate(date),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: AppFonts.dinNextArabic,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'اليوم\n$todayLabel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.dinNextArabic,
                      fontSize: 11.sp,
                      height: 1.25,
                      fontWeight: FontWeight.w600,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 8.h),
        Divider(height: 1.h, thickness: 1, color: AppColors.line),
        SizedBox(height: 4.h),
      ],
    );
  }
}

class _FlowDatePickerActions extends StatelessWidget {
  const _FlowDatePickerActions({
    required this.onCancel,
    required this.onConfirm,
  });

  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.line, width: 1)),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: SizedBox(
              height: 52.h,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.navy,
                  side: BorderSide(color: AppColors.cardBorder, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'إلغاء',
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    fontWeight: FontWeight.w800,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: SizedBox(
              height: 52.h,
              child: FilledButton(
                onPressed: onConfirm,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'تأكيد',
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    fontWeight: FontWeight.w800,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
