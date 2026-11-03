import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/guarantor_data/model/guarantor_data_model.dart';

class InitGuarantorData extends RenderDataState<GuarantorDataModel> {
  InitGuarantorData({required GuarantorDataModel data}) : super(data);
}

class UpdateGuarantorData extends RenderDataState<GuarantorDataModel> {
  UpdateGuarantorData(super.data);
}
