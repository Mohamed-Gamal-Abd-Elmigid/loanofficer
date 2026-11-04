import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/personal_fund_api.dart';
import 'package:loanofficer/core/models/fund_workflow_authority.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/presenter/fund_track/model/fund_document_attachment.dart';
import 'package:loanofficer/presenter/fund_track/model/personal_fund_documents_bundle.dart';
import 'package:loanofficer/presenter/fund_track/widgets/personal_fund_shared_widgets.dart';
import 'package:loanofficer/presenter/fund_track/widgets/personal_fund_tab_chrome.dart'
    show
        PersonalFundEmptyState,
        PersonalFundTabPage,
        personalFundBrandGradient,
        personalFundScrollableEmpty,
        personalFundTabAccent,
        personalFundTabIcon;
import 'package:loanofficer/presenter/shared/document_upload/document_format_hint.dart';
import 'package:loanofficer/presenter/shared/document_upload/document_upload_formats.dart';
import 'package:loanofficer/presenter/shared/document_upload/document_picker_flow.dart';
import 'package:loanofficer/presenter/shared/document_upload/document_preview_page.dart';
import 'package:loanofficer/presenter/shared/document_upload/fusion_document_upload.dart';
import 'package:loanofficer/presenter/shared/document_upload/local_document_file.dart';

class PersonalFundDocumentsTab extends StatefulWidget {
  const PersonalFundDocumentsTab({
    super.key,
    required this.bundle,
    required this.authority,
    required this.api,
    required this.idno,
    required this.serviceId,
    required this.ticketId,
    required this.orgId,
    required this.loanType,
    required this.prodType,
    required this.stepId,
    required this.refusedFlow,
    required this.onReload,
    this.loading = false,
  });

  final PersonalFundDocumentsBundle bundle;
  final FundWorkflowAuthority authority;
  final PersonalFundApi api;
  final String idno;
  final String serviceId;
  final String ticketId;
  final String orgId;
  final String loanType;
  final String prodType;
  final String stepId;
  final bool refusedFlow;
  final bool loading;
  final Future<void> Function() onReload;

  @override
  State<PersonalFundDocumentsTab> createState() =>
      _PersonalFundDocumentsTabState();
}

class _PersonalFundDocumentsTabState extends State<PersonalFundDocumentsTab> {
  final _openSections = <String>{'customers'};

  bool get _canEditTab => widget.authority.tabEditable('RT_DOCS');

  bool _docUploadEnabled(Map<String, dynamic> doc) {
    if (widget.refusedFlow) {
      return '${doc['docEnabled'] ?? 'N'}'.toUpperCase() == 'Y';
    }
    if (!_canEditTab) return false;
    if ('${doc['docEnabled'] ?? 'Y'}'.toUpperCase() == 'N') return false;
    return widget.authority.controlEditable('RT_DOCS', 'fundingDocs');
  }

  Map<String, dynamic> _downloadPayload(Map<String, dynamic> doc) {
    final storage = FundDocumentAttachment.storagePath(doc);
    return {
      if (storage != null) 'path': storage,
      'docId': doc['docId'],
      'docType': doc['docType'],
      'serviceId': widget.serviceId,
      'loanType': widget.loanType,
      'prodType': widget.prodType,
      'seq': widget.stepId,
      'grantorIdno': FundDocumentAttachment.grantorIdnoForDownload(doc),
    };
  }

  Future<void> _upload(Map<String, dynamic> doc) async {
    final local = await DocumentPickerFlow.pickWithPreview(
      context,
      previewTitle: '${doc['docNameAr'] ?? 'معاينة المستند'}',
    );
    if (local == null) return;
    try {
      final prepared = await FusionDocumentUpload.prepare(local);
      await widget.api.uploadDocument(
        docId: int.parse('${doc['docId']}'),
        fileBase64: prepared.fileBase64,
        fileName: prepared.fileNameNoExtension,
        fileContentType: FusionDocumentUploadPayload.contentType,
        idno: '${doc['id_number'] ?? widget.idno}',
        serviceId: widget.serviceId,
        ticketId: widget.ticketId,
        orgId: widget.orgId.isEmpty ? null : widget.orgId,
      );
      _toast('تم حفظ المستند');
      await widget.onReload();
    } on FusionDocumentUploadException catch (error) {
      _toast(error.message);
    } catch (error) {
      _toast(apiErrorMessage(error));
    }
  }

  Future<LocalDocumentFile?> _fetchDocumentBytes(Map<String, dynamic> doc) async {
    final bytes = await widget.api.downloadDocumentBytes(_downloadPayload(doc));
    if (bytes.isEmpty) {
      throw AuthApiException('الملف فارغ');
    }
    if (!DocumentUploadFormats.bytesLookLikePdf(bytes) &&
        !DocumentUploadFormats.bytesLookLikeImage(bytes)) {
      throw AuthApiException('تعذر قراءة الملف');
    }
    var name =
        '${doc['fileName'] ?? doc['docNameAr'] ?? doc['docId'] ?? 'document'}';
    final storage = FundDocumentAttachment.storagePath(doc);
    if ((name == 'document' || !name.contains('.')) && storage != null) {
      final fromPath = storage.split('/').last;
      if (fromPath.isNotEmpty) name = fromPath;
    }
    if (!name.contains('.')) name = '$name.pdf';
    return LocalDocumentFile(fileName: name, bytes: bytes);
  }

  Future<void> _openAttachedDocument(Map<String, dynamic> doc) async {
    try {
      final local = await _fetchDocumentBytes(doc);
      if (!mounted) return;
      if (local == null) {
        _toast('لا يوجد ملف للعرض');
        return;
      }
      await DocumentPreviewPage.pushView(
        context,
        local,
        title: '${doc['docNameAr'] ?? 'معاينة المستند'}',
        showDownload: true,
        showDelete: _docUploadEnabled(doc),
        onDelete: () => _delete(doc),
        onDownload: () => _saveToDevice(local),
      );
    } catch (error) {
      _toast(apiErrorMessage(error));
    }
  }

  Future<void> _saveToDevice(LocalDocumentFile local) async {
    try {
      final path = await FilePicker.platform.saveFile(
        fileName: local.fileName,
        bytes: local.bytes,
      );
      if (path == null) return;
      _toast('تم حفظ الملف على الجهاز');
    } catch (error) {
      _toast(documentPreviewErrorMessage(error));
    }
  }

  Future<void> _delete(Map<String, dynamic> doc) async {
    final storage = FundDocumentAttachment.storagePath(doc);
    await widget.api.deleteDocument({
      'custno': doc['custno'],
      'docId': doc['docId'],
      'docPath': storage ?? doc['docPath'],
      'docType': doc['docType'],
      'orgId': widget.orgId.isEmpty ? null : widget.orgId,
      'idNo': doc['id_number'] ?? widget.idno,
      'serviceId': widget.serviceId,
    });
    _toast('تم حذف المستند');
    await widget.onReload();
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.authority.documentsTab) {
      return personalFundScrollableEmpty(
        storageKey: 'personal-fund-tab-docs-empty',
        child: PersonalFundEmptyState(
          icon: personalFundTabIcon('docs'),
          message: 'المستندات غير متاحة في هذه المرحلة',
          accent: personalFundTabAccent('docs'),
        ),
      );
    }
    if (widget.loading) {
      return personalFundScrollableEmpty(
        storageKey: 'personal-fund-tab-docs-loading',
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }
    if (widget.bundle.isEmpty) {
      return personalFundScrollableEmpty(
        storageKey: 'personal-fund-tab-docs-none',
        child: PersonalFundEmptyState(
          icon: Icons.folder_off_outlined,
          message: 'لا مستندات لهذه المرحلة',
          accent: personalFundTabAccent('docs'),
        ),
      );
    }
    return PersonalFundTabPage(
      tabId: 'docs',
      title: 'المستندات',
      children: [
        const DocumentFormatHint(),
        if (widget.refusedFlow)
          personalFundReadonlyBanner(
            'طلب مرفوض — يمكن تعديل المستندات المطلوبة فقط',
          )
        else if (!_canEditTab)
          personalFundReadonlyBanner('عرض المستندات فقط'),
        for (final section in PersonalFundDocumentsBundle.sections)
          _sectionPanel(section.key, section.title),
      ],
    );
  }

  Widget _sectionPanel(String key, String title) {
    final docs = widget.bundle.section(key);
    final expanded = _openSections.contains(key);
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: AppColors.white,
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
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            InkWell(
              onTap: () => setState(() {
                if (expanded) {
                  _openSections.remove(key);
                } else {
                  _openSections.add(key);
                }
              }),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
                decoration: BoxDecoration(
                  gradient: expanded
                      ? personalFundBrandGradient
                      : null,
                  color: expanded ? null : AppColors.card,
                ),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Container(
                      width: 36.r,
                      height: 36.r,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: expanded
                            ? AppColors.white.withValues(alpha: 0.2)
                            : AppColors.iconBubble,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.folder_outlined,
                        size: 20.r,
                        color: expanded
                            ? AppColors.white
                            : personalFundTabAccent('docs'),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: expanded
                              ? AppColors.white
                              : AppColors.primary,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: expanded
                            ? AppColors.white.withValues(alpha: 0.2)
                            : AppColors.iconBubble,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        '${docs.length}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: expanded
                              ? AppColors.white
                              : personalFundTabAccent('docs'),
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: expanded ? AppColors.white : AppColors.accent,
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: docs.isEmpty
                  ? Padding(
                      padding: EdgeInsets.all(14.w),
                      child: Text(
                        'لا مستندات في هذا القسم',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.muted,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        for (final doc in docs) _docTile(doc),
                      ],
                    ),
              crossFadeState: expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 280),
            ),
          ],
        ),
      ),
    );
  }

  Widget _docTile(Map<String, dynamic> doc) {
    final title = '${doc['docNameAr'] ?? doc['docNameEn'] ?? doc['docId']}';
    final canUpload = _docUploadEnabled(doc);
    final hasFile = FundDocumentAttachment.hasFile(doc);
    final status = _status(doc, hasFile);
    final statusBg = hasFile
        ? AppColors.iconBubble
        : canUpload
            ? AppColors.card
            : AppColors.card;

    return PersonalFundDocumentCard(
      title: title,
      statusColor: statusBg,
      lines: [
        PersonalFundLine(
          'الحالة',
          status,
          valueColor: hasFile ? AppColors.accent : AppColors.primary,
        ),
        if (hasFile && '${doc['uploadDate'] ?? ''}'.isNotEmpty)
          PersonalFundLine('تاريخ الرفع', '${doc['uploadDate']}'),
        if ('${doc['docType'] ?? ''}'.isNotEmpty)
          PersonalFundLine('نوع المستند', '${doc['docType']}'),
      ],
      actions: _docActions(doc, hasFile: hasFile, canUpload: canUpload),
    );
  }

  Widget _docActions(
    Map<String, dynamic> doc, {
    required bool hasFile,
    required bool canUpload,
  }) {
    if (hasFile) {
      return Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: PersonalFundCompactPrimaryButton(
              label: 'معاينة المستند',
              icon: Icons.visibility_outlined,
              onPressed: () => _openAttachedDocument(doc),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: PersonalFundOutlineButton(
              label: 'استبدال المستند',
              icon: Icons.swap_horiz,
              enabled: canUpload,
              onPressed: canUpload ? () => _upload(doc) : null,
            ),
          ),
        ],
      );
    }
    if (canUpload) {
      return PersonalFundCompactPrimaryButton(
        label: 'رفع مستند',
        icon: Icons.upload_file_outlined,
        onPressed: () => _upload(doc),
      );
    }
    return Text(
      'لا يوجد مرفق',
      textAlign: TextAlign.right,
      style: TextStyle(fontSize: 12.sp, color: const Color(0xFF9AA3AE)),
    );
  }

  String _status(Map<String, dynamic> doc, bool hasFile) {
    if ('${doc['docEnabled'] ?? 'Y'}'.toUpperCase() == 'N') {
      return 'غير متاح';
    }
    return hasFile ? 'مرفق' : 'غير مرفق — يلزم الرفع';
  }
}
