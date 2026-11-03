import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:loanofficer/presenter/shared/document_upload/document_preview_page.dart';
import 'package:loanofficer/presenter/shared/document_upload/document_upload_formats.dart';
import 'package:loanofficer/presenter/shared/document_upload/local_document_file.dart';

/// Pick → preview → confirm (save) flow used across the app.
class DocumentPickerFlow {
  DocumentPickerFlow._();

  static Future<LocalDocumentFile?> pickWithPreview(
    BuildContext context, {
    String previewTitle = 'معاينة قبل الرفع',
  }) async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: DocumentUploadFormats.allowedExtensions,
      withData: true,
    );
    if (picked == null || picked.files.isEmpty) return null;
    final file = picked.files.single;
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) {
      if (context.mounted) _toast(context, 'تعذر قراءة الملف');
      return null;
    }
    if (!DocumentUploadFormats.isAllowedExtension(file.name)) {
      if (context.mounted) _toast(context, DocumentUploadFormats.hintAr);
      return null;
    }
    final local = LocalDocumentFile(
      fileName: file.name,
      bytes: bytes,
    );
    if (!context.mounted) return null;
    final confirmed = await DocumentPreviewPage.pushConfirm(
      context,
      local,
      title: previewTitle,
    );
    return confirmed == true ? local : null;
  }

  static void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
