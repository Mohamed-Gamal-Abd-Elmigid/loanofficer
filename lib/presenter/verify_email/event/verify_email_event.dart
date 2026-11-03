import 'package:loanofficer/core/bases/event/base/base_event.dart';
import 'package:loanofficer/presenter/verify_email/model/verify_email_model.dart';

class UpdateVerifyEmailEvent extends BaseEvent {
  UpdateVerifyEmailEvent(this.model);

  final VerifyEmailModel model;
}
