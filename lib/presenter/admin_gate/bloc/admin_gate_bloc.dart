import 'package:loanofficer/core/bases/base_bloc.dart';
import 'package:loanofficer/presenter/admin_gate/event/admin_gate_event.dart';
import 'package:loanofficer/presenter/admin_gate/model/admin_gate_model.dart';
import 'package:loanofficer/presenter/admin_gate/state/admin_gate_state.dart';

class AdminGateBloc extends BaseBloc {
  AdminGateBloc(AdminGateModel model)
    : super(initialState: InitAdminGate(data: model)) {
    on<UpdateAdminGateEvent>(_onUpdate);
  }

  void _onUpdate(UpdateAdminGateEvent event, emit) {
    emit(UpdateAdminGate(event.model));
  }
}
