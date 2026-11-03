import 'package:loanofficer/core/bases/event/base/base_event.dart';
import 'package:loanofficer/presenter/client_data/model/client_data_model.dart';

class UpdateClientDataEvent extends BaseEvent {
  UpdateClientDataEvent(this.model);

  final ClientDataModel model;
}
