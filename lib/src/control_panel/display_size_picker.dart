import 'package:flutter/material.dart';

import '../extensions/string_extensions.dart';
import 'environment_control_panel.dart';

/// Allows the user to input custom screen dimensions or to select from a list
/// of popular device presets.
class DisplaySizePicker extends StatefulWidget {
  /// An [EnvironmentControlPanel] widget that allows the user to change the
  /// display dimensions of the current [Scene]. A user may select from one of
  /// several [ScreenSizePreset]s or manually enter width and height values.
  const DisplaySizePicker({
    super.key,
    required this.didChangeSize,
  });

  /// Called when the width or height values are updated, either by text input
  /// or by the user selecting one of the [ScreenSizePreset]s.
  final void Function(int? width, int? height) didChangeSize;

  @override
  State<DisplaySizePicker> createState() => _DisplaySizePickerState();
}

class _DisplaySizePickerState extends State<DisplaySizePicker> {
  late final TextEditingController _heightTextEditingController;
  late final TextEditingController _widthTextEditingController;
  ScreenSizePreset? _selectedScreenSizePreset;

  int? get height {
    final String heightString = _heightTextEditingController.text;
    return heightString.isNullOrEmpty ? null : int.parse(heightString);
  }

  int? get width {
    final String widthString = _widthTextEditingController.text;
    return widthString.isNullOrEmpty ? null : int.parse(widthString);
  }

  @override
  void initState() {
    super.initState();

    _heightTextEditingController = TextEditingController();
    _widthTextEditingController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Size screenSize = MediaQuery.of(context).size;
      setState(() {
        _heightTextEditingController.text =
            screenSize.height.toStringAsFixed(0);
        _widthTextEditingController.text = screenSize.width.toStringAsFixed(0);
      });
    });

    _heightTextEditingController.addListener(
      () => widget.didChangeSize(width, height),
    );
    _widthTextEditingController.addListener(
      () => widget.didChangeSize(width, height),
    );
  }

  @override
  void dispose() {
    _heightTextEditingController.dispose();
    _widthTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(
          width: EnvironmentControlPanel.labelWidth,
          child: Text('Screen Size'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 75,
                    child: TextField(
                      key: const ValueKey<String>('DisplayWidthTextField'),
                      controller: _widthTextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: 'Width'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 75,
                    child: TextField(
                      key: const ValueKey<String>('DisplayHeightTextField'),
                      controller: _heightTextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: 'Height'),
                    ),
                  ),
                ],
              ),
              DropdownButton<ScreenSizePreset>(
                key: const ValueKey<String>('ScreenSizePresetDropdown'),
                isExpanded: true,
                items: <DropdownMenuItem<ScreenSizePreset>>[
                  const DropdownMenuItem<ScreenSizePreset>(
                    child: Text('Current Window'),
                  ),
                  ...ScreenSizePreset.all.map(
                    (ScreenSizePreset e) => DropdownMenuItem<ScreenSizePreset>(
                      key: ValueKey<String>(e.name),
                      value: e,
                      child: Text(
                        '${e.name} (${e.size.width.toInt()} x ${e.size.height.toInt()})',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                value: _selectedScreenSizePreset,
                onChanged: (ScreenSizePreset? newValue) {
                  _selectedScreenSizePreset = newValue;
                  final Size newSize =
                      newValue?.size ?? MediaQuery.of(context).size;
                  _heightTextEditingController.text =
                      newSize.height.toStringAsFixed(0);
                  _widthTextEditingController.text =
                      newSize.width.toStringAsFixed(0);
                  widget.didChangeSize(width, height);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A named screen size, usually a popular device and its viewport dimensions.
class ScreenSizePreset {
  /// A named screen size, usually a popular device and its viewport dimensions.
  const ScreenSizePreset({required this.name, required this.size});

  /// The device associated with [size].
  final String name;

  /// The logical height and width of the device.
  final Size size;

  static const ScreenSizePreset _galaxyA51_71 = ScreenSizePreset(
    name: 'Galaxy A51/71',
    size: Size(412, 914),
  );

  static const ScreenSizePreset _galaxyFold = ScreenSizePreset(
    name: 'Galaxy Fold',
    size: Size(280, 653),
  );

  static const ScreenSizePreset _galaxyS20Ultra = ScreenSizePreset(
    name: 'Galaxy S20 Ultra',
    size: Size(412, 915),
  );

  static const ScreenSizePreset _galaxyS8Plus = ScreenSizePreset(
    name: 'Galaxy S8+',
    size: Size(360, 740),
  );

  static const ScreenSizePreset _iPadAir = ScreenSizePreset(
    name: 'iPad Air',
    size: Size(820, 1180),
  );

  static const ScreenSizePreset _iPadMini = ScreenSizePreset(
    name: 'iPad Mini',
    size: Size(768, 1024),
  );

  static const ScreenSizePreset _iPadPro11 = ScreenSizePreset(
    name: 'iPad Pro 11"',
    size: Size(834, 1194),
  );

  static const ScreenSizePreset _iPadPro12_9 = ScreenSizePreset(
    name: 'iPad Pro 12.9"',
    size: Size(1024, 1366),
  );

  static const ScreenSizePreset _iPhone12Pro = ScreenSizePreset(
    name: 'iPhone 12 Pro',
    size: Size(390, 844),
  );

  static const ScreenSizePreset _iPhone14Plus = ScreenSizePreset(
    name: 'iPhone 14 Plus',
    size: Size(429, 926),
  );

  static const ScreenSizePreset _iPhoneSE = ScreenSizePreset(
    name: 'iPhone SE',
    size: Size(375, 667),
  );

  static const ScreenSizePreset _pixel5 = ScreenSizePreset(
    name: 'Pixel 5',
    size: Size(393, 851),
  );

  static const ScreenSizePreset _pixel6Pro = ScreenSizePreset(
    name: 'Pixel 6 Pro',
    size: Size(360, 780),
  );

  static const ScreenSizePreset _surfacePro7 = ScreenSizePreset(
    name: 'Surface Pro 7',
    size: Size(912, 1368),
  );

  /// All available device size presets.
  static const List<ScreenSizePreset> all = <ScreenSizePreset>[
    _galaxyA51_71,
    _galaxyFold,
    _galaxyS20Ultra,
    _galaxyS8Plus,
    _iPadAir,
    _iPadMini,
    _iPadPro11,
    _iPadPro12_9,
    _iPhone12Pro,
    _iPhone14Plus,
    _iPhoneSE,
    _pixel5,
    _pixel6Pro,
    _surfacePro7,
  ];
}
