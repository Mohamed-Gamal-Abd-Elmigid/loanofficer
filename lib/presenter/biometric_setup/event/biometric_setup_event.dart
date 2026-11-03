import 'package:loanofficer/core/bases/event/base/base_event.dart';
import 'package:loanofficer/presenter/biometric_setup/model/biometric_setup_model.dart';

class UpdateBiometricSetupEvent extends BaseEvent {
  UpdateBiometricSetupEvent(this.model);

  final BiometricSetupModel model;
}
