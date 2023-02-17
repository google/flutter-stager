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
    this.valueDisplayBuilder,
  });

  /// The name of the value being manipulated.
  final Widget title;

  /// The current value.
  final num value;

  /// Executed when the increment button is pressed.
  final VoidCallback onDecrementPressed;

  /// Executed when the decrement button is pressed.
  final VoidCallback onIncrementPressed;

  /// Used to customize how the [value] is displayed in the
  /// [EnvironmentControlPanel].
  final String Function(num)? valueDisplayBuilder;

  String get _displayValue {
    if (valueDisplayBuilder != null) {
      return valueDisplayBuilder!(value);
    }

    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        title,
        IconButton(
          onPressed: onDecrementPressed,
          icon: const Icon(Icons.remove),
        ),
        Text(_displayValue),
        IconButton(
          onPressed: onIncrementPressed,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
