import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/roles/model/roles_model.dart';

class InitRoles extends RenderDataState<RolesModel> {
  InitRoles({required RolesModel data}) : super(data);
}

class UpdateRoles extends RenderDataState<RolesModel> {
  UpdateRoles(super.data);
}
