import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:loanofficer/core/api/api_log_client.dart';

http.Client createFmcPlatformClient() {
  final io = HttpClient()
    ..badCertificateCallback = (certificate, host, port) {
      return host == 'fmc-api-uat.tanmeyah.lan' ||
          host.endsWith('.tanmeyah.lan');
    };
  return ApiLogClient(IOClient(io));
}
