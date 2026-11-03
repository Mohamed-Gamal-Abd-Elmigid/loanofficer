import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/documents/model/documents_model.dart';

class InitDocuments extends RenderDataState<DocumentsModel> {
  InitDocuments({required DocumentsModel data}) : super(data);
}

class UpdateDocuments extends RenderDataState<DocumentsModel> {
  UpdateDocuments(super.data);
}
