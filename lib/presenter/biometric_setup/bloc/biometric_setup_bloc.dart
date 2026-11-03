import 'package:loanofficer/core/bases/base_bloc.dart';
import 'package:loanofficer/presenter/biometric_setup/event/biometric_setup_event.dart';
import 'package:loanofficer/presenter/biometric_setup/model/biometric_setup_model.dart';
import 'package:loanofficer/presenter/biometric_setup/state/biometric_setup_state.dart';

class BiometricSetupBloc extends BaseBloc {
  BiometricSetupBloc(BiometricSetupModel model)
    : super(initialState: InitBiometricSetup(data: model)) {
    on<UpdateBiometricSetupEvent>(_onUpdate);
  }

  void _onUpdate(UpdateBiometricSetupEvent event, emit) {
    emit(UpdateBiometricSetup(event.model));
  }
}
