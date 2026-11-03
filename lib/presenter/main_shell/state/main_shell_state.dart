import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/main_shell/model/main_shell_model.dart';

class InitMainShell extends RenderDataState<MainShellModel> {
  InitMainShell({required MainShellModel data}) : super(data);
}

class UpdateMainShell extends RenderDataState<MainShellModel> {
  UpdateMainShell(super.data);
}
