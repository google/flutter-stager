import 'package:flutter/material.dart';

import '../environment_control_panel.dart';
import 'environment_control.dart';

/// A control to manipulate String [EnvironmentState] values.
class TextInputControl extends EnvironmentControl<String?> {
  /// A control to manipulate String [EnvironmentState] values.
  TextInputControl({
    required super.title,
    required super.stateKey,
    required super.defaultValue,
    super.onValueUpdated,
    super.environmentState,
  });

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void updateValue(String? newValue) {
    super.updateValue(newValue);

    if (!_focusNode.hasFocus) {
      _textEditingController.text = newValue ?? '';
    }
  }

  void _onTextChanged(String newValue) {
    updateValue(newValue);
  }

  @override
  Widget builder(
    BuildContext context,
    String? currentValue,
    void Function(String) updateValue,
  ) {
    return Row(
      key: ValueKey<String>(stateKey),
      children: <Widget>[
        SizedBox(
          width: EnvironmentControlPanel.labelWidth,
          child: Text(title),
        ),
        Expanded(
          child: TextField(
            controller: _textEditingController,
            focusNode: _focusNode,
            onChanged: _onTextChanged,
          ),
        ),
      ],
    );
  }
}
