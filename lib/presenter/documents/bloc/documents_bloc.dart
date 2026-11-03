import 'package:loanofficer/core/bases/base_bloc.dart';
import 'package:loanofficer/presenter/documents/event/documents_event.dart';
import 'package:loanofficer/presenter/documents/model/documents_model.dart';
import 'package:loanofficer/presenter/documents/state/documents_state.dart';

class DocumentsBloc extends BaseBloc {
  DocumentsBloc(DocumentsModel model)
    : super(initialState: InitDocuments(data: model)) {
    on<UpdateDocumentsEvent>(_onUpdate);
  }

  void _onUpdate(UpdateDocumentsEvent event, emit) {
    emit(UpdateDocuments(event.model));
  }
}
