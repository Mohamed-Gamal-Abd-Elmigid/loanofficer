import 'package:loanofficer/core/bases/event/base/base_event.dart';

class LoadFundOrdersEvent extends BaseEvent {}

class SearchWorkflowTrackEvent extends BaseEvent {
  SearchWorkflowTrackEvent({this.custId = '', this.serviceId = ''});

  final String custId;
  final String serviceId;
}
