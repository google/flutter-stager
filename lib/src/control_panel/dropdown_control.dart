import 'package:flutter/material.dart';

/// TODO
class DropdownControl<T> extends StatelessWidget {
  /// TODO
  const DropdownControl({
    super.key,
    required this.title,
    required this.items,
    required this.onChanged,
    this.value,
    this.titleBuilder,
  });

  /// TODO
  final Widget title;

  /// TODO
  final List<T> items;

  /// TODO
  final void Function(T?) onChanged;

  /// TODO
  final T? value;

  /// TODO
  final String Function(T)? titleBuilder;

  String _titleForItem(T? item) {
    if (item == null) {
      return '';
    }

    if (titleBuilder == null) {
      return item.toString();
    }

    return titleBuilder!(item);
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
