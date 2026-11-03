import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/new_individual_request/model/new_individual_request_model.dart';

class InitNewIndividualRequest
    extends RenderDataState<NewIndividualRequestModel> {
  InitNewIndividualRequest({required NewIndividualRequestModel data})
    : super(data);
}

class UpdateNewIndividualRequest
    extends RenderDataState<NewIndividualRequestModel> {
  UpdateNewIndividualRequest(super.data);
}
