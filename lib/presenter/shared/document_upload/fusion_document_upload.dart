import 'dart:convert';
import 'dart:typed_data';

import 'package:loanofficer/presenter/shared/document_upload/local_document_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Payload shape for Fusion `POST wf/documents` (matches Angular upload).
class FusionDocumentUploadPayload {
  const FusionDocumentUploadPayload({
    required this.fileBase64,
    required this.fileNameNoExtension,
  });

  final String fileBase64;
  final String fileNameNoExtension;

  static const contentType = 'application/pdf';
}

class FusionDocumentUploadException implements Exception {
  FusionDocumentUploadException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Converts picks to PDF + web filename rules before calling the API.
class FusionDocumentUpload {
  FusionDocumentUpload._();

  static Future<FusionDocumentUploadPayload> prepare(
    LocalDocumentFile file,
  ) async {
    final Uint8List pdfBytes;
    if (file.isPdf) {
      pdfBytes = file.bytes;
      _rejectSuspiciousPdf(pdfBytes);
    } else if (file.isImage) {
      pdfBytes = await _imageToPdf(file);
    } else {
      throw FusionDocumentUploadException(
        'يرجى رفع ملف PDF أو صورة (JPG/PNG) — يتم تحويل الصور إلى PDF قبل الإرسال.',
      );
    }

    final baseName = _fileNameWithoutExtension(file.fileName);
    if (baseName.isEmpty) {
      throw FusionDocumentUploadException('اسم الملف غير صالح');
    }

    return FusionDocumentUploadPayload(
      fileBase64: base64Encode(pdfBytes),
      fileNameNoExtension: baseName,
    );
  }

  static String _fileNameWithoutExtension(String name) {
    final dot = name.lastIndexOf('.');
    if (dot <= 0) return name.trim();
    return name.substring(0, dot).trim();
  }

  /// Same rules as Fusion `FundPersonalDocumentsComponent` (binary PDF scan).
  static void _rejectSuspiciousPdf(Uint8List pdfBytes) {
    final content = latin1.decode(pdfBytes);
    final imageOnly = content.contains('/Subtype /Image') ||
        content.contains('Subtype/Image');
    if (imageOnly) return;

    const keywords = [
      '/JavaScript',
      '/JS',
      '/AA',
      '/OpenAction',
      'Launch',
      '<script',
    ];
    for (final keyword in keywords) {
      if (content.contains(keyword)) {
        throw FusionDocumentUploadException(
          '❌ الملف مرفوض — يرجى رفع ملف PDF آخر (بدون محتوى تفاعلي).',
        );
      }
    }
  }

  static Future<Uint8List> _imageToPdf(LocalDocumentFile file) async {
    final doc = pw.Document();
    final image = pw.MemoryImage(file.bytes);
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Center(
          child: pw.Image(image, fit: pw.BoxFit.contain),
        ),
      ),
    );
    return Uint8List.fromList(await doc.save());
  }
}
