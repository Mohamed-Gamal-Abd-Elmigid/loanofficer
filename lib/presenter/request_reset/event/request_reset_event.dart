import 'package:loanofficer/core/bases/event/base/base_event.dart';
import 'package:loanofficer/presenter/request_reset/model/request_reset_model.dart';

class UpdateRequestResetEvent extends BaseEvent {
  UpdateRequestResetEvent(this.model);

  final RequestResetModel model;
}
