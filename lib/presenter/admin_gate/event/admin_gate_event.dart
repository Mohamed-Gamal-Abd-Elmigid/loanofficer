import 'package:loanofficer/core/bases/event/base/base_event.dart';
import 'package:loanofficer/presenter/admin_gate/model/admin_gate_model.dart';

class UpdateAdminGateEvent extends BaseEvent {
  UpdateAdminGateEvent(this.model);

  final AdminGateModel model;
}
