import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/presenter/shared/document_upload/document_upload_formats.dart';

class DocumentFormatHint extends StatelessWidget {
  const DocumentFormatHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F3FC),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF3C92D6).withValues(alpha: 0.35)),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20.r, color: const Color(0xFF3C92D6)),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              DocumentUploadFormats.hintAr,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12.sp,
                height: 1.35,
                color: const Color(0xFF032F64),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
