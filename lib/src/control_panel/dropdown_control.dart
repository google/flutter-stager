import 'package:flutter/material.dart';

/// An [EnvironmentControlPanel] widget that allows the user to choose from one
/// of several options.
class DropdownControl<T> extends StatelessWidget {
  const DropdownControl({
    super.key,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
    this.itemTitleBuilder,
  });

  /// The name of this config option.
  final Widget title;

  /// The currently selected item.
  final T value;

  /// A list of all available items.
  final List<T> items;

  /// Called when a [value] is changed.
  final void Function(T?) onChanged;

  /// Used to customize the text of [items] in the drop down. Use this when
  /// overriding [T.toString()] is not possible or not desirable.
  final String Function(T)? itemTitleBuilder;

  String _titleForItem(T? item) {
    if (item == null) {
      return '';
    }

    if (itemTitleBuilder == null) {
      return item.toString();
    }

    return itemTitleBuilder!(item);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        title,
        const SizedBox(width: 8),
        DropdownButton<T>(
          value: value,
          items: items
              .map(
                (T? e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(_titleForItem(e)),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
