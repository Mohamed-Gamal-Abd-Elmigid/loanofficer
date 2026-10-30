import 'package:flutter/material.dart';
import 'package:loanofficer/core/api/admin_api.dart';
import 'package:loanofficer/core/api/auth_api.dart';
import 'package:loanofficer/core/components/app_button.dart';
import 'package:loanofficer/core/components/app_field_label.dart';
import 'package:loanofficer/core/components/app_logo_row.dart';
import 'package:loanofficer/core/components/app_text_field.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/core/validation/app_validators.dart';
import 'package:loanofficer/screens/forgot_password/password_rules.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key, required this.onSignedOut});

  final VoidCallback onSignedOut;

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final TextEditingController _employeeId = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _obscure = true;
  bool _busy = false;
  bool _loading = true;
  List<OfficerAccount> _officers = const [];

  bool get _canCreate {
    return _employeeId.text.trim().isNotEmpty &&
        _fullName.text.trim().isNotEmpty &&
        AppValidators.isTanmeyahEmail(_email.text) &&
        isStrongPassword(_password.text, _password.text);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _employeeId.dispose();
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final officers = await AdminApi().listOfficers();
      if (!mounted) return;
      setState(() {
        _officers = officers;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      showAuthError(context, error);
    }
  }

  Future<void> _create() async {
    setState(() => _busy = true);
    try {
      await AdminApi().createOfficer(
        employeeId: _employeeId.text,
        email: _email.text,
        fullName: _fullName.text,
        password: _password.text,
      );
      _employeeId.clear();
      _fullName.clear();
      _email.clear();
      _password.clear();
      if (!mounted) return;
      _showSuccess('تم إنشاء المستخدم بنجاح');
      await _load();
    } on AuthApiException catch (error) {
      if (!mounted) return;
      showAuthError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _edit(OfficerAccount officer) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _EditOfficerDialog(officer: officer),
    );
    if (saved != true || !mounted) return;
    _showSuccess('تم تحديث المستخدم بنجاح');
    await _load();
  }

  Future<void> _delete(OfficerAccount officer) async {
    final name = officer.fullName.trim().isEmpty
        ? officer.employeeId
        : officer.fullName.trim();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'حذف المستخدم',
            style: TextStyle(
              color: AppColors.navy,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'سيتم حذف حساب $name ولن يتمكن من تسجيل الدخول.',
            style: const TextStyle(color: AppColors.text, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'حذف',
                style: TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await AdminApi().deleteOfficer(officer.id);
      if (!mounted) return;
      _showSuccess('تم حذف المستخدم بنجاح');
      await _load();
    } on AuthApiException catch (error) {
      if (!mounted) return;
      showAuthError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showSuccess(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: AppColors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  Future<void> _signOut() async {
    await AdminApi().signOut();
    widget.onSignedOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.page,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: Material(
          color: AppColors.white,
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 76,
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  SizedBox(
                    width: 132,
                    child: TextButton(
                      onPressed: _signOut,
                      child: const Text('تسجيل الخروج'),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: AppLogoRow(
                        fmcHeight: 40,
                        tanmeyahHeight: 36,
                        gap: 14,
                        dividerHeight: 32,
                      ),
                    ),
                  ),
                  const SizedBox(width: 132),
                ],
              ),
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 960;
          final form = _CreateOfficerForm(
            employeeId: _employeeId,
            fullName: _fullName,
            email: _email,
            password: _password,
            obscure: _obscure,
            canCreate: _canCreate && !_busy,
            onChanged: () => setState(() {}),
            onTogglePassword: () => setState(() => _obscure = !_obscure),
            onCreate: _create,
          );
          final list = _OfficerList(
            loading: _loading,
            officers: _officers,
            onEdit: _busy ? null : _edit,
            onDelete: _busy ? null : _delete,
          );
          if (!wide) {
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [form, const SizedBox(height: 20), list],
            );
          }
          final formWidth = (constraints.maxWidth * 0.42).clamp(320.0, 460.0);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: formWidth, child: form),
                const SizedBox(width: 24),
                Expanded(child: list),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CreateOfficerForm extends StatelessWidget {
  const _CreateOfficerForm({
    required this.employeeId,
    required this.fullName,
    required this.email,
    required this.password,
    required this.obscure,
    required this.canCreate,
    required this.onChanged,
    required this.onTogglePassword,
    required this.onCreate,
  });

  final TextEditingController employeeId;
  final TextEditingController fullName;
  final TextEditingController email;
  final TextEditingController password;
  final bool obscure;
  final bool canCreate;
  final VoidCallback onChanged;
  final VoidCallback onTogglePassword;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'مستخدم جديد',
              style: TextStyle(
                color: AppColors.navy,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'أنشئ حساب موظف يمكنه تسجيل الدخول في التطبيق.',
              style: TextStyle(color: AppColors.muted, height: 1.4),
            ),
            const SizedBox(height: 18),
            const AppFieldLabel('رقم الموظف'),
            const SizedBox(height: 8),
            AppTextField(
              controller: employeeId,
              hint: 'رقم الموظف',
              keyboardType: TextInputType.number,
              onChanged: (_) => onChanged(),
            ),
            const SizedBox(height: 14),
            const AppFieldLabel('الاسم'),
            const SizedBox(height: 8),
            AppTextField(
              controller: fullName,
              hint: 'اسم الموظف',
              onChanged: (_) => onChanged(),
            ),
            const SizedBox(height: 14),
            const AppFieldLabel('الايميل'),
            const SizedBox(height: 8),
            AppTextField(
              controller: email,
              hint: 'example@tanmeyah.com',
              keyboardType: TextInputType.emailAddress,
              errorText:
                  email.text.trim().isEmpty ||
                      AppValidators.isTanmeyahEmail(email.text)
                  ? null
                  : AppValidators.emailMessage,
              onChanged: (value) {
                final completed = AppValidators.withTanmeyahDomain(value);
                if (completed != null) {
                  email.value = TextEditingValue(
                    text: completed,
                    selection: TextSelection.collapsed(
                      offset: completed.length,
                    ),
                  );
                }
                onChanged();
              },
            ),
            const SizedBox(height: 14),
            const AppFieldLabel('كلمة المرور'),
            const SizedBox(height: 8),
            AppTextField(
              controller: password,
              hint: '********',
              obscure: obscure,
              errorText: passwordRuleMessage(password.text),
              onChanged: (_) => onChanged(),
              suffix: AppPasswordToggle(
                obscure: obscure,
                onPressed: onTogglePassword,
              ),
            ),
            if (password.text.isEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '8 أحرف على الأقل، حرف كبير وصغير، رقم، ورمز مثل @',
                style: const TextStyle(color: AppColors.link, fontSize: 12),
              ),
            ],
            const SizedBox(height: 18),
            AppButton(
              label: 'إنشاء المستخدم',
              backgroundColor: AppColors.navy,
              onPressed: canCreate ? onCreate : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _OfficerList extends StatelessWidget {
  const _OfficerList({
    required this.loading,
    required this.officers,
    required this.onEdit,
    required this.onDelete,
  });

  final bool loading;
  final List<OfficerAccount> officers;
  final ValueChanged<OfficerAccount>? onEdit;
  final ValueChanged<OfficerAccount>? onDelete;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'المستخدمون',
                    style: TextStyle(
                      color: AppColors.navy,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 10),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.iconBubble,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      child: Text(
                        '${officers.length}',
                        style: const TextStyle(
                          color: AppColors.navy,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (loading)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.navy),
                ),
              )
            else if (officers.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 28),
                child: Text(
                  'لا يوجد مستخدمون بعد',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.muted),
                ),
              )
            else
              ...officers.map(
                (officer) => _OfficerCard(
                  officer: officer,
                  onEdit: onEdit == null ? null : () => onEdit!(officer),
                  onDelete: onDelete == null ? null : () => onDelete!(officer),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OfficerCard extends StatelessWidget {
  const _OfficerCard({
    required this.officer,
    required this.onEdit,
    required this.onDelete,
  });

  final OfficerAccount officer;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final name = officer.fullName.trim().isEmpty
        ? officer.employeeId
        : officer.fullName.trim();
    final initial = name.isEmpty ? '?' : name.characters.first.toUpperCase();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.iconBubble,
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      officer.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                        color: AppColors.fieldLabel,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.page,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Text(
                    officer.employeeId,
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _RowAction(
                label: 'تعديل',
                icon: Icons.edit_outlined,
                color: AppColors.navy,
                onPressed: onEdit,
              ),
              const SizedBox(width: 4),
              _RowAction(
                label: 'حذف',
                icon: Icons.delete_outline,
                color: AppColors.red,
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RowAction extends StatelessWidget {
  const _RowAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        minimumSize: const Size(0, 36),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Icon(icon, size: 18, color: color),
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _EditOfficerDialog extends StatefulWidget {
  const _EditOfficerDialog({required this.officer});

  final OfficerAccount officer;

  @override
  State<_EditOfficerDialog> createState() => _EditOfficerDialogState();
}

class _EditOfficerDialogState extends State<_EditOfficerDialog> {
  late final TextEditingController _employeeId;
  late final TextEditingController _fullName;
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _obscure = true;
  bool _busy = false;
  String? _error;

  bool get _canSave {
    final password = _password.text;
    final passwordOk = password.isEmpty || isStrongPassword(password, password);
    return _employeeId.text.trim().isNotEmpty &&
        _fullName.text.trim().isNotEmpty &&
        AppValidators.isTanmeyahEmail(_email.text) &&
        passwordOk &&
        !_busy;
  }

  @override
  void initState() {
    super.initState();
    _employeeId = TextEditingController(text: widget.officer.employeeId);
    _fullName = TextEditingController(text: widget.officer.fullName);
    _email = TextEditingController(text: widget.officer.email);
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _employeeId.dispose();
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await AdminApi().updateOfficer(
        id: widget.officer.id,
        employeeId: _employeeId.text,
        email: _email.text,
        fullName: _fullName.text,
        password: _password.text,
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on AuthApiException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'تعديل المستخدم',
                style: TextStyle(
                  color: AppColors.navy,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'عدّل بيانات الحساب. اترك كلمة المرور فارغة للإبقاء عليها.',
                style: TextStyle(color: AppColors.muted, height: 1.4),
              ),
              const SizedBox(height: 18),
              const AppFieldLabel('رقم الموظف'),
              const SizedBox(height: 8),
              AppTextField(
                controller: _employeeId,
                hint: 'رقم الموظف',
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 14),
              const AppFieldLabel('الاسم'),
              const SizedBox(height: 8),
              AppTextField(
                controller: _fullName,
                hint: 'اسم الموظف',
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 14),
              const AppFieldLabel('الايميل'),
              const SizedBox(height: 8),
              AppTextField(
                controller: _email,
                hint: 'example@tanmeyah.com',
                keyboardType: TextInputType.emailAddress,
                errorText:
                    _email.text.trim().isEmpty ||
                        AppValidators.isTanmeyahEmail(_email.text)
                    ? null
                    : AppValidators.emailMessage,
                onChanged: (value) {
                  final completed = AppValidators.withTanmeyahDomain(value);
                  if (completed != null) {
                    _email.value = TextEditingValue(
                      text: completed,
                      selection: TextSelection.collapsed(
                        offset: completed.length,
                      ),
                    );
                  }
                  setState(() {});
                },
              ),
              const SizedBox(height: 14),
              const AppFieldLabel('كلمة المرور الجديدة'),
              const SizedBox(height: 8),
              AppTextField(
                controller: _password,
                hint: 'اختياري',
                obscure: _obscure,
                errorText: passwordRuleMessage(_password.text),
                onChanged: (_) => setState(() {}),
                suffix: AppPasswordToggle(
                  obscure: _obscure,
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _busy
                          ? null
                          : () => Navigator.of(context).pop(false),
                      child: const Text('إلغاء'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: 'حفظ',
                      backgroundColor: AppColors.navy,
                      onPressed: _canSave ? _save : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
