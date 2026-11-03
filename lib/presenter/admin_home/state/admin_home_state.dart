import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/admin_home/model/admin_home_model.dart';

class InitAdminHome extends RenderDataState<AdminHomeModel> {
  InitAdminHome({required AdminHomeModel data}) : super(data);
}

class UpdateAdminHome extends RenderDataState<AdminHomeModel> {
  UpdateAdminHome(super.data);
}
