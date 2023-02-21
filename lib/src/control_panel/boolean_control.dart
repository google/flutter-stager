import 'package:flutter/material.dart';

import 'environment_control_panel.dart';

/// An [EnvironmentControlPanel] widget that allows a user to toggle an
/// arbitrary environment value.
class BooleanControl extends StatelessWidget {
  /// An [EnvironmentControlPanel] widget that allows a user to toggle an
  /// arbitrary environment value.
  const BooleanControl({
    super.key,
    required this.title,
    required this.isOn,
    required this.onChanged,
  });

  /// The name of the value being controlled.
  final Widget title;

  /// Whether the value is toggled on or not.
  final bool isOn;

  /// Called when the [Switch] is toggled.
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: EnvironmentControlPanel.labelWidth,
          child: title,
        ),
        Switch(
          value: isOn,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
