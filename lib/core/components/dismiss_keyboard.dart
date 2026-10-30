import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DismissKeyboard extends StatefulWidget {
  const DismissKeyboard({super.key, required this.child});

  final Widget child;

  @override
  State<DismissKeyboard> createState() => _DismissKeyboardState();
}

class _DismissKeyboardState extends State<DismissKeyboard> {
  Offset? _down;
  bool _dragged = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) {
        _down = event.position;
        _dragged = false;
      },
      onPointerMove: (event) {
        final start = _down;
        if (start == null || _dragged) return;
        if ((event.position - start).distance > kTouchSlop) {
          _dragged = true;
        }
      },
      onPointerUp: (event) {
        final dragged = _dragged;
        _down = null;
        _dragged = false;
        if (!dragged) _dismissIfOutside(event.position);
      },
      onPointerCancel: (_) {
        _down = null;
        _dragged = false;
      },
      child: widget.child,
    );
  }

  void _dismissIfOutside(Offset position) {
    final focus = FocusManager.instance.primaryFocus;
    if (focus == null || !focus.hasFocus) return;

    final media = MediaQuery.maybeOf(context);
    if (media != null && media.viewInsets.bottom > 0) {
      final keyboardTop = media.size.height - media.viewInsets.bottom;
      if (position.dy >= keyboardTop) return;
    }

    final renderObject = focus.context?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) return;
    final local = renderObject.globalToLocal(position);
    if (renderObject.size.contains(local)) return;

    focus.unfocus();
  }
}
