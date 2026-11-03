import 'package:loanofficer/core/bases/event/base/base_event.dart';
import 'package:loanofficer/presenter/login/model/login_model.dart';

class UpdateLoginEvent extends BaseEvent {
  UpdateLoginEvent(this.model);

  final LoginModel model;
}
