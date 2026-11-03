import 'package:loanofficer/core/bases/states/base/non_render_state.dart';
import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/splash/model/splash_model.dart';

class InitSplash extends RenderDataState<SplashModel> {
  InitSplash({required SplashModel data}) : super(data);
}

class OpenLoginState extends NonRenderState {}
