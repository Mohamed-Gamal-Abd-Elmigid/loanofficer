import 'package:loanofficer/core/bases/event/base/base_event.dart';
import 'package:loanofficer/presenter/establishment_data/model/establishment_data_model.dart';

class UpdateEstablishmentDataEvent extends BaseEvent {
  UpdateEstablishmentDataEvent(this.model);

  final EstablishmentDataModel model;
}
