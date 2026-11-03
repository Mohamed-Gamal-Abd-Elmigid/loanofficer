import 'package:flutter/material.dart';
import 'package:loanofficer/core/api/fmc_session.dart';
import 'package:loanofficer/presenter/login/scene/login_scene.dart';

/// Root navigator — used when a 401 must leave the current stack.
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

bool _handlingUnauthorized = false;

/// Clears the local session and sends the user to login (once per burst).
Future<void> forceSessionExpiredLogout({
  String message = 'انتهت صلاحية الجلسة، سجّل الدخول مرة أخرى',
}) async {
  final token = FmcSession.instance.token?.trim() ?? '';
  if (token.isEmpty || _handlingUnauthorized) return;
  _handlingUnauthorized = true;
  try {
    await FmcSession.instance.clear();
    final nav = appNavigatorKey.currentState;
    if (nav == null) return;
    nav.pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScene()),
      (_) => false,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = appNavigatorKey.currentContext;
      if (ctx == null || !ctx.mounted) return;
      ScaffoldMessenger.of(ctx)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    });
  } finally {
    Future<void>.delayed(const Duration(seconds: 2), () {
      _handlingUnauthorized = false;
    });
  }
}
