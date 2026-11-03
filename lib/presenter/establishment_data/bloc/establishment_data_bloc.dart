import 'package:loanofficer/core/bases/base_bloc.dart';
import 'package:loanofficer/presenter/establishment_data/event/establishment_data_event.dart';
import 'package:loanofficer/presenter/establishment_data/model/establishment_data_model.dart';
import 'package:loanofficer/presenter/establishment_data/state/establishment_data_state.dart';

class EstablishmentDataBloc extends BaseBloc {
  EstablishmentDataBloc(EstablishmentDataModel model)
    : super(initialState: InitEstablishmentData(data: model)) {
    on<UpdateEstablishmentDataEvent>(_onUpdate);
  }

  void _onUpdate(UpdateEstablishmentDataEvent event, emit) {
    emit(UpdateEstablishmentData(event.model));
  }
}
