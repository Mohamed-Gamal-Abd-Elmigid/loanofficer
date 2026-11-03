import 'package:loanofficer/core/api/fmc_client.dart';
import 'package:loanofficer/core/bases/base_bloc.dart';
import 'package:loanofficer/presenter/new_individual_request/event/new_individual_request_event.dart';
import 'package:loanofficer/presenter/new_individual_request/model/new_individual_request_model.dart';
import 'package:loanofficer/presenter/new_individual_request/state/new_individual_request_state.dart';

class NewIndividualRequestBloc extends BaseBloc {
  NewIndividualRequestBloc(this._model)
    : super(initialState: InitNewIndividualRequest(data: _model)) {
    on<LoadNewIndividualRequestEvent>(_onLoad);
    on<UpdateNewIndividualRequestEvent>(_onUpdate);
    add(LoadNewIndividualRequestEvent());
  }

  final NewIndividualRequestModel _model;

  /// Same calls Fusion makes when opening إنشاء طلب تمويل فردي:
  /// the shell password notice, then the product list for this form.
  Future<void> _onLoad(LoadNewIndividualRequestEvent event, emit) async {
    final client = FmcClient();
    final results = await Future.wait<dynamic>([
      _call(client, 'adminController/notifyPasswordsExpiration'),
      _call(client, 'lookups/products/1'),
    ]);
    _model.products = _products(results.length > 1 ? results[1] : null);
    emit(UpdateNewIndividualRequest(_model));
  }

  void _onUpdate(UpdateNewIndividualRequestEvent event, emit) {
    emit(UpdateNewIndividualRequest(event.model));
  }

  Future<dynamic> _call(FmcClient client, String path) async {
    try {
      return await client.get(path);
    } catch (_) {
      return null;
    }
  }
}

List<FundingProduct> _products(dynamic result) {
  if (result is! List) return [];
  final products = <FundingProduct>[];
  for (final item in result) {
    if (item is! Map) continue;
    final arabic = _text(item['nameAr']);
    final english = _text(item['nameEn']);
    final name = arabic.isNotEmpty ? arabic : english;
    if (name.isEmpty) continue;
    final loanType = item['loanType'];
    products.add(
      FundingProduct(
        name: name,
        loanType: loanType is num
            ? loanType.toInt()
            : int.tryParse('$loanType') ?? 0,
        orgRequired: _text(item['orgFlag']).toUpperCase() == 'Y',
        maxAmount: _number(item['requiredAmt']),
        maxInstallments: _number(item['requiredNoOfKst']),
      ),
    );
  }
  return products;
}

String _text(dynamic value) => value == null ? '' : '$value'.trim();

int _number(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse('$value') ?? 0;
}
