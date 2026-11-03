import 'package:loanofficer/core/bases/event/base/base_event.dart';
import 'package:loanofficer/presenter/admin_home/model/admin_home_model.dart';

class UpdateAdminHomeEvent extends BaseEvent {
  UpdateAdminHomeEvent(this.model);

  final AdminHomeModel model;
}
