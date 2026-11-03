import 'package:loanofficer/core/bases/event/base/base_event.dart';
import 'package:loanofficer/presenter/new_individual_request/model/new_individual_request_model.dart';

class LoadNewIndividualRequestEvent extends BaseEvent {}

class UpdateNewIndividualRequestEvent extends BaseEvent {
  UpdateNewIndividualRequestEvent(this.model);

  final NewIndividualRequestModel model;
}
