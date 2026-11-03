import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/theme/app_colors.dart';

/// Dashboard strip: تاريخ اليومية، الاسم، الفرع (and role when present).
class OfficerIdentityBar extends StatelessWidget {
  const OfficerIdentityBar({
    super.key,
    required this.date,
    required this.name,
    required this.branch,
    required this.role,
  });

  final String date;
  final String name;
  final String branch;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (date.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'تاريخ اليومية',
                  style: TextStyle(
                    color: AppColors.privilegeLabel,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(color: AppColors.text, fontSize: 12.sp),
                ),
              ],
            ),
          if (role.isNotEmpty) ...[
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.dropdownBorder),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.dropdownHint,
                    size: 18.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    role,
                    style: TextStyle(color: AppColors.text, fontSize: 13.sp),
                  ),
                ],
              ),
            ),
          ],
          if (name.isNotEmpty || branch.isNotEmpty)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (name.isNotEmpty)
                    Text(
                      name,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if (branch.isNotEmpty)
                    Text(
                      branch,
                      textAlign: TextAlign.right,
                      style: TextStyle(color: AppColors.muted, fontSize: 12.sp),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
