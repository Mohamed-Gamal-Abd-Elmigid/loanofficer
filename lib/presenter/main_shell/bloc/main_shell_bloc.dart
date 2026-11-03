import 'package:loanofficer/core/bases/base_bloc.dart';
import 'package:loanofficer/presenter/main_shell/event/main_shell_event.dart';
import 'package:loanofficer/presenter/main_shell/model/main_shell_model.dart';
import 'package:loanofficer/presenter/main_shell/state/main_shell_state.dart';

class MainShellBloc extends BaseBloc {
  MainShellBloc(MainShellModel model)
    : super(initialState: InitMainShell(data: model)) {
    on<UpdateMainShellEvent>(_onUpdate);
  }

  void _onUpdate(UpdateMainShellEvent event, emit) {
    emit(UpdateMainShell(event.model));
  }
}
