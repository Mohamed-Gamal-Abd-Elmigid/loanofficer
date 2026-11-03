import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/verify_email/model/verify_email_model.dart';

class InitVerifyEmail extends RenderDataState<VerifyEmailModel> {
  InitVerifyEmail({required VerifyEmailModel data}) : super(data);
}

class UpdateVerifyEmail extends RenderDataState<VerifyEmailModel> {
  UpdateVerifyEmail(super.data);
}
