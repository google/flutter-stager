import 'package:flutter/material.dart';

/// An [EnvironmentControlPanel] widget that allows a user to toggle an
/// arbitrary environment value.
class BooleanControl extends StatelessWidget {
  /// TODO
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
        title,
        Switch(
          value: isOn,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
