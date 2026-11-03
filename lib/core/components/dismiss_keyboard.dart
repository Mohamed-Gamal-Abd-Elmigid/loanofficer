import 'package:flutter/material.dart';

/// Tap outside the focused field (anywhere else in the app) to hide the keyboard.
/// Scrolling a list also dismisses the keyboard.
class DismissKeyboard extends StatelessWidget {
  const DismissKeyboard({super.key, required this.child});

  final Widget child;

  static bool _isOnFocusedField(Offset globalPosition) {
    final focus = FocusManager.instance.primaryFocus;
    if (focus == null || !focus.hasFocus) return false;

    final focusContext = focus.context;
    if (focusContext == null) return false;

    final renderObject = focusContext.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return false;

    final local = renderObject.globalToLocal(globalPosition);
    return renderObject.size.contains(local);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollStartNotification &&
            notification.dragDetails != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
        return false;
      },
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (event) {
          final focus = FocusManager.instance.primaryFocus;
          if (focus == null || !focus.hasFocus) return;
          if (_isOnFocusedField(event.position)) return;
          focus.unfocus();
        },
        child: child,
      ),
    );
  }
}
