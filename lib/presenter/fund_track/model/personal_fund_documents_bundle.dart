class PersonalFundDocumentsBundle {
  const PersonalFundDocumentsBundle({
    this.customers = const [],
    this.organization = const [],
    this.guarantors = const [],
    this.service = const [],
    this.iscoreDocs = const [],
  });

  final List<Map<String, dynamic>> customers;
  final List<Map<String, dynamic>> organization;
  final List<Map<String, dynamic>> guarantors;
  final List<Map<String, dynamic>> service;
  final List<Map<String, dynamic>> iscoreDocs;

  bool get isEmpty =>
      customers.isEmpty &&
      organization.isEmpty &&
      guarantors.isEmpty &&
      service.isEmpty &&
      iscoreDocs.isEmpty;

  factory PersonalFundDocumentsBundle.fromDynamic(dynamic result) {
    if (result is! Map) {
      if (result is List) {
        return PersonalFundDocumentsBundle(
          service: _list(result),
        );
      }
      return const PersonalFundDocumentsBundle();
    }
    final map = Map<String, dynamic>.from(result);
    return PersonalFundDocumentsBundle(
      customers: _list(map['customers']),
      organization: _list(map['organization']),
      guarantors: _list(map['guarantors']),
      service: _list(map['service']),
      iscoreDocs: _list(map['iscoreDocs']),
    );
  }

  PersonalFundDocumentsBundle withRefusalDocIds(Iterable<dynamic> docIds) {
    final ids = docIds.map((e) => '$e').toSet();
    if (ids.isEmpty) {
      return copyWithAllDisabled();
    }
    return PersonalFundDocumentsBundle(
      customers: _enableOnly(customers, ids, enableAll: false),
      organization: _enableOnly(organization, ids, enableAll: false),
      guarantors: _enableOnly(guarantors, ids, enableAll: false),
      service: _enableOnly(service, ids, enableAll: false),
      iscoreDocs: _enableOnly(iscoreDocs, ids, enableAll: false),
    );
  }

  PersonalFundDocumentsBundle copyWithAllDisabled() {
    return PersonalFundDocumentsBundle(
      customers: _setEnabled(customers, false),
      organization: _setEnabled(organization, false),
      guarantors: _setEnabled(guarantors, false),
      service: _setEnabled(service, false),
      iscoreDocs: _setEnabled(iscoreDocs, false),
    );
  }

  static List<Map<String, dynamic>> _list(dynamic value) {
    if (value is! List) return const [];
    return value
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  static List<Map<String, dynamic>> _setEnabled(
    List<Map<String, dynamic>> docs,
    bool enabled,
  ) {
    return [
      for (final d in docs)
        {...d, 'docEnabled': enabled ? 'Y' : 'N'},
    ];
  }

  static List<Map<String, dynamic>> _enableOnly(
    List<Map<String, dynamic>> docs,
    Set<String> ids, {
    required bool enableAll,
  }) {
    return [
      for (final d in docs)
        {
          ...d,
          'docEnabled': ids.contains('${d['docId']}') ? 'Y' : 'N',
        },
    ];
  }

  static const sections = <({String key, String title})>[
    (key: 'customers', title: 'مستندات العميل'),
    (key: 'organization', title: 'مستندات المنشأة'),
    (key: 'guarantors', title: 'مستندات الضامن'),
    (key: 'service', title: 'مستندات التمويل'),
    (key: 'iscoreDocs', title: 'i-Score'),
  ];

  List<Map<String, dynamic>> section(String key) {
    switch (key) {
      case 'customers':
        return customers;
      case 'organization':
        return organization;
      case 'guarantors':
        return guarantors;
      case 'service':
        return service;
      case 'iscoreDocs':
        return iscoreDocs;
      default:
        return const [];
    }
  }
}
