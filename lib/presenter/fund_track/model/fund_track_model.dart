import 'package:loanofficer/core/api/fund_track_api.dart';
import 'package:loanofficer/core/api/funding_orders_api.dart';

class FundTrackModel {
  List<FundingOrderRow> orders = [];
  List<FundTrackRow> wfRows = [];
  bool wfSearched = false;
}
