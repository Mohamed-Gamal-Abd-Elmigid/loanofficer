import 'package:loanofficer/core/bases/event/base/base_event.dart';
import 'package:loanofficer/presenter/financing/model/financing_model.dart';

class UpdateFinancingEvent extends BaseEvent {
  UpdateFinancingEvent(this.model);

  final FinancingModel model;
}
