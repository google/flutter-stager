import 'package:flutter/material.dart';

/// TODO
class TextScaler extends StatelessWidget {
  /// TODO
  const TextScaler({
    super.key,
    required this.textScale,
    required this.onDecrementPressed,
    required this.onIncrementPressed,
  });

  /// TODO
  final double textScale;

  /// TODO
  final VoidCallback onDecrementPressed;

  /// TODO
  final VoidCallback onIncrementPressed;

  String get _displayTextScale => textScale.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: onDecrementPressed,
          icon: const Icon(Icons.text_decrease),
        ),
        Text(
          _displayTextScale,
          textScaleFactor: 1.4,
        ),
        IconButton(
          onPressed: onIncrementPressed,
          icon: const Icon(Icons.text_increase),
        ),
      ],
    );
  }
}
