import 'package:flutter/material.dart';
import 'package:loanofficer/presenter/admin_home/scene/admin_home_scene.dart';
import 'package:loanofficer/presenter/admin_login/scene/admin_login_scene.dart';
import 'package:loanofficer/core/api/admin_api.dart';
import 'package:loanofficer/core/theme/app_colors.dart';

import 'package:loanofficer/core/bases/base_state.dart';
import 'package:loanofficer/core/bases/states/base/base_state.dart';
import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/admin_gate/bloc/admin_gate_bloc.dart';
import 'package:loanofficer/presenter/admin_gate/model/admin_gate_model.dart';

class AdminGateScene extends StatefulWidget {
  const AdminGateScene({super.key});

  @override
  State<AdminGateScene> createState() => _AdminGateSceneState();
}

class _AdminGateSceneState
    extends BaseState<AdminGateScene, AdminGateBloc, AdminGateModel> {
  bool _checking = true;
  bool _signedIn = false;

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    final isAdmin = await AdminApi().isCurrentUserAdmin();
    if (!isAdmin) await AdminApi().signOut();
    if (!mounted) return;
    setState(() {
      _signedIn = isAdmin;
      _checking = false;
    });
  }

  @override
  Widget buildWidget(
    BuildContext context,
    RenderDataState<AdminGateModel> state,
  ) {
    if (_checking) {
      return const Scaffold(
        backgroundColor: AppColors.page,
        body: Center(child: CircularProgressIndicator(color: AppColors.navy)),
      );
    }
    if (_signedIn) {
      return AdminHomeScene(
        onSignedOut: () => setState(() => _signedIn = false),
      );
    }
    return AdminLoginScene(onSignedIn: () => setState(() => _signedIn = true));
  }

  @override
  void listenToState(BuildContext context, BaseStates state) {}

  @override
  AdminGateBloc createBloc() => AdminGateBloc(AdminGateModel());
}
