import 'package:loanofficer/core/bases/base_bloc.dart';
import 'package:loanofficer/presenter/client_data/event/client_data_event.dart';
import 'package:loanofficer/presenter/client_data/model/client_data_model.dart';
import 'package:loanofficer/presenter/client_data/state/client_data_state.dart';

class ClientDataBloc extends BaseBloc {
  ClientDataBloc(ClientDataModel model)
    : super(initialState: InitClientData(data: model)) {
    on<UpdateClientDataEvent>(_onUpdate);
  }

  void _onUpdate(UpdateClientDataEvent event, emit) {
    emit(UpdateClientData(event.model));
  }
}
