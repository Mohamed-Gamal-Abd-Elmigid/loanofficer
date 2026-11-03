import 'package:loanofficer/core/bases/base_bloc.dart';
import 'package:loanofficer/presenter/login/event/login_event.dart';
import 'package:loanofficer/presenter/login/model/login_model.dart';
import 'package:loanofficer/presenter/login/state/login_state.dart';

class LoginBloc extends BaseBloc {
  LoginBloc(LoginModel model) : super(initialState: InitLogin(data: model)) {
    on<UpdateLoginEvent>(_onUpdate);
  }

  void _onUpdate(UpdateLoginEvent event, emit) {
    emit(UpdateLogin(event.model));
  }
}
