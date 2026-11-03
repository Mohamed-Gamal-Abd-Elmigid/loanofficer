/// Parses Fusion `wf/{wfCode}/step/{stepId}/authority` (tabs + field rules).
class FundWorkflowAuthority {
  FundWorkflowAuthority({this.raw = const {}});

  final Map<String, dynamic> raw;

  factory FundWorkflowAuthority.fromMap(Map<String, dynamic>? map) {
    return FundWorkflowAuthority(raw: map ?? const {});
  }

  /// Tab shown when listed in [visibleTabs] (same as web `checkTabRole` / visibleTabs).
  bool tabVisible(String tabRoleId) {
    final tabs = raw['visibleTabs'];
    if (tabs is! List || tabs.isEmpty) return true;
    for (final item in tabs) {
      if (item is Map && '${item['tabId']}' == tabRoleId) return true;
    }
    return false;
  }

  /// Tab editable when listed in [enabledTabs] (web edit/save buttons use `!checkTabRole(..., enabledTabs)`).
  bool tabEditable(String tabRoleId) {
    final tabs = raw['enabledTabs'];
    if (tabs is! List) return false;
    for (final item in tabs) {
      if (item is Map && '${item['tabId']}' == tabRoleId) return true;
    }
    return false;
  }

  /// Outer tab «الضمانات»; inner sections use [RT_GUARANTORS] / [RT_GUARANTEES].
  bool get warrantiesTab => tabVisible('RT_GRANTS');
  bool get documentsTab => tabVisible('RT_DOCS');
  bool get refusalTab => tabVisible('RT_REJECTS');
  bool get customerDataTab => tabVisible('RT_CUST');
  bool get organizationTab => tabVisible('RT_ORG');
  bool get fieldVisitTab => tabVisible('RT_CUST_VISIT');
  bool get guarantorVisitTab => tabVisible('RT_GUARANTOR_VISIT');
  bool get followUpTab => tabVisible('RT_FOLLOW_UP');
  bool get finalApprovalTab => tabVisible('RT_FINAL');
  bool get segmentationTab =>
      '${raw['segmentationFlag'] ?? ''}'.toUpperCase() == 'Y' &&
      tabVisible('RT_SEGMENTS');

  bool controlVisible(String tabRoleId, String controlPath) {
    final field = _fieldRule(tabRoleId, controlPath);
    if (field == null) return true;
    final visible = _prop(field, ['visibleProperty', 'visible'], 'Y');
    return visible.toUpperCase() != 'N';
  }

  bool controlEditable(String tabRoleId, String controlPath) {
    if (!tabEditable(tabRoleId)) return false;
    final field = _fieldRule(tabRoleId, controlPath);
    if (field == null) return true;
    if (!controlVisible(tabRoleId, controlPath)) return false;
    final edit = _prop(field, ['editProperty', 'edit', 'enabledProperty'], 'Y');
    return edit.toUpperCase() != 'N';
  }

  /// Fusion authority `buttons[]` (`btnId`, `visibleProperty === 'Y'`).
  bool actionVisible(String btnId) {
    final buttons = raw['buttons'];
    if (buttons is! List) return false;
    for (final item in buttons) {
      if (item is! Map) continue;
      if ('${item['btnId']}' != btnId) continue;
      return _prop(Map<String, dynamic>.from(item), ['visibleProperty'], 'N')
              .toUpperCase() ==
          'Y';
    }
    return false;
  }

  List<Map<String, dynamic>> get visibleActions {
    final buttons = raw['buttons'];
    if (buttons is! List) return const [];
    final out = <Map<String, dynamic>>[];
    for (final item in buttons) {
      if (item is! Map) continue;
      final map = Map<String, dynamic>.from(item);
      if (actionVisible('${map['btnId']}')) out.add(map);
    }
    return out;
  }

  /// Field rules declared on [enabledTabs] for a tab (web `FormAuthorityService`).
  List<Map<String, dynamic>> tabFieldRules(String tabRoleId) {
    final tab = _enabledTab(tabRoleId);
    if (tab == null) return const [];
    final fields = tab['fields'] ?? tab['controls'] ?? tab['fieldList'];
    if (fields is! List) return const [];
    return [
      for (final item in fields)
        if (item is Map) Map<String, dynamic>.from(item),
    ];
  }

  Map<String, dynamic>? _fieldRule(String tabRoleId, String controlPath) {
    final tab = _enabledTab(tabRoleId);
    if (tab == null) return null;
    final fields = tab['fields'] ?? tab['controls'] ?? tab['fieldList'];
    if (fields is! List) return null;
    for (final item in fields) {
      if (item is! Map) continue;
      final field = Map<String, dynamic>.from(item);
      final id = _prop(field, ['fieldId', 'controlName', 'fieldName'], '');
      if (id.isEmpty) continue;
      if (id == controlPath ||
          id.endsWith(controlPath) ||
          controlPath.endsWith(id)) {
        return field;
      }
    }
    return null;
  }

  Map<String, dynamic>? _enabledTab(String tabRoleId) {
    final tabs = raw['enabledTabs'];
    if (tabs is! List) return null;
    for (final item in tabs) {
      if (item is Map && '${item['tabId']}' == tabRoleId) {
        return Map<String, dynamic>.from(item);
      }
    }
    return null;
  }

  static String _prop(
    Map<String, dynamic> map,
    List<String> keys,
    String fallback,
  ) {
    for (final key in keys) {
      final v = map[key];
      if (v != null && '$v'.trim().isNotEmpty) return '$v'.trim();
    }
    return fallback;
  }
}
