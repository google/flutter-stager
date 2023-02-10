import 'package:flutter/material.dart';

/// TODO
class NumberStepper extends StatelessWidget {
  /// TODO
  const NumberStepper({
    super.key,
    required this.title,
    required this.value,
    required this.onDecrementPressed,
    required this.onIncrementPressed,
  });

  final Widget title;

  /// TODO
  final double value;

  /// TODO
  final VoidCallback onDecrementPressed;

  /// TODO
  final VoidCallback onIncrementPressed;

  String get _displayTextScale => value.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        title,
        IconButton(
          onPressed: onDecrementPressed,
          icon: const Icon(Icons.text_decrease),
        ),
        Text(
          _displayTextScale,
        ),
        IconButton(
          onPressed: onIncrementPressed,
          icon: const Icon(Icons.text_increase),
        ),
      ],
    );
  }
}
