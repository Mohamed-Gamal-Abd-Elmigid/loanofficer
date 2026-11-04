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

  /// Same intent as Fusion web upload guard, but ignores compressed `stream`
  /// bodies — raw binary often contains `/JS`, `/AA`, `Launch`, etc. by chance
  /// and falsely rejected normal phone/scanner PDFs.
  static void _rejectSuspiciousPdf(Uint8List pdfBytes) {
    final content = latin1.decode(pdfBytes);
    final imageOnly = content.contains('/Subtype /Image') ||
        content.contains('Subtype/Image');
    if (imageOnly) return;

    final structure = _pdfStructureText(content);
    // PDF name tokens only (not bare "Launch" / short ASCII in binary).
    final suspicious = RegExp(
      r'/JavaScript(?![A-Za-z0-9])|'
      r'/JS(?![A-Za-z0-9])|'
      r'/AA(?![A-Za-z0-9])|'
      r'/OpenAction(?![A-Za-z0-9])|'
      r'/Launch(?![A-Za-z0-9])|'
      r'<script',
      caseSensitive: false,
    );
    if (suspicious.hasMatch(structure)) {
      throw FusionDocumentUploadException(
        '❌ الملف مرفوض — يرجى رفع ملف PDF آخر (بدون محتوى تفاعلي).',
      );
    }
  }

  /// Drop `stream`…`endstream` payloads so keyword checks run on dictionaries
  /// / catalog only (where interactive actions are declared).
  static String _pdfStructureText(String content) {
    return content.replaceAll(
      RegExp(r'stream\r?\n[\s\S]*?endstream', multiLine: true),
      'stream\nendstream',
    );
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
