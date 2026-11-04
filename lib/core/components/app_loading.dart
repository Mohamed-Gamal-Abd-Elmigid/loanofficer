import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:loanofficer/core/theme/app_colors.dart';

/// API helper. Prefer screen-local spinners when opening a page.
///
/// - [watch] — runs the action with **no** global overlay (avoids double loaders).
/// - [blocking] — full-screen overlay for saves/submits that have no local spinner.
class AppLoading {
  AppLoading._();

  static final ValueNotifier<int> pending = ValueNotifier<int>(0);

  /// Runs [action] without the global overlay.
  static Future<T> watch<T>(Future<T> Function() action) {
    return _run(action);
  }

  /// Full-screen loader for mutations (save / approve / delete, …).
  static Future<T> blocking<T>(Future<T> Function() action) {
    final phase = SchedulerBinding.instance.schedulerPhase;
    final building =
        phase == SchedulerPhase.persistentCallbacks ||
        phase == SchedulerPhase.midFrameMicrotasks;
    if (!building) return _blockNow(action);

    final result = Completer<T>();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _blockNow(action).then(
        result.complete,
        onError: (Object error, StackTrace stack) {
          result.completeError(error, stack);
        },
      );
    });
    return result.future;
  }

  static Future<T> _run<T>(Future<T> Function() action) => action();

  static Future<T> _blockNow<T>(Future<T> Function() action) async {
    pending.value++;
    try {
      return await action();
    } finally {
      if (pending.value > 0) pending.value--;
    }
  }
}

class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: AppLoading.pending,
      builder: (context, count, _) {
        final loading = count > 0;
        return Stack(
          children: [
            child,
            if (loading)
              const Positioned.fill(
                child: AbsorbPointer(
                  child: ColoredBox(
                    color: Color(0x66FFFFFF),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
