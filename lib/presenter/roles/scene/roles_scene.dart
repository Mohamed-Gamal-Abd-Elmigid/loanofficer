import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/api/auth_api.dart';
import 'package:loanofficer/core/components/app_field_label.dart';
import 'package:loanofficer/core/components/auth_backdrop.dart';
import 'package:loanofficer/core/components/tanmeyah_brand_logo.dart';
import 'package:loanofficer/core/theme/app_typography.dart';
import 'package:loanofficer/core/theme/app_colors.dart';
import 'package:loanofficer/presenter/main_shell/scene/main_shell_scene.dart';

import 'package:loanofficer/core/bases/base_state.dart';
import 'package:loanofficer/core/bases/states/base/base_state.dart';
import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/roles/bloc/roles_bloc.dart';
import 'package:loanofficer/presenter/roles/model/roles_model.dart';

/// Same privileges step Fusion shows at `#/auth/roles`.
class RolesScene extends StatefulWidget {
  const RolesScene({super.key, required this.roles});

  final List<FmcRole> roles;

  @override
  State<RolesScene> createState() => _RolesSceneState();
}

class _RolesSceneState extends BaseState<RolesScene, RolesBloc, RolesModel> {
  String? _selectedId;
  bool _busy = false;

  Future<void> _choose(String? roleId) async {
    if (_busy || roleId == null) return;
    FmcRole? role;
    for (final item in widget.roles) {
      if (item.id == roleId) role = item;
    }
    if (role == null) return;
    setState(() {
      _busy = true;
      _selectedId = roleId;
    });
    try {
      await AuthApi().selectRole(role);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const MainShellScene()),
        (route) => false,
      );
    } on AuthApiException catch (error) {
      if (!mounted) return;
      setState(() => _selectedId = null);
      showAuthError(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget buildWidget(BuildContext context, RenderDataState<RolesModel> state) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackdrop()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 32.h,
                    ),
                    child: Center(
                      child: _PrivilegesCard(
                        roles: widget.roles,
                        selectedId: _selectedId,
                        enabled: !_busy,
                        onSelected: _choose,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void listenToState(BuildContext context, BaseStates state) {}

  @override
  RolesBloc createBloc() => RolesBloc(RolesModel());
}

class _PrivilegesCard extends StatelessWidget {
  const _PrivilegesCard({
    required this.roles,
    required this.selectedId,
    required this.enabled,
    required this.onSelected,
  });

  final List<FmcRole> roles;
  final String? selectedId;
  final bool enabled;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 420),
      padding: EdgeInsets.fromLTRB(22.w, 28.h, 22.w, 28.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 28,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: TanmeyahBrandLogo(height: 44)),
          SizedBox(height: 18.h),
          Text(
            'إختيار الصلاحية',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.dinNextArabic,
              color: AppColors.navy,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 22.h),
          const AppFieldLabel.muted('إختيار الصلاحية'),
          SizedBox(height: 8.h),
          _RoleDropdown(
            roles: roles,
            selectedId: selectedId,
            enabled: enabled,
            onSelected: onSelected,
          ),
        ],
      ),
    );
  }
}

class _RoleDropdown extends StatelessWidget {
  const _RoleDropdown({
    required this.roles,
    required this.selectedId,
    required this.enabled,
    required this.onSelected,
  });

  final List<FmcRole> roles;
  final String? selectedId;
  final bool enabled;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.dropdownBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          itemHeight: 64,
          value: selectedId,
          hint: Text(
            'إختيار الصلاحية',
            style: TextStyle(color: AppColors.dropdownHint, fontSize: 16.sp),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.dropdownHint,
            size: 22.sp,
          ),
          borderRadius: BorderRadius.circular(6.r),
          dropdownColor: AppColors.white,
          style: TextStyle(color: AppColors.text, fontSize: 14.sp),
          items: [
            for (final role in roles)
              DropdownMenuItem<String>(
                value: role.id,
                child: Text(role.label, textAlign: TextAlign.right),
              ),
          ],
          onChanged: enabled ? onSelected : null,
        ),
      ),
    );
  }
}
