import 'package:flutter/material.dart';

import '../environment_control_panel.dart';
import 'environment_control.dart';

/// An [EnvironmentControlPanel] widget that allows a user to decrease and
/// increase a value.
class StepperControl<T> extends EnvironmentControl<T> {
  /// An [EnvironmentControlPanel] widget that allows a user to decrease and
  /// increase a value.
  StepperControl({
    required super.title,
    required super.stateKey,
    required super.defaultValue,
    required this.onDecrementPressed,
    required this.onIncrementPressed,
    super.onValueUpdated,
    this.displayValueBuilder,
    super.environmentState,
  });

  /// Executed when the increment button is pressed.
  final T Function(T currentValue) onDecrementPressed;

  /// Executed when the decrement button is pressed.
  final T Function(T currentValue) onIncrementPressed;

  /// Returns a presentable String representation of [currentValue].
  final String Function(T currentValue)? displayValueBuilder;

  String get _displayValue {
    if (displayValueBuilder != null) {
      return displayValueBuilder!(currentValue!);
    }

    return currentValue.toString();
  }

  @override
  Widget builder(
    BuildContext context,
    T? currentValue,
    void Function(T) updateValue,
  ) {
    return Row(
      key: ValueKey<String>(stateKey),
      children: <Widget>[
        SizedBox(
          width: EnvironmentControlPanel.labelWidth,
          child: Text(title),
        ),
        IconButton(
          // ignore: null_check_on_nullable_type_parameter
          onPressed: () => updateValue(onDecrementPressed(currentValue!)),
          icon: const Icon(Icons.remove),
        ),
        Text(_displayValue),
        IconButton(
          // ignore: null_check_on_nullable_type_parameter
          onPressed: () => updateValue(onIncrementPressed(currentValue!)),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
