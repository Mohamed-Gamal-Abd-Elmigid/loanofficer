/// Detects whether a row from `allDocs` already has an uploaded file (Fusion `docPath`).
class FundDocumentAttachment {
  FundDocumentAttachment._();

  static bool hasFile(Map<String, dynamic> doc) {
    for (final key in ['docPath', 'path', 'filePath']) {
      final v = doc[key];
      if (v != null && '$v'.trim().isNotEmpty) return true;
    }
    return false;
  }

  static String? storagePath(Map<String, dynamic> doc) {
    for (final key in ['docPath', 'path', 'filePath']) {
      final v = doc[key];
      if (v != null && '$v'.trim().isNotEmpty) return '$v'.trim();
    }
    return null;
  }

  static String grantorIdnoForDownload(Map<String, dynamic> doc) {
    final docType = '${doc['docType'] ?? ''}';
    final docId = '${doc['docId'] ?? ''}';
    final id = '${doc['id_number'] ?? ''}'.trim();
    if (docType == '2') return id;
    if (docId == '-1' && docType == '-1') return id;
    return '';
  }
}
