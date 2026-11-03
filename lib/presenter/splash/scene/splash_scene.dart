import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:loanofficer/core/bases/base_state.dart';
import 'package:loanofficer/core/bases/states/base/base_state.dart';
import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/splash/bloc/splash_bloc.dart';
import 'package:loanofficer/presenter/splash/model/splash_model.dart';
import 'package:loanofficer/presenter/splash/state/splash_state.dart';
import 'package:loanofficer/presenter/login/scene/login_scene.dart';

class SplashScene extends StatefulWidget {
  const SplashScene({super.key});

  @override
  State<SplashScene> createState() => _SplashSceneState();
}

class _SplashSceneState
    extends BaseState<SplashScene, SplashBloc, SplashModel> {
  @override
  Widget buildWidget(BuildContext context, RenderDataState<SplashModel> state) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          image: const AssetImage('assets/images/splash.gif'),
          width: 280.w,
          height: 280.h,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  @override
  void listenToState(BuildContext context, BaseStates state) {
    if (state is! OpenLoginState || !context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LoginScene()),
    );
  }

  @override
  SplashBloc createBloc() => SplashBloc(SplashModel());
}
