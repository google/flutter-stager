import 'package:flutter/widgets.dart';

/// An observable key-value store containing values that control how Scenes are
/// presented, such as whether dark mode is enabled, whether bold text is
/// enabled, etc.
class EnvironmentState extends ChangeNotifier {
  /// Creates a new instance of [EnvironmentState] for testing purposes.
  factory EnvironmentState.forTest() => EnvironmentState._internal();

  EnvironmentState._internal();

  /// The [EnvironmentState] singleton.
  static EnvironmentState get instance => _instance;

  static final EnvironmentState _instance = EnvironmentState._internal();

  /// The number of font pixels for each logical pixel.
  static const String textScaleKey = 'EnvironmentState.textScale';

  /// Whether to use [Brightness.dark].
  static const String isDarkModeKey = 'EnvironmentState.isDarkMode';

  /// Whether text is drawn with a bold font weight.
  static const String isTextBoldKey = 'EnvironmentState.isTextBold';

  /// Whether a [SemanticsDebugger] is shown over the UI.
  ///
  /// NOTE: this may not behave as expected until
  /// https://github.com/flutter/flutter/issues/120615 is fixed.
  static const String showSemanticsKey = 'EnvironmentState.showSemantics';

  /// The platform that user interaction should adapt to target.
  ///
  /// If null, defaults to the current platform.
  static const String targetPlatformKey = 'EnvironmentState.targetPlatform';

  /// A custom vertical size value.
  ///
  /// If null, the current window/screen height will be used.
  static const String heightOverrideKey = 'EnvironmentState.heightOverride';

  /// A custom horizontal size value.
  ///
  /// If null, the current window/screen height will be used.
  static const String widthOverrideKey = 'EnvironmentState.widthOverride';

  /// A screen size preset
  ///
  /// If null, the current window/screen size will be used.
  static const String devicePreviewKey = 'EnvironmentState.devicePreviewKey';

  /// Stores current named environment state values.
  Map<String, dynamic> _stateMap = <String, dynamic>{};

  /// Stores default named environment state values.
  final Map<String, dynamic> _stateMapDefaults = <String, dynamic>{};

  /// Sets a default [value] for [key].
  ///
  /// Calling [EnvironmentState.reset] will set the current value for [key] to
  /// [value]. If a default has already been set for [key], it will be
  /// overwritten.
  void setDefault(String key, Object? value) {
    _stateMapDefaults[key] = value;

    if (!_stateMap.containsKey(key)) {
      _stateMap[key] = value;
    }
  }

  /// Returns the value corresponding to [key] if it exists.
  T? get<T>(String key) => _stateMap[key];

  /// Updates the environment value corresponding to [key].
  ///
  /// If no default has been set for this [key], [value] will be used as the
  /// default.
  void set(String key, dynamic value) {
    // If this key is new, use [value] as the default.
    if (!_stateMap.containsKey(key)) {
      _stateMapDefaults[key] = value;
    }

    _stateMap[key] = value;
    notifyListeners();
  }

  /// Resets all environment variables to their default state and notifies
  /// listeners.
  void reset() {
    _stateMap = Map<String, dynamic>.from(_stateMapDefaults);
    notifyListeners();
  }
}
