import 'package:flutter/material.dart';

import '../environment_control_panel.dart';
import 'environment_control.dart';

/// An [EnvironmentControl] that allows the user to choose from one of several
/// options.
class DropdownControl<T> extends EnvironmentControl<T> {
  /// An [EnvironmentControl] that allows the user to choose from one of several
  /// options.
  DropdownControl({
    required super.title,
    required super.stateKey,
    required super.defaultValue,
    required this.items,
    super.onValueUpdated,
    this.itemTitleBuilder,
    super.environmentState,
  });

  /// A list of all available items.
  final List<T> items;

  String _titleForItem(T? item) {
    if (itemTitleBuilder != null) {
      return itemTitleBuilder!(item);
    }

    return item.toString();
  }

  /// Used to customize the text of [items] in the drop down. Use this when
  /// overriding [T.toString()] is not possible or not desirable.
  final String Function(T?)? itemTitleBuilder;

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
        Expanded(
          child: DropdownButton<T>(
            isExpanded: true,
            value: currentValue,
            items: items
                .map(
                  (T? e) => DropdownMenuItem<T>(
                    value: e,
                    child: Text(_titleForItem(e)),
                  ),
                )
                .toList(),
            onChanged: (T? newValue) {
              final T updatedValue = newValue ?? defaultValue;
              updateValue(updatedValue);
            },
          ),
        ),
      ],
    );
  }
}
