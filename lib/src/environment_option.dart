import 'package:flutter/material.dart';

/// TODO
class EnvironmentOption<T> {
  /// TODO
  EnvironmentOption({
    required this.name,
    required this.initialValue,
    required this.onValueChanged,
    this.icon,
    //   required this.panelItemBuilder,
  });

  /// TODO
  final String name;

  /// TODO
  final T initialValue;

  /// TODO
  final Icon? icon;

  /// TODO
  final Function(T) onValueChanged;

  /// TODO
  EnvironmentValue<T> makeEnvironmentValue() => EnvironmentValue<T>(this);
}

/// TODO
class EnvironmentValue<T> {
  /// TODO
  EnvironmentValue(this.option) {
    notifier = ValueNotifier<T>(this.option.initialValue);
    notifier.addListener(() {
      option.onValueChanged(notifier.value);
    });
  }

  /// The option that this value is manipulating.
  final EnvironmentOption<T> option;

  /// Notifies when the value of this [EnvironmentValue] has changed.
  late ValueNotifier<T> notifier;
}
