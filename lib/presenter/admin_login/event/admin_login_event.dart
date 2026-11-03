import 'package:loanofficer/core/bases/event/base/base_event.dart';
import 'package:loanofficer/presenter/admin_login/model/admin_login_model.dart';

class UpdateAdminLoginEvent extends BaseEvent {
  UpdateAdminLoginEvent(this.model);

  final AdminLoginModel model;
}
