import 'package:loanofficer/core/bases/event/base/base_event.dart';
import 'package:loanofficer/presenter/more/model/more_model.dart';

class UpdateMoreEvent extends BaseEvent {
  UpdateMoreEvent(this.model);

  final MoreModel model;
}
