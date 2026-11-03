import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/financing/model/financing_model.dart';

class InitFinancing extends RenderDataState<FinancingModel> {
  InitFinancing({required FinancingModel data}) : super(data);
}

class UpdateFinancing extends RenderDataState<FinancingModel> {
  UpdateFinancing(super.data);
}
