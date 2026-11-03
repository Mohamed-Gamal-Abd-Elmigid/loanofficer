import 'package:loanofficer/core/bases/base_bloc.dart';
import 'package:loanofficer/presenter/financing/event/financing_event.dart';
import 'package:loanofficer/presenter/financing/model/financing_model.dart';
import 'package:loanofficer/presenter/financing/state/financing_state.dart';

class FinancingBloc extends BaseBloc {
  FinancingBloc(FinancingModel model)
    : super(initialState: InitFinancing(data: model)) {
    on<UpdateFinancingEvent>(_onUpdate);
  }

  void _onUpdate(UpdateFinancingEvent event, emit) {
    emit(UpdateFinancing(event.model));
  }
}
