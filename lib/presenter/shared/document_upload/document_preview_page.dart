import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';
import 'package:loanofficer/presenter/shared/document_upload/document_upload_formats.dart';
import 'package:loanofficer/presenter/shared/document_upload/local_document_file.dart';
import 'package:pdfx/pdfx.dart';

/// Preview before upload save, or view an existing attachment.
class DocumentPreviewPage extends StatefulWidget {
  const DocumentPreviewPage({
    super.key,
    required this.document,
    this.title = 'معاينة المستند',
    this.confirmLabel = 'حفظ المستند',
    this.showSave = true,
    this.showDownload = false,
    this.showDelete = false,
    this.onDelete,
    this.onDownload,
  });

  final LocalDocumentFile document;
  final String title;
  final String confirmLabel;
  final bool showSave;
  final bool showDownload;
  final bool showDelete;
  final Future<void> Function()? onDelete;
  final Future<void> Function()? onDownload;

  static Future<bool?> pushConfirm(
    BuildContext context,
    LocalDocumentFile document, {
    String? title,
  }) {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => DocumentPreviewPage(
          document: document,
          title: title ?? 'معاينة قبل الرفع',
          showSave: true,
          showDelete: false,
        ),
      ),
    );
  }

  static Future<void> pushView(
    BuildContext context,
    LocalDocumentFile document, {
    String? title,
    bool showDownload = true,
    bool showDelete = false,
    Future<void> Function()? onDelete,
    Future<void> Function()? onDownload,
  }) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => DocumentPreviewPage(
          document: document,
          title: title ?? 'عرض المستند',
          showSave: false,
          showDownload: showDownload,
          showDelete: showDelete,
          onDelete: onDelete,
          onDownload: onDownload,
        ),
      ),
    );
  }

  @override
  State<DocumentPreviewPage> createState() => _DocumentPreviewPageState();
}

class _DocumentPreviewPageState extends State<DocumentPreviewPage> {
  PdfControllerPinch? _pdfController;
  String? _pdfLoadError;
  bool _deleting = false;
  bool _downloading = false;

  PdfViewPinchBuilders<DefaultBuilderOptions> get _pdfViewBuilders {
    return PdfViewPinchBuilders<DefaultBuilderOptions>(
      options: const DefaultBuilderOptions(),
      documentLoaderBuilder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      pageLoaderBuilder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      errorBuilder: (_, error) => Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Text(
            'تعذر فتح الملف.\n$error',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, color: AppColors.muted),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.document.isPdf) {
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openData(widget.document.bytes),
      );
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  Future<void> _handleDownload() async {
    final onDownload = widget.onDownload;
    if (onDownload == null) return;
    setState(() => _downloading = true);
    try {
      await onDownload();
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  Future<void> _handleDelete() async {
    final onDelete = widget.onDelete;
    if (onDelete == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف المستند'),
        content: const Text('هل تريد حذف هذا المستند؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    setState(() => _deleting = true);
    try {
      await onDelete();
      if (!mounted) return;
      Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlowScaffold(
      pageTitle: widget.title,
      pageIcon: Icons.picture_as_pdf_outlined,
      onBack: () => Navigator.of(context).pop(widget.showSave ? false : null),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _formatBanner(),
          Expanded(child: _previewBody()),
          if (widget.showSave || widget.showDelete || widget.showDownload) _footer(),
        ],
      ),
    );
  }

  Widget _formatBanner() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFFFD699)),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Icon(Icons.info_outline, size: 20.r, color: const Color(0xFF9A3412)),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              DocumentUploadFormats.hintAr,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 11.sp, color: const Color(0xFF9A3412)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _previewBody() {
    final doc = widget.document;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            doc.fileName,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF032F64),
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE4E9F0)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: _buildPreview(doc),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(LocalDocumentFile doc) {
    if (doc.isImage) {
      return InteractiveViewer(
        minScale: 0.5,
        maxScale: 4,
        child: Center(
          child: Image.memory(
            doc.bytes,
            fit: BoxFit.contain,
            gaplessPlayback: true,
            errorBuilder: (_, __, ___) => Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                'تعذر عرض الصورة',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.sp, color: AppColors.muted),
              ),
            ),
          ),
        ),
      );
    }
    if (doc.isPdf && _pdfController != null) {
      if (_pdfLoadError != null) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              _pdfLoadError!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: AppColors.muted),
            ),
          ),
        );
      }
      return PdfViewPinch(
        controller: _pdfController!,
        scrollDirection: Axis.vertical,
        builders: _pdfViewBuilders,
        minScale: 1,
        maxScale: 5,
        onDocumentError: (error) {
          if (!mounted) return;
          final msg = documentPreviewErrorMessage(error);
          setState(() => _pdfLoadError = msg);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(msg)));
        },
      );
    }
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Text(
          'تعذر عرض هذا النوع من الملفات. الصيغ المدعومة للمعاينة: PDF وصور.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13.sp, color: AppColors.muted),
        ),
      ),
    );
  }

  Widget _footer() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.showDelete && widget.onDelete != null) ...[
            OutlinedButton.icon(
              onPressed: _deleting ? null : _handleDelete,
              icon: _deleting
                  ? SizedBox(
                      width: 18.r,
                      height: 18.r,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.delete_outline, color: Color(0xFFE14B4B)),
              label: Text(
                'حذف المستند',
                style: TextStyle(color: const Color(0xFFE14B4B), fontSize: 14.sp),
              ),
            ),
            SizedBox(height: 8.h),
          ],
          if (widget.showDownload && widget.onDownload != null)
            FlowActionButton(
              label: 'تحميل على الجهاز',
              enabled: !_downloading,
              onPressed: _handleDownload,
            ),
          if (widget.showSave) ...[
            if (widget.showDownload) SizedBox(height: 8.h),
            FlowActionButton(
              label: widget.confirmLabel,
              enabled: true,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ],
      ),
    );
  }
}
