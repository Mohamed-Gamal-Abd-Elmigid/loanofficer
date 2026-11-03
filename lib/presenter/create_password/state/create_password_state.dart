import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/create_password/model/create_password_model.dart';

class InitCreatePassword extends RenderDataState<CreatePasswordModel> {
  InitCreatePassword({required CreatePasswordModel data}) : super(data);
}

class UpdateCreatePassword extends RenderDataState<CreatePasswordModel> {
  UpdateCreatePassword(super.data);
}
