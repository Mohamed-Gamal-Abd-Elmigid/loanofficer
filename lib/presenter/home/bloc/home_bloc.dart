import 'package:loanofficer/core/api/fmc_client.dart';
import 'package:loanofficer/core/api/fmc_session.dart';
import 'package:loanofficer/core/bases/base_bloc.dart';
import 'package:loanofficer/presenter/home/event/home_event.dart';
import 'package:loanofficer/presenter/home/model/home_model.dart';
import 'package:loanofficer/presenter/home/state/home_state.dart';

class HomeBloc extends BaseBloc {
  HomeBloc(this._model) : super(initialState: InitHome(data: _model)) {
    on<LoadHomeEvent>(_onLoad);
    add(LoadHomeEvent());
  }

  final HomeModel _model;

  /// Same calls Fusion makes for the dashboard: settings, then the
  /// password-expiration notice shown on the home page.
  Future<void> _onLoad(LoadHomeEvent event, emit) async {
    final session = FmcSession.instance;
    Map<String, dynamic>? login;
    try {
      login = await session.readLogin();
    } catch (_) {}
    final client = FmcClient();
    final results = await Future.wait<dynamic>([
      _call(client, 'public/sysUserParameters'),
      _call(client, 'adminController/notifyPasswordsExpiration'),
    ]);
    _model
      ..date = _text(login?['appDate'])
      ..name = _first(login, const ['nameAr', 'nameEn'])
      ..branch = _text(login?['brName'])
      ..role = _roleName(login, session.roleId)
      ..alerts = _alertLines(results.length > 1 ? results[1] : null);
    emit(UpdateHome(_model));
  }

  Future<dynamic> _call(FmcClient client, String path) async {
    try {
      return await client.get(path);
    } catch (_) {
      return null;
    }
  }
}

List<String> _alertLines(dynamic result) {
  if (result is! List) return const [];
  final lines = <String>[];
  for (final item in result) {
    if (item is! Map) continue;
    final description = _text(item['description']);
    final status = _text(item['status']);
    if (description.isEmpty && status.isEmpty) continue;
    final days = item['remainingDays'];
    final count = days is num
        ? days.abs().toInt()
        : int.tryParse('$days')?.abs() ?? 0;
    lines.add('$description has $status $count days ago');
  }
  return lines;
}

String _roleName(Map<String, dynamic>? login, String? roleId) {
  final roles = login?['availableRoleAndScreens'];
  if (roles is! List) return '';
  for (final item in roles) {
    if (item is! Map) continue;
    if (roleId != null && '${item['roleId']}'.trim() != roleId) continue;
    final arabic = _text(item['roleNameAr']);
    if (arabic.isNotEmpty) return arabic;
    return _text(item['roleNameEn']);
  }
  return '';
}

String _first(Map<String, dynamic>? row, List<String> keys) {
  if (row == null) return '';
  for (final key in keys) {
    final text = _text(row[key]);
    if (text.isNotEmpty) return text;
  }
  return '';
}

String _text(dynamic value) => value == null ? '' : '$value'.trim();
