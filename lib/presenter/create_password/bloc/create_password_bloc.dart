import 'package:loanofficer/core/bases/base_bloc.dart';
import 'package:loanofficer/presenter/create_password/event/create_password_event.dart';
import 'package:loanofficer/presenter/create_password/model/create_password_model.dart';
import 'package:loanofficer/presenter/create_password/state/create_password_state.dart';

class CreatePasswordBloc extends BaseBloc {
  CreatePasswordBloc(CreatePasswordModel model)
    : super(initialState: InitCreatePassword(data: model)) {
    on<UpdateCreatePasswordEvent>(_onUpdate);
  }

  void _onUpdate(UpdateCreatePasswordEvent event, emit) {
    emit(UpdateCreatePassword(event.model));
  }
}
