import 'package:flutter/material.dart';

import '../extensions/string_extensions.dart';

/// Allows the user to input custom screen dimensions or to select from a list
/// of popular device presets.
class DisplaySizePicker extends StatefulWidget {
  /// TODO
  const DisplaySizePicker({super.key, required this.didChangeSize});

  /// Called when the width or height values are updated, either by text input
  /// or by the user selecting one of the [ScreenSizePreset]s.
  final void Function(double? width, double? height) didChangeSize;

  @override
  State<DisplaySizePicker> createState() => _DisplaySizePickerState();
}

class _DisplaySizePickerState extends State<DisplaySizePicker> {
  late final TextEditingController _heightTextEditingController;
  late final TextEditingController _widthTextEditingController;
  ScreenSizePreset? _selectedScreenSizePreset;

  double? get height {
    final String heightString = _heightTextEditingController.text;
    return heightString.isNullOrEmpty ? null : double.parse(heightString);
  }

  double? get width {
    final String widthString = _widthTextEditingController.text;
    return widthString.isNullOrEmpty ? null : double.parse(widthString);
  }

  @override
  void initState() {
    super.initState();
    _heightTextEditingController = TextEditingController();
    _widthTextEditingController = TextEditingController();

    _heightTextEditingController.addListener(
      () => widget.didChangeSize(width, height),
    );
    _widthTextEditingController.addListener(
      () => widget.didChangeSize(width, height),
    );
  }

  @override
  void dispose() {
    _widthTextEditingController.dispose();
    _heightTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: 75,
              child: TextField(
                controller: _widthTextEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Width'),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 75,
              child: TextField(
                controller: _heightTextEditingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Height'),
              ),
            ),
          ],
        ),
        DropdownButton<ScreenSizePreset>(
          items: ScreenSizePreset.all
              .map(
                (ScreenSizePreset e) => DropdownMenuItem<ScreenSizePreset>(
                  value: e,
                  child: Text(
                    '${e.name} (${e.size.width.toInt()} x ${e.size.height.toInt()})',
                  ),
                ),
              )
              .toList(),
          value: _selectedScreenSizePreset,
          onChanged: (ScreenSizePreset? newValue) {
            _selectedScreenSizePreset = newValue;
            if (newValue != null) {
              _heightTextEditingController.text =
                  newValue.size.height.toString();
              _widthTextEditingController.text = newValue.size.width.toString();
              widget.didChangeSize(width, height);
            }
          },
          // ),
        ),
      ],
    );
  }
}

/// A named screen size, usually a popular device and its logical pixel dimensions.
class ScreenSizePreset {
  /// TODO
  ScreenSizePreset({required this.name, required this.size});

  /// The device associated with [size].
  final String name;

  /// The logical height and width of the device.
  final Size size;

  static final ScreenSizePreset _iPhone14Plus = ScreenSizePreset(
    name: 'iPhone 14 Plus',
    size: const Size(429, 926),
  );

  static final ScreenSizePreset _iPadPro12_9 = ScreenSizePreset(
    name: 'iPad Pro 12.9"',
    size: const Size(1024, 1366),
  );

  static final ScreenSizePreset _iPadPro11 = ScreenSizePreset(
    name: 'iPad Pro 11"',
    size: const Size(834, 1194),
  );

  static final ScreenSizePreset _pixel6Pro = ScreenSizePreset(
    name: 'Pixel 6 Pro',
    size: const Size(360, 780),
  );

  static final ScreenSizePreset _verySmall = ScreenSizePreset(
    name: 'Very small',
    size: const Size(100, 100),
  );

  /// All available device size presets.
  static final List<ScreenSizePreset> all = <ScreenSizePreset>[
    _iPhone14Plus,
    _iPadPro12_9,
    _iPadPro11,
    _pixel6Pro,
    _verySmall,
  ];
}
