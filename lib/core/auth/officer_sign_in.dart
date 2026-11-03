import 'package:loanofficer/core/api/auth_api.dart';

/// Signs in and returns the privileges the user still has to choose.
Future<List<FmcRole>> signInOfficer({
  required String employeeId,
  required String password,
}) {
  return AuthApi().login(employeeId: employeeId, password: password);
}
