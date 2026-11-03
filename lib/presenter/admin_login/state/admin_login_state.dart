import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/admin_login/model/admin_login_model.dart';

class InitAdminLogin extends RenderDataState<AdminLoginModel> {
  InitAdminLogin({required AdminLoginModel data}) : super(data);
}

class UpdateAdminLogin extends RenderDataState<AdminLoginModel> {
  UpdateAdminLogin(super.data);
}
