import 'package:loanofficer/core/bases/event/base/base_event.dart';
import 'package:loanofficer/presenter/documents/model/documents_model.dart';

class UpdateDocumentsEvent extends BaseEvent {
  UpdateDocumentsEvent(this.model);

  final DocumentsModel model;
}
