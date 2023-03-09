/*
 Copyright 2023 Google LLC

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

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
