import 'package:loanofficer/core/bases/event/base/base_event.dart';
import 'package:loanofficer/presenter/main_shell/model/main_shell_model.dart';

class UpdateMainShellEvent extends BaseEvent {
  UpdateMainShellEvent(this.model);

  final MainShellModel model;
}
