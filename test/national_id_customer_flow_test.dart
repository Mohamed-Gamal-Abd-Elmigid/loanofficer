import 'package:flutter_test/flutter_test.dart';
import 'package:loanofficer/core/api/client_api.dart';
import 'package:loanofficer/presenter/new_individual_request/national_id_customer_flow.dart';

void main() {
  test('existing customer when names API returns custno', () async {
    final flow = NationalIdCustomerFlow(
      api: _FakeClientApi(
        names: [
          {'custno': '1001', 'fullname': 'أحمد محمد'},
        ],
      ),
    );
    final result = await flow.resolve('29001010101010');
    expect(result, isA<NationalIdExistingCustomer>());
    final existing = result as NationalIdExistingCustomer;
    expect(existing.clientId, '1001');
    expect(existing.fullName, 'أحمد محمد');
  });

  test('new customer when names list is empty', () async {
    final flow = NationalIdCustomerFlow(
      api: _FakeClientApi(
        names: const [],
        check: const NationalIdCheck(
          accepted: true,
          genderCode: '1',
          birth: '1990-01-01',
        ),
      ),
    );
    final result = await flow.resolve('29001010101010');
    expect(result, isA<NationalIdNewCustomer>());
  });
}

class _FakeClientApi extends ClientApi {
  _FakeClientApi({
    required this.names,
    this.check = const NationalIdCheck(
      accepted: true,
      genderCode: '',
      birth: '',
    ),
  });

  final List<Map<String, dynamic>> names;
  final NationalIdCheck check;

  @override
  Future<List<Map<String, String>>> customerNames(String nationalId) async {
    final rows = <Map<String, String>>[];
    for (final item in names) {
      rows.add({
        'id': '${item['custno'] ?? item['id'] ?? ''}',
        'fullName': '${item['fullname'] ?? item['fullName'] ?? ''}',
      });
    }
    return rows;
  }

  @override
  Future<NationalIdCheck> checkNationalId(String nationalId) async => check;

  @override
  Future<ClientLookups> customerFormLookups() async {
    return const ClientLookups(
      genders: [],
      health: [],
      religions: [],
      nations: [],
      social: [],
      qualifications: [],
      jobs: [],
      states: [],
      genderNames: {},
    );
  }
}
