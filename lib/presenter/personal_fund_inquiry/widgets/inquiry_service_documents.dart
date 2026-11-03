import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fund_track_api.dart';
import 'package:loanofficer/core/api/service_query_api.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';
import 'package:loanofficer/presenter/shared/document_upload/document_preview_page.dart';
import 'package:loanofficer/presenter/shared/document_upload/document_upload_formats.dart';
import 'package:loanofficer/presenter/shared/document_upload/local_document_file.dart';

/// FMC `GET query/docs/service?serviceId=` — **المستندات** (FundDocumentModal parity).
class InquiryDocumentsScene extends StatefulWidget {
  const InquiryDocumentsScene({super.key, required this.row});

  final FundTrackRow row;

  static void open(BuildContext context, FundTrackRow row) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => InquiryDocumentsScene(row: row),
      ),
    );
  }

  @override
  State<InquiryDocumentsScene> createState() => _InquiryDocumentsSceneState();
}

class _InquiryDocumentsSceneState extends State<InquiryDocumentsScene> {
  final _api = ServiceQueryApi();
  List<Map<String, dynamic>> _rows = [];
  String? _error;
  bool _loading = true;
  String? _loadingSeq;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final rows = await _api.serviceDocuments(
        serviceId: widget.row.serviceId,
      );
      if (!mounted) return;
      setState(() {
        _rows = rows;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = apiErrorMessage(e);
        _loading = false;
      });
    }
  }

  Future<LocalDocumentFile> _fetchDocument(Map<String, dynamic> doc) async {
    final seq = '${doc['seq'] ?? ''}'.trim();
    if (seq.isEmpty) {
      throw AuthApiException('لا يوجد ملف مرفق');
    }
    final bytes = await _api.downloadServiceDocument(seq);
    if (bytes.isEmpty) {
      throw AuthApiException('الملف فارغ');
    }
    if (!DocumentUploadFormats.bytesLookLikePdf(bytes) &&
        !DocumentUploadFormats.bytesLookLikeImage(bytes)) {
      throw AuthApiException('تعذر قراءة الملف');
    }
    final parsed = InquiryServiceDocument.fromMap(doc);
    var name = parsed.fileName;
    if (!name.contains('.')) name = '$name.pdf';
    return LocalDocumentFile(fileName: name, bytes: bytes);
  }

  Future<void> _saveToDevice(LocalDocumentFile local) async {
    final path = await FilePicker.platform.saveFile(
      fileName: local.fileName,
      bytes: local.bytes,
    );
    if (path == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم حفظ الملف على الجهاز',
          style: TextStyle(fontFamily: AppFonts.dinNextArabic),
        ),
      ),
    );
  }

  Future<void> _openPreview(Map<String, dynamic> doc) async {
    final seq = '${doc['seq'] ?? ''}'.trim();
    if (seq.isEmpty) {
      _toast('لا يوجد ملف للعرض');
      return;
    }
    setState(() => _loadingSeq = seq);
    try {
      final local = await _fetchDocument(doc);
      if (!mounted) return;
      final parsed = InquiryServiceDocument.fromMap(doc);
      await DocumentPreviewPage.pushView(
        context,
        local,
        title: parsed.docName,
        showDownload: true,
        onDownload: () => _saveToDevice(local),
      );
    } catch (e) {
      if (!mounted) return;
      _toast(apiErrorMessage(e));
    } finally {
      if (mounted) setState(() => _loadingSeq = null);
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontFamily: AppFonts.dinNextArabic),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      pageTitle: 'المستندات',
      pageIcon: Icons.folder_open_outlined,
      onBack: () => Navigator.of(context).pop(),
      body: ColoredBox(
        color: AppColors.page,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: _loading
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: AppColors.accent),
                      SizedBox(height: 12.h),
                      Text(
                        'جاري تحميل المستندات...',
                        style: TextStyle(
                          fontFamily: AppFonts.dinNextArabic,
                          color: const Color(0xFF9AA3AE),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                )
              : _error != null
              ? _DocumentsError(message: _error!, onRetry: _load)
              : _rows.isEmpty
              ? Center(
                  child: Text(
                    'لا توجد مستندات',
                    style: TextStyle(
                      fontFamily: AppFonts.dinNextArabic,
                      fontSize: 14.sp,
                      color: const Color(0xFF9AA3AE),
                    ),
                  ),
                )
              : RefreshIndicator(
                  color: AppColors.accent,
                  onRefresh: _load,
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _rows.length + 1,
                    separatorBuilder: (_, index) =>
                        index == 0 ? SizedBox(height: 12.h) : SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _DocumentsSummaryBanner(count: _rows.length);
                      }
                      final doc = _rows[index - 1];
                      final view = InquiryServiceDocument.fromMap(doc);
                      return _InquiryDocumentCard(
                        view: view,
                        loading: _loadingSeq == view.seq,
                        onPreview: () => _openPreview(doc),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}

class InquiryServiceDocument {
  InquiryServiceDocument({
    required this.category,
    required this.docName,
    required this.refNo,
    required this.refName,
    required this.seq,
    required this.fileName,
  });

  final String category;
  final String docName;
  final String refNo;
  final String refName;
  final String seq;
  final String fileName;

  factory InquiryServiceDocument.fromMap(Map<String, dynamic> map) {
    final refNameRaw = _cell(
      map['custFullName'] ?? map['refName'] ?? map['custName'],
    );
    return InquiryServiceDocument(
      category: _cell(map['docTypeNameAr'] ?? map['docTypeNameEn']),
      docName: _cell(
        map['docDescrAr'] ?? map['docDescrEn'] ?? map['docTypeNameAr'],
      ),
      refNo: _cell(map['idno'] ?? map['refNo']),
      refName: refNameRaw == '—' ? '-----' : refNameRaw,
      seq: '${map['seq'] ?? ''}'.trim(),
      fileName: _cell(
        map['fileName'] ?? map['docDescrAr'] ?? map['docTypeNameAr'],
      ),
    );
  }

  static String _cell(Object? value) {
    final text = '$value'.trim();
    if (text.isEmpty || text == 'null') return '—';
    return text;
  }

  bool get hasFile => seq.isNotEmpty;
}

class _DocumentsSummaryBanner extends StatelessWidget {
  const _DocumentsSummaryBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.iconBubble,
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Icon(
              Icons.folder_copy_outlined,
              color: AppColors.accent,
              size: 22.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مستندات الطلب',
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF032F64),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '$count ${count == 1 ? 'مستند' : 'مستندات'}',
                  style: TextStyle(
                    fontFamily: AppFonts.dinNextArabic,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF9AA3AE),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InquiryDocumentCard extends StatelessWidget {
  const _InquiryDocumentCard({
    required this.view,
    required this.loading,
    required this.onPreview,
  });

  final InquiryServiceDocument view;
  final bool loading;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final enabled = view.hasFile && !loading;

    return Material(
      color: AppColors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(16.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled ? onPreview : null,
        child: Ink(
          decoration: BoxDecoration(
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
          child: Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44.r,
                      height: 44.r,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7F3FC),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.description_outlined,
                        color: AppColors.accent,
                        size: 24.r,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F7FA),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: const Color(0xFFE4E9F0),
                                ),
                              ),
                              child: Text(
                                view.category,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: AppFonts.dinNextArabic,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF3C4F73),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            view.docName,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: AppFonts.dinNextArabic,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF032F64),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFFE8EDF2)),
                  ),
                  child: Column(
                    children: [
                      _DocumentFieldRow(
                        label: 'الرقم المرجعي',
                        value: view.refNo,
                        icon: Icons.numbers_outlined,
                      ),
                      SizedBox(height: 10.h),
                      _DocumentFieldRow(
                        label: 'الإسم المرجعي',
                        value: view.refName,
                        icon: Icons.person_outline,
                      ),
                    ],
                  ),
                ),
                if (!view.hasFile) ...[
                  SizedBox(height: 10.h),
                  Text(
                    'لا يوجد ملف مرفق',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.dinNextArabic,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF9AA3AE),
                    ),
                  ),
                ],
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 42.h,
                        child: FilledButton.icon(
                          onPressed: enabled ? onPreview : null,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            disabledBackgroundColor: const Color(0xFFE8EDF2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          icon: loading
                              ? SizedBox(
                                  width: 18.r,
                                  height: 18.r,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(Icons.visibility_outlined, size: 20.r),
                          label: Text(
                            loading ? 'جاري الفتح...' : 'معاينة',
                            style: TextStyle(
                              fontFamily: AppFonts.dinNextArabic,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: SizedBox(
                        height: 42.h,
                        child: OutlinedButton.icon(
                          onPressed: enabled ? onPreview : null,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.accent,
                            side: BorderSide(
                              color: enabled
                                  ? AppColors.accent.withValues(alpha: 0.55)
                                  : const Color(0xFFE8EDF2),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          icon: Icon(Icons.download_outlined, size: 20.r),
                          label: Text(
                            'تحميل',
                            style: TextStyle(
                              fontFamily: AppFonts.dinNextArabic,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DocumentFieldRow extends StatelessWidget {
  const _DocumentFieldRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18.r, color: AppColors.accent),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: AppFonts.dinNextArabic,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF9AA3AE),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: AppFonts.dinNextArabic,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2C2C2C),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DocumentsError extends StatelessWidget {
  const _DocumentsError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: AppColors.primary, size: 36.r),
            SizedBox(height: 10.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.dinNextArabic,
                color: AppColors.primary,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 12.h),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: AppColors.accent),
              label: Text(
                'إعادة المحاولة',
                style: TextStyle(
                  fontFamily: AppFonts.dinNextArabic,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
