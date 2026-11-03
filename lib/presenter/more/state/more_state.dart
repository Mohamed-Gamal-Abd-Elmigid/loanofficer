import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/more/model/more_model.dart';

class InitMore extends RenderDataState<MoreModel> {
  InitMore({required MoreModel data}) : super(data);
}

class UpdateMore extends RenderDataState<MoreModel> {
  UpdateMore(super.data);
}
