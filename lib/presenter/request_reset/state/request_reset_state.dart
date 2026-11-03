import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/request_reset/model/request_reset_model.dart';

class InitRequestReset extends RenderDataState<RequestResetModel> {
  InitRequestReset({required RequestResetModel data}) : super(data);
}

class UpdateRequestReset extends RenderDataState<RequestResetModel> {
  UpdateRequestReset(super.data);
}
