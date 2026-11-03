import 'package:loanofficer/core/bases/base_bloc.dart';
import 'package:loanofficer/presenter/roles/event/roles_event.dart';
import 'package:loanofficer/presenter/roles/model/roles_model.dart';
import 'package:loanofficer/presenter/roles/state/roles_state.dart';

class RolesBloc extends BaseBloc {
  RolesBloc(RolesModel model) : super(initialState: InitRoles(data: model)) {
    on<UpdateRolesEvent>(_onUpdate);
  }

  void _onUpdate(UpdateRolesEvent event, emit) {
    emit(UpdateRoles(event.model));
  }
}
