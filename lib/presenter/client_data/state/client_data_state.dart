import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/client_data/model/client_data_model.dart';

class InitClientData extends RenderDataState<ClientDataModel> {
  InitClientData({required ClientDataModel data}) : super(data);
}

class UpdateClientData extends RenderDataState<ClientDataModel> {
  UpdateClientData(super.data);
}
