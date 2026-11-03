import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/presenter/client_data/scene/client_data_scene.dart';
import 'package:loanofficer/presenter/establishment_data/scene/establishment_data_scene.dart';
import 'package:loanofficer/presenter/financing/widget/financing_kit.dart';
import 'package:loanofficer/presenter/guarantor_data/scene/guarantor_data_scene.dart';
import 'package:loanofficer/presenter/shared/document_upload/document_format_hint.dart';
import 'package:loanofficer/presenter/shared/document_upload/document_picker_flow.dart';
import 'package:loanofficer/presenter/shared/document_upload/document_preview_page.dart';
import 'package:loanofficer/presenter/shared/document_upload/local_document_file.dart';

import 'package:loanofficer/core/bases/base_state.dart';
import 'package:loanofficer/core/bases/states/base/base_state.dart';
import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/documents/bloc/documents_bloc.dart';
import 'package:loanofficer/presenter/documents/model/documents_model.dart';

class StoredFile {
  const StoredFile({
    required this.name,
    required this.date,
    required this.bytes,
  });

  final String name;
  final String date;
  final Uint8List bytes;

  LocalDocumentFile get asLocal =>
      LocalDocumentFile(fileName: name, bytes: bytes);
}

class DocumentsInfo {
  const DocumentsInfo(this.files);

  final Map<String, StoredFile> files;

  int get count => files.length;
}

class DocumentsScene extends StatefulWidget {
  const DocumentsScene({
    super.key,
    this.initial,
    this.client,
    this.establishment,
    this.guarantor,
  });

  final DocumentsInfo? initial;
  final ClientInfo? client;
  final EstablishmentInfo? establishment;
  final GuarantorInfo? guarantor;

  @override
  State<DocumentsScene> createState() => _DocumentsSceneState();
}

class _DocumentsSceneState
    extends BaseState<DocumentsScene, DocumentsBloc, DocumentsModel> {
  late final Map<String, StoredFile> _files;
  late final bool _review;
  final Set<String> _open = {};

  static const _sections = [
    _DocSection('client', 'مستندات العميل', '١', 'بطاقة الرقم القومي للعميل'),
    _DocSection('establishment', 'مستندات المنشأة', '٢', 'سجل المنشأة'),
    _DocSection(
      'guarantor',
      'مستندات الضامن الاول',
      '٣',
      'بطاقة الرقم القومي للضامن',
    ),
    _DocSection('financing', 'مستندات التمويل', '٤', 'مستند التمويل'),
    _DocSection(
      'iscore',
      'م. الاستعلام الائتماني (i-Score)',
      '٥',
      'نموذج الاستعلام الائتماني (i-Score)',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _review = widget.initial != null;
    _files = Map.of(widget.initial?.files ?? const {});
    if (!_review) _open.add('client');
  }

  bool get _canAdd =>
      _sections.every((section) => _files.containsKey(section.key));

  void _toggle(String key) => setState(() {
    if (_open.contains(key)) {
      _open.remove(key);
    } else {
      _open.add(key);
    }
  });

  Future<void> _pick(String key) async {
    final local = await DocumentPickerFlow.pickWithPreview(context);
    if (!mounted || local == null) return;
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    setState(() {
      _files[key] = StoredFile(
        name: local.fileName,
        date: '${now.year}-$month-$day',
        bytes: local.bytes,
      );
    });
  }

  Future<void> _view(String key) async {
    final file = _files[key];
    if (file == null) return;
    await DocumentPreviewPage.pushView(
      context,
      file.asLocal,
      showDownload: true,
      showDelete: true,
      onDelete: () async {
        if (mounted) setState(() => _files.remove(key));
      },
      onDownload: () async {
        await FilePicker.platform.saveFile(
          fileName: file.name,
          bytes: file.bytes,
        );
      },
    );
  }

  Future<void> _submit({required bool saved}) async {
    final info = DocumentsInfo(Map.of(_files));
    await showFlowSuccess(
      context,
      message: saved
          ? 'لقد تم الحفظ بنجاح'
          : 'لقد قمت باضافة المستندات اللازمة لطلب التمويل بنجاح',
      note: saved
          ? null
          : 'لقد قمت بإستكمال جميع البيانات اللازمة لانشاء طلب التمويل',
    );
    if (!mounted) return;
    Navigator.of(context).pop(info);
  }

  @override
  Widget buildWidget(
    BuildContext context,
    RenderDataState<DocumentsModel> state,
  ) {
    return FlowScaffold(
      pageTitle: 'تحميل المستندات',
      pageIcon: Icons.description_outlined,
      body: FlowBody(
        footer: _review
            ? FlowSaveButton(
                enabled: _canAdd,
                onPressed: () => _submit(saved: true),
              )
            : FlowActionButton(
                label: 'اضافة',
                enabled: _canAdd,
                onPressed: () => _submit(saved: false),
              ),
        children: [
          const DocumentFormatHint(),
          for (final section in _sections)
            FlowSection(
              title: section.title,
              step: section.step,
              expanded: _open.contains(section.key),
              onToggle: () => _toggle(section.key),
              child: Column(
                children: [
                  if (section.key == 'client' && widget.client != null) ...[
                    _solidRow('رقم البطاقة', widget.client!.nationalId),
                    SizedBox(height: 8.h),
                    _softRow('رقم العميل', widget.client!.clientNumber),
                    SizedBox(height: 8.h),
                    _softRow('الاسم بالكامل', widget.client!.fullName),
                    SizedBox(height: 12.h),
                  ],
                  if (section.key == 'establishment' &&
                      widget.establishment != null) ...[
                    _softRow('اسم المنشأة', widget.establishment!.name),
                    SizedBox(height: 8.h),
                    _softRow('رقم السجل', widget.establishment!.registerNumber),
                    SizedBox(height: 12.h),
                  ],
                  if (section.key == 'guarantor' &&
                      widget.guarantor != null) ...[
                    _solidRow('رقم البطاقة', widget.guarantor!.nationalId),
                    SizedBox(height: 8.h),
                    _softRow('الاسم بالكامل', widget.guarantor!.fullName),
                    SizedBox(height: 12.h),
                  ],
                  _UploadTile(
                    title: section.fileLabel,
                    file: _files[section.key],
                    onPick: () => _pick(section.key),
                    onPreview: _files.containsKey(section.key)
                        ? () => _view(section.key)
                        : null,
                    onRemove: () => setState(() => _files.remove(section.key)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _solidRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF3C92D6),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          Text(
            value,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Text(
            label,
            style: TextStyle(color: AppColors.white, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Widget _softRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F3FC),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: const Color(0xFF3C92D6),
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(color: const Color(0xFF3C92D6), fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  @override
  void listenToState(BuildContext context, BaseStates state) {}

  @override
  DocumentsBloc createBloc() => DocumentsBloc(DocumentsModel());
}

class _DocSection {
  const _DocSection(this.key, this.title, this.step, this.fileLabel);

  final String key;
  final String title;
  final String step;
  final String fileLabel;
}

class _UploadTile extends StatelessWidget {
  const _UploadTile({
    required this.title,
    required this.file,
    required this.onPick,
    required this.onPreview,
    required this.onRemove,
  });

  final String title;
  final StoredFile? file;
  final VoidCallback onPick;
  final VoidCallback? onPreview;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE4E8EE)),
      ),
      child: file == null ? _empty() : _filled(file!),
    );
  }

  Widget _empty() {
    return InkWell(
      onTap: onPick,
      child: Column(
        children: [
          Icon(
            Icons.file_upload_outlined,
            color: AppColors.success,
            size: 28.r,
          ),
          SizedBox(height: 6.h),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: '* ',
                  style: TextStyle(color: Color(0xFFE14B4B)),
                ),
                TextSpan(text: title),
              ],
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF2C2C2C),
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'اختر الملف ثم راجعه قبل الحفظ',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 11.sp),
          ),
        ],
      ),
    );
  }

  Widget _filled(StoredFile file) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Expanded(
              child: Text(
                file.name,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700),
              ),
            ),
            Icon(Icons.check_circle, color: AppColors.success, size: 22.r),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (onPreview != null)
              Expanded(
                child: FlowActionButton(
                  label: 'معاينة المستند',
                  enabled: true,
                  onPressed: onPreview!,
                ),
              ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: onPick,
              icon: const Icon(Icons.swap_horiz, size: 18),
              label: const Text('استبدال'),
            ),
            TextButton.icon(
              onPressed: onRemove,
              icon: const Icon(
                Icons.delete_outline,
                size: 18,
                color: Color(0xFFE14B4B),
              ),
              label: const Text(
                'حذف',
                style: TextStyle(color: Color(0xFFE14B4B)),
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          'تاريخ التحميل: ${file.date}',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: AppColors.success,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
