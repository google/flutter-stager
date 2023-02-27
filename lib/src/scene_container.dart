import 'dart:math';

import 'package:flutter/material.dart';

import 'control_panel/boolean_control.dart';
import 'control_panel/display_size_picker.dart';
import 'control_panel/dropdown_control.dart';
import 'control_panel/environment_control_panel.dart';
import 'control_panel/stepper_control.dart';
import 'scene.dart';

/// Wraps [child] in a MediaQuery whose properties (such as textScale and
/// brightness) are editable using an on-screen widget.
///
/// The environment editing widget can be toggled using a two-finger long press.
class SceneContainer extends StatefulWidget {
  /// Creates a [SceneContainer].
  const SceneContainer({
    super.key,
    required this.scene,
  });

  /// The [Scene] being displayed.
  final Scene scene;

  @override
  State<SceneContainer> createState() => _SceneContainerState();
}

class _SceneContainerState extends State<SceneContainer> {
  static const Duration _panelAnimationDuration = Duration(milliseconds: 250);
  static const double _panelDividerWidth = 1;

  Key _containerKey = UniqueKey();
  bool _isControlPanelExpanded = false;
  double _textScale = 1;
  bool _isDarkMode = false;
  bool _isTextBold = false;
  bool _showSemantics = false;
  TargetPlatform? _targetPlatform;
  num? _heightOverride;
  num? _widthOverride;

  void _rebuildScene() {
    // Create a new UniqueKey to force recreation of StatefulWidgets' states.
    setState(() => _containerKey = UniqueKey());
  }

  double get _panelWidth => min(MediaQuery.of(context).size.width * 0.75, 300);
  bool get isSmallScreen => MediaQuery.of(context).size.width < 600;

  Size get _defaultSceneSize {
    final Size viewportSize = MediaQuery.of(context).size;
    return isSmallScreen
        ? viewportSize
        : Size(
            viewportSize.width - _panelWidth - _panelDividerWidth,
            viewportSize.height,
          );
  }

  double get _sceneHeight {
    return _heightOverride?.toDouble() ?? MediaQuery.of(context).size.height;
  }

  double get _sceneWidth {
    if (_widthOverride != null) {
      return _widthOverride!.toDouble();
    }

    final double screenWidth = MediaQuery.of(context).size.width;

    if (isSmallScreen) {
      return screenWidth;
    }

    return screenWidth - _panelWidth - _panelDividerWidth;
  }

  Widget _panel() {
    return SizedBox(
      width: _panelWidth,
      child: EnvironmentControlPanel(
        targetPlatform: _targetPlatform,
        children: <Widget>[
          if (Navigator.of(context).canPop())
            IconButton(
              key: const ValueKey<String>('PopToSceneListButton'),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              icon: const Icon(Icons.arrow_back),
            ),
          BooleanControl(
            key: const ValueKey<String>(
              'ToggleDarkModeControl',
            ),
            title: const Text('Dark Mode'),
            isOn: _isDarkMode,
            onChanged: (bool newValue) {
              setState(() {
                _isDarkMode = newValue;
              });
            },
          ),
          BooleanControl(
            key: const ValueKey<String>(
              'ToggleBoldTextControl',
            ),
            title: const Text('Bold Text'),
            isOn: _isTextBold,
            onChanged: (bool newValue) {
              setState(() {
                _isTextBold = newValue;
              });
            },
          ),
          BooleanControl(
            key: const ValueKey<String>(
              'ToggleSemanticsOverlayControl',
            ),
            title: const Text('Semantics'),
            isOn: _showSemantics,
            onChanged: (bool newValue) {
              setState(() {
                _showSemantics = newValue;
              });
            },
          ),
          StepperControl(
            key: const ValueKey<String>(
              'TextScaleStepperControl',
            ),
            title: const Text('Text Scale'),
            value: _textScale.toStringAsFixed(1),
            onDecrementPressed: () => setState(() {
              _textScale -= 0.1;
            }),
            onIncrementPressed: () => setState(() {
              _textScale += 0.1;
            }),
          ),
          DisplaySizePicker(
            defaultSize: _defaultSceneSize,
            didChangeSize: (num? width, num? height) {
              setState(() {
                _widthOverride = width;
                _heightOverride = height;
              });
            },
          ),
          DropdownControl<TargetPlatform>(
            title: const SizedBox(
              width: EnvironmentControlPanel.labelWidth,
              child: Text('Target Platform'),
            ),
            items: TargetPlatform.values,
            onChanged: (TargetPlatform? newValue) => setState(() {
              if (newValue != null) {
                _targetPlatform = newValue;
              }
            }),
            value: _targetPlatform ?? Theme.of(context).platform,
            itemTitleBuilder: (TargetPlatform platform) => platform.name,
          ),
          ...widget.scene.environmentControlBuilders
              .map((EnvironmentControlBuilder builder) {
            return builder(context, _rebuildScene);
          }),
        ],
      ),
    );
  }

  Widget _sceneWrapper() {
    return MediaQuery(
      key: const ValueKey<String>('SceneContainerMediaQuery'),
      data: MediaQuery.of(context).copyWith(
        boldText: _isTextBold,
        textScaleFactor: _textScale,
        platformBrightness: _isDarkMode ? Brightness.dark : Brightness.light,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(platform: _targetPlatform),
        child: SizedBox(
          key: _containerKey,
          width: _sceneWidth,
          height: _sceneHeight,
          child: ClipRect(
            child: _showSemantics
                ? SemanticsDebugger(child: widget.scene.build())
                : widget.scene.build(),
          ),
        ),
      ),
    );
  }

  /// A layout for narrower screens that makes the [EnvironmentControlPanel]
  /// collapsible.
  Widget _smallScreenLayout() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        _sceneWrapper(),
        AnimatedContainer(
          padding: EdgeInsets.zero,
          alignment: Alignment.centerLeft,
          transform: Matrix4.translationValues(
            _isControlPanelExpanded ? 0 : -_panelWidth,
            0,
            0,
          ),
          duration: _panelAnimationDuration,
          curve: Curves.easeOutCubic,
          child: SafeArea(
            child: Row(
              children: <Widget>[
                _panel(),
                MaterialButton(
                  key: const ValueKey<String>(
                    'ToggleEnvironmentControlPanelButton',
                  ),
                  color: Colors.white,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                  onPressed: () {
                    setState(() {
                      _isControlPanelExpanded = !_isControlPanelExpanded;
                    });
                  },
                  child: AnimatedRotation(
                    duration: _panelAnimationDuration,
                    turns: _isControlPanelExpanded ? 0.5 : 0.0,
                    child: const Icon(Icons.arrow_forward),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// A master-detail layout that makes the [EnvironmentControlPanel]
  /// non-collapsible.
  Widget _largeScreenLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SafeArea(
          child: _panel(),
        ),
        const VerticalDivider(width: _panelDividerWidth),
        const Spacer(),
        Center(
          child: _sceneWrapper(),
        ),
        const Spacer(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: isSmallScreen ? _smallScreenLayout() : _largeScreenLayout(),
    );
  }
}
