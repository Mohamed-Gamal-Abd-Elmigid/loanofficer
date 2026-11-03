import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/login/model/login_model.dart';

class InitLogin extends RenderDataState<LoginModel> {
  InitLogin({required LoginModel data}) : super(data);
}

class UpdateLogin extends RenderDataState<LoginModel> {
  UpdateLogin(super.data);
}
