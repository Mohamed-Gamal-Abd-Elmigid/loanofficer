import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/establishment_data/model/establishment_data_model.dart';

class InitEstablishmentData extends RenderDataState<EstablishmentDataModel> {
  InitEstablishmentData({required EstablishmentDataModel data}) : super(data);
}

class UpdateEstablishmentData extends RenderDataState<EstablishmentDataModel> {
  UpdateEstablishmentData(super.data);
}
