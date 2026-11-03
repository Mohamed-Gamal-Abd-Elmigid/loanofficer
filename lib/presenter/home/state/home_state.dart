import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/home/model/home_model.dart';

class InitHome extends RenderDataState<HomeModel> {
  InitHome({required HomeModel data}) : super(data);
}

class UpdateHome extends RenderDataState<HomeModel> {
  UpdateHome(super.data);
}
