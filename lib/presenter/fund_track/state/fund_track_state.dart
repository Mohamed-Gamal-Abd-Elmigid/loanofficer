import 'package:loanofficer/core/bases/states/base/non_render_state.dart';
import 'package:loanofficer/core/bases/states/base/render_data_state.dart';
import 'package:loanofficer/presenter/fund_track/model/fund_track_model.dart';

class InitFundTrack extends RenderDataState<FundTrackModel> {
  InitFundTrack({required FundTrackModel data}) : super(data);
}

class UpdateFundTrack extends RenderDataState<FundTrackModel> {
  UpdateFundTrack(super.data);
}

class FundTrackMessage extends NonRenderState {
  FundTrackMessage(this.message);
  final String message;
}
