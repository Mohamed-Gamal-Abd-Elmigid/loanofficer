import 'dart:typed_data';

/// Fusion document upload rules (personal fund + new request flows).
class DocumentUploadFormats {
  DocumentUploadFormats._();

  static const allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png'];

  static const hintAr =
      'ارفع PDF أو صورة (JPG/PNG) — تُحوَّل الصور إلى PDF قبل الإرسال كما في نظام Fusion. '
      'يفضّل PDF بدون طبقات JavaScript.';

  /// Fusion `wf/documents` (personal fund) — web accepts PDF files only at pick time;
  /// we also allow images and convert client-side.
  static const wfDocumentsHintAr = hintAr;

  static bool isAllowedExtension(String fileName) {
    final ext = extensionOf(fileName);
    return allowedExtensions.contains(ext);
  }

  static String extensionOf(String fileName) {
    final parts = fileName.split('.');
    if (parts.length < 2) return '';
    return parts.last.toLowerCase();
  }

  static bool isImageFileName(String fileName) {
    final ext = extensionOf(fileName);
    return ext == 'jpg' || ext == 'jpeg' || ext == 'png';
  }

  static bool isPdfFileName(String fileName) {
    return extensionOf(fileName) == 'pdf';
  }

  /// `%PDF` header (Fusion download returns base64 PDF in `result`).
  static bool bytesLookLikePdf(Uint8List bytes) {
    if (bytes.length < 4) return false;
    return bytes[0] == 0x25 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x44 &&
        bytes[3] == 0x46;
  }

  static bool bytesLookLikePng(Uint8List bytes) {
    if (bytes.length < 8) return false;
    return bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47;
  }

  static bool bytesLookLikeJpeg(Uint8List bytes) {
    if (bytes.length < 3) return false;
    return bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF;
  }

  static bool bytesLookLikeImage(Uint8List bytes) {
    return bytesLookLikePng(bytes) || bytesLookLikeJpeg(bytes);
  }
}
