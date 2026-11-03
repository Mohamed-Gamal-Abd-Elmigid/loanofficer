import 'package:loanofficer/core/bases/event/base/base_event.dart';
import 'package:loanofficer/presenter/roles/model/roles_model.dart';

class UpdateRolesEvent extends BaseEvent {
  UpdateRolesEvent(this.model);

  final RolesModel model;
}
