import 'package:flutter/material.dart';

import '../environment_option.dart';

/// TODO
class BooleanControl extends StatelessWidget {
  /// TODO
  const BooleanControl({
    super.key,
    required this.title,
    required this.isOn,
    required this.onChanged,
  });

  /// TODO
  factory BooleanControl.fromEnvironmentValue(EnvironmentValue<bool> value) {
    return BooleanControl(
      title: Text(value.option.name),
      isOn: value.notifier.value,
      onChanged: (bool newValue) {
        value.notifier.value = !value.notifier.value;
      },
    );
  }

  /// TODO
  final Widget title;

  /// TODO
  final bool isOn;

  /// TODO
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        title,
        Switch(
          value: isOn,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
