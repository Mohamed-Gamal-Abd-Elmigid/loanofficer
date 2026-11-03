import 'package:loanofficer/core/bases/event/base/base_event.dart';
import 'package:loanofficer/presenter/guarantor_data/model/guarantor_data_model.dart';

class UpdateGuarantorDataEvent extends BaseEvent {
  UpdateGuarantorDataEvent(this.model);

  final GuarantorDataModel model;
}
