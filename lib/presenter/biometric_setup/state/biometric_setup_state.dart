import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/biometric_setup/model/biometric_setup_model.dart';

class InitBiometricSetup extends RenderDataState<BiometricSetupModel> {
  InitBiometricSetup({required BiometricSetupModel data}) : super(data);
}

class UpdateBiometricSetup extends RenderDataState<BiometricSetupModel> {
  UpdateBiometricSetup(super.data);
}
