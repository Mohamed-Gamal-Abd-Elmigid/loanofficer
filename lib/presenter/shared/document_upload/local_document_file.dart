import 'dart:typed_data';

import 'package:loanofficer/presenter/shared/document_upload/document_upload_formats.dart';

class LocalDocumentFile {
  const LocalDocumentFile({
    required this.fileName,
    required this.bytes,
  });

  final String fileName;
  final Uint8List bytes;

  bool get isPdf =>
      DocumentUploadFormats.isPdfFileName(fileName) ||
      DocumentUploadFormats.bytesLookLikePdf(bytes);

  bool get isImage =>
      !isPdf &&
      (DocumentUploadFormats.isImageFileName(fileName) ||
          DocumentUploadFormats.bytesLookLikeImage(bytes));
}
