
import 'package:flutter/material.dart';

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

  @override
  String toString() {
    return '$name (${size.width.toInt()} x ${size.height.toInt()})';
  }
}
