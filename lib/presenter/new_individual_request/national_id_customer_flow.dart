import 'package:loanofficer/core/api/client_api.dart';

/// Fusion create-personal-fund national ID resolution (web parity).
///
/// 1. `GET cif/customers/names?idNo=` — non-empty ⇒ existing CIF customer.
/// 2. Empty list ⇒ new customer: `GET cif/checkIdno` + form lookups.
sealed class NationalIdCustomerResolution {
  const NationalIdCustomerResolution();
}

class NationalIdExistingCustomer extends NationalIdCustomerResolution {
  const NationalIdExistingCustomer({
    required this.nationalId,
    required this.clientId,
    required this.fullName,
  });

  final String nationalId;
  final String clientId;
  final String fullName;
}

class NationalIdNewCustomer extends NationalIdCustomerResolution {
  const NationalIdNewCustomer({
    required this.nationalId,
    required this.check,
    required this.lookups,
  });

  final String nationalId;
  final NationalIdCheck check;
  final ClientLookups? lookups;
}

class NationalIdCustomerFlow {
  NationalIdCustomerFlow({ClientApi? api}) : _api = api ?? ClientApi();

  final ClientApi _api;

  Future<NationalIdCustomerResolution> resolve(String nationalId) async {
    final id = nationalId.trim();
    final names = await _api.customerNames(id);
    for (final row in names) {
      final clientId = (row['id'] ?? '').trim();
      final fullName = (row['fullName'] ?? '').trim();
      if (clientId.isEmpty && fullName.isEmpty) continue;
      return NationalIdExistingCustomer(
        nationalId: id,
        clientId: clientId,
        fullName: fullName,
      );
    }
    final check = await _api.checkNationalId(id);
    ClientLookups? lookups;
    try {
      lookups = await _api.customerFormLookups();
    } catch (_) {}
    return NationalIdNewCustomer(
      nationalId: id,
      check: check,
      lookups: lookups,
    );
  }
}
