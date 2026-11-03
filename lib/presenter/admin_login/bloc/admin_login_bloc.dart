import 'package:loanofficer/core/bases/base_bloc.dart';
import 'package:loanofficer/presenter/admin_login/event/admin_login_event.dart';
import 'package:loanofficer/presenter/admin_login/model/admin_login_model.dart';
import 'package:loanofficer/presenter/admin_login/state/admin_login_state.dart';

class AdminLoginBloc extends BaseBloc {
  AdminLoginBloc(AdminLoginModel model)
    : super(initialState: InitAdminLogin(data: model)) {
    on<UpdateAdminLoginEvent>(_onUpdate);
  }

  void _onUpdate(UpdateAdminLoginEvent event, emit) {
    emit(UpdateAdminLogin(event.model));
  }
}
