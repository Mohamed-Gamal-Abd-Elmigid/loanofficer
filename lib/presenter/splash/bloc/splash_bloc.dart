import 'package:loanofficer/core/api/fmc_client.dart';
import 'package:loanofficer/core/bases/base_bloc.dart';
import 'package:loanofficer/presenter/splash/event/splash_event.dart';
import 'package:loanofficer/presenter/splash/model/splash_model.dart';
import 'package:loanofficer/presenter/splash/state/splash_state.dart';

class SplashBloc extends BaseBloc {
  SplashBloc(SplashModel model) : super(initialState: InitSplash(data: model)) {
    on<StartSplashEvent>(_onStart);
    add(StartSplashEvent());
  }

  Future<void> _onStart(StartSplashEvent event, emit) async {
    await Future.wait<void>([
      Future<void>.delayed(const Duration(seconds: 5)),
      _loadStartupApis(),
    ]);
    emit(OpenLoginState());
  }

  /// Same two calls Fusion makes when the login page loads.
  Future<void> _loadStartupApis() async {
    final client = FmcClient();
    await Future.wait<void>([
      _call(client, 'public/sysUserParameters'),
      _call(client, 'adminController/notifyPasswordsExpiration'),
    ]);
  }

  Future<void> _call(FmcClient client, String path) async {
    try {
      await client.get(path);
    } catch (_) {}
  }
}
