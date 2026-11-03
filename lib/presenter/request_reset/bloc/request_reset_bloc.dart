import 'package:loanofficer/core/bases/base_bloc.dart';
import 'package:loanofficer/presenter/request_reset/event/request_reset_event.dart';
import 'package:loanofficer/presenter/request_reset/model/request_reset_model.dart';
import 'package:loanofficer/presenter/request_reset/state/request_reset_state.dart';

class RequestResetBloc extends BaseBloc {
  RequestResetBloc(RequestResetModel model)
    : super(initialState: InitRequestReset(data: model)) {
    on<UpdateRequestResetEvent>(_onUpdate);
  }

  void _onUpdate(UpdateRequestResetEvent event, emit) {
    emit(UpdateRequestReset(event.model));
  }
}
