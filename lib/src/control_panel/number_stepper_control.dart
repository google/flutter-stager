import 'package:flutter/material.dart';

/// An [EnvironmentControlPanel] widget that allows a user to decrease and
/// increase a numerical value.
class NumberStepperControl extends StatelessWidget {
  /// An [EnvironmentControlPanel] widget that allows a user to decrease and
  /// increase a numerical value.
  const NumberStepperControl({
    super.key,
    required this.title,
    required this.value,
    required this.onDecrementPressed,
    required this.onIncrementPressed,
  });

  /// The name of the value being manipulated.
  final Widget title;

  /// The current value.
  final num value;

  /// Executed when the increment button is pressed.
  final VoidCallback onDecrementPressed;

  /// Executed when the decrement button is pressed.
  final VoidCallback onIncrementPressed;

  String get _displayTextScale => value.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        title,
        IconButton(
          onPressed: onDecrementPressed,
          icon: const Icon(Icons.remove),
        ),
        Text(
          _displayTextScale,
        ),
        IconButton(
          onPressed: onIncrementPressed,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
