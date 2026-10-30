import 'package:http/http.dart' as http;
import 'package:loanofficer/core/api/api_log_client.dart';

http.Client createFmcPlatformClient() => ApiLogClient();
