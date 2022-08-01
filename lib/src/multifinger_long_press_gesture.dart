import 'dart:async';

import 'package:flutter/material.dart';

class MultiTouchLongPressGestureDetector extends StatefulWidget {
  /// How long the user must hold down before the gesture is detected.
  ///
  /// Defaults to 1 second;
  final Duration longPressDelay;

  /// How many fingers are required to trigger this gesture
  final int numberOfTouches;

  /// Executed when the multi-touch long press gesture has been recognized.
  final VoidCallback onGestureDetected;

  final Widget child;

  const MultiTouchLongPressGestureDetector({
    super.key,
    this.longPressDelay = const Duration(seconds: 1),
    required this.numberOfTouches,
    required this.onGestureDetected,
    required this.child,
  });

  @override
  State<MultiTouchLongPressGestureDetector> createState() =>
      _MultiTouchLongPressGestureDetectorState();
}

class _MultiTouchLongPressGestureDetectorState
    extends State<MultiTouchLongPressGestureDetector> {
  Completer<bool>? _gestureHoldCompleter;

  Future<void> _tryToRecognizeGesture() async {
    _gestureHoldCompleter = Completer();
    await Future.delayed(widget.longPressDelay);
    if (_gestureHoldCompleter != null && !_gestureHoldCompleter!.isCompleted) {
      widget.onGestureDetected();
      _gestureHoldCompleter?.complete(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // scaling callbacks are used as a way to retrieve the number of fingers
      // a user is tapping with
      onScaleStart: (details) {
        if (details.pointerCount != widget.numberOfTouches) {
          print('pointer count ${details.pointerCount} does not match required '
              'number of touches ${widget.numberOfTouches}');
          return;
        }

        _tryToRecognizeGesture();
      },
      onScaleEnd: (_) {
        _gestureHoldCompleter = null;
      },
      child: widget.child,
    );
  }
}
