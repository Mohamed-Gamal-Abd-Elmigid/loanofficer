import 'package:loanofficer/core/bases/base_bloc.dart';
import 'package:loanofficer/presenter/admin_home/event/admin_home_event.dart';
import 'package:loanofficer/presenter/admin_home/model/admin_home_model.dart';
import 'package:loanofficer/presenter/admin_home/state/admin_home_state.dart';

class AdminHomeBloc extends BaseBloc {
  AdminHomeBloc(AdminHomeModel model)
    : super(initialState: InitAdminHome(data: model)) {
    on<UpdateAdminHomeEvent>(_onUpdate);
  }

  void _onUpdate(UpdateAdminHomeEvent event, emit) {
    emit(UpdateAdminHome(event.model));
  }
}
