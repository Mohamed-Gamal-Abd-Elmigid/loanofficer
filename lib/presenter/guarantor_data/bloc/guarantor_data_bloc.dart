import 'package:loanofficer/core/bases/base_bloc.dart';
import 'package:loanofficer/presenter/guarantor_data/event/guarantor_data_event.dart';
import 'package:loanofficer/presenter/guarantor_data/model/guarantor_data_model.dart';
import 'package:loanofficer/presenter/guarantor_data/state/guarantor_data_state.dart';

class GuarantorDataBloc extends BaseBloc {
  GuarantorDataBloc(GuarantorDataModel model)
    : super(initialState: InitGuarantorData(data: model)) {
    on<UpdateGuarantorDataEvent>(_onUpdate);
  }

  void _onUpdate(UpdateGuarantorDataEvent event, emit) {
    emit(UpdateGuarantorData(event.model));
  }
}
