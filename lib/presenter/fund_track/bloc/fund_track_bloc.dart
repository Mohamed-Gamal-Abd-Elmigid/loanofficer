import 'package:loanofficer/core/api/api_exception.dart';
import 'package:loanofficer/core/api/fund_track_api.dart';
import 'package:loanofficer/core/api/funding_orders_api.dart';
import 'package:loanofficer/core/bases/base_bloc.dart';
import 'package:loanofficer/presenter/fund_track/event/fund_track_event.dart';
import 'package:loanofficer/presenter/fund_track/model/fund_track_model.dart';
import 'package:loanofficer/presenter/fund_track/state/fund_track_state.dart';

class FundTrackBloc extends BaseBloc {
  FundTrackBloc(this._model, {FundingOrdersApi? ordersApi, FundTrackApi? wfApi})
    : _ordersApi = ordersApi ?? FundingOrdersApi(),
      _wfApi = wfApi ?? FundTrackApi(),
      super(initialState: InitFundTrack(data: _model)) {
    on<LoadFundOrdersEvent>(_onLoadOrders);
    on<SearchWorkflowTrackEvent>(_onSearchWf);
    add(LoadFundOrdersEvent());
  }

  final FundTrackModel _model;
  final FundingOrdersApi _ordersApi;
  final FundTrackApi _wfApi;

  Future<void> _onLoadOrders(LoadFundOrdersEvent event, emit) async {
    try {
      _model.orders = await _ordersApi.inboxOrders();
      emit(UpdateFundTrack(_model));
    } on AuthApiException catch (error) {
      emit(FundTrackMessage(error.message));
      emit(UpdateFundTrack(_model));
    } catch (_) {
      emit(FundTrackMessage('تعذر تحميل الطلبات'));
      emit(UpdateFundTrack(_model));
    }
  }

  Future<void> _onSearchWf(SearchWorkflowTrackEvent event, emit) async {
    try {
      _model
        ..wfRows = await _wfApi.findWorkflowServices(
          custIdno: event.custId,
          serviceId: event.serviceId,
        )
        ..wfSearched =
            event.custId.trim().isNotEmpty || event.serviceId.trim().isNotEmpty;
      emit(UpdateFundTrack(_model));
    } on AuthApiException catch (error) {
      emit(FundTrackMessage(error.message));
      emit(UpdateFundTrack(_model));
    } catch (_) {
      emit(FundTrackMessage('تعذر تحميل الطلبات'));
      emit(UpdateFundTrack(_model));
    }
  }
}
