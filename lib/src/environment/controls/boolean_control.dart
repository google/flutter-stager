import 'package:flutter/material.dart';

import '../environment_control_panel.dart';
import 'environment_control.dart';

/// An [EnvironmentControl] for the manipulation of a boolean [EnvironmentState]
/// variable.
class BooleanControl extends EnvironmentControl<bool> {
  /// An [EnvironmentControl] for the manipulation of a boolean [EnvironmentState]
  /// variable.
  BooleanControl({
    required super.title,
    required super.stateKey,
    required super.defaultValue,
    super.environmentState,
  });

  @override
  Widget builder(
    BuildContext context,
    bool? currentValue,
    void Function(bool) updateValue,
  ) {
    return Row(
      key: ValueKey<String>(stateKey),
      children: <Widget>[
        SizedBox(
          width: EnvironmentControlPanel.labelWidth,
          child: Text(title),
        ),
        Switch(
          value: currentValue ?? false,
          onChanged: updateValue,
        ),
      ],
    );
  }
}
