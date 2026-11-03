import 'package:loanofficer/core/bases/base_bloc.dart';
import 'package:loanofficer/presenter/verify_email/event/verify_email_event.dart';
import 'package:loanofficer/presenter/verify_email/model/verify_email_model.dart';
import 'package:loanofficer/presenter/verify_email/state/verify_email_state.dart';

class VerifyEmailBloc extends BaseBloc {
  VerifyEmailBloc(VerifyEmailModel model)
    : super(initialState: InitVerifyEmail(data: model)) {
    on<UpdateVerifyEmailEvent>(_onUpdate);
  }

  void _onUpdate(UpdateVerifyEmailEvent event, emit) {
    emit(UpdateVerifyEmail(event.model));
  }
}
