import 'package:loanofficer/core/bases/event/base/base_event.dart';
import 'package:loanofficer/presenter/create_password/model/create_password_model.dart';

class UpdateCreatePasswordEvent extends BaseEvent {
  UpdateCreatePasswordEvent(this.model);

  final CreatePasswordModel model;
}
