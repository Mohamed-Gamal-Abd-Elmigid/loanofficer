import 'package:loanofficer/core/bases/base_bloc.dart';
import 'package:loanofficer/presenter/more/event/more_event.dart';
import 'package:loanofficer/presenter/more/model/more_model.dart';
import 'package:loanofficer/presenter/more/state/more_state.dart';

class MoreBloc extends BaseBloc {
  MoreBloc(MoreModel model) : super(initialState: InitMore(data: model)) {
    on<UpdateMoreEvent>(_onUpdate);
  }

  void _onUpdate(UpdateMoreEvent event, emit) {
    emit(UpdateMore(event.model));
  }
}
