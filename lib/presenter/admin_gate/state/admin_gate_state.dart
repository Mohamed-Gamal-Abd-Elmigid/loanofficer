import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/admin_gate/model/admin_gate_model.dart';

class InitAdminGate extends RenderDataState<AdminGateModel> {
  InitAdminGate({required AdminGateModel data}) : super(data);
}

class UpdateAdminGate extends RenderDataState<AdminGateModel> {
  UpdateAdminGate(super.data);
}
