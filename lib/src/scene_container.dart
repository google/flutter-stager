import 'dart:math';

import 'package:flutter/material.dart';

import 'control_panel/environment_control_panel.dart';
import 'environment_option.dart';
import 'multifinger_long_press_gesture_detector.dart';
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
  late final EnvironmentOption<bool> darkModeEnvironmentOption =
      EnvironmentOption<bool>(
    name: 'Dark Mode',
    initialValue: false,
    onValueChanged: (bool newValue) {
      _isDarkMode = newValue;
    },
  );

  Widget buildPanelButton(
    BuildContext context,
    EnvironmentValue<dynamic> environmentValue,
  ) {
    if (environmentValue is EnvironmentValue<bool>) {
      return buildBoolPanelButton(context, environmentValue);
      // } else if (environmentValue is EnvironmentValue<int>) {
      //   return IntPanelButton(environmentValue: environmentValue)
    } else {
      return buildDropDown(context, environmentValue);
    }
  }

  Widget buildDropDown(BuildContext context, EnvironmentValue<dynamic> value) {
    return DropdownButton<dynamic>(
      items: TargetPlatform.values
          .map(
            (TargetPlatform e) => DropdownMenuItem<TargetPlatform>(
              value: e,
              child: Text(e.name),
            ),
          )
          .toList(),
      onChanged: (dynamic newValue) => setState(() {
        value.option.onValueChanged(newValue);
      }),
      value: value.notifier.value,
    );
  }

  Widget buildBoolPanelButton(
    BuildContext context,
    EnvironmentValue<bool> environmentValue,
  ) {
    return IconButton(
      onPressed: () {
        environmentValue.notifier.value = !environmentValue.notifier.value;
      },
      icon: const Icon(Icons.light_mode),
    );
  }

  bool _isControlPanelExpanded = false;
  double _textScale = 1;
  bool _isDarkMode = false;
  bool _showSemantics = false;
  TargetPlatform? _targetPlatform;

  List<EnvironmentValue<dynamic>> _environmentValues =
      <EnvironmentValue<dynamic>>[];

  @override
  void initState() {
    super.initState();

    widget.scene.rebuildScene = () => setState(() {});

    _environmentValues = <EnvironmentValue<dynamic>>[
      darkModeEnvironmentOption.makeEnvironmentValue(),
    ];

    _environmentValues.addAll(
      widget.scene.environmentOptions
          .map((EnvironmentOption<dynamic> e) => e.makeEnvironmentValue()),
    );

    for (final EnvironmentValue<dynamic> environmentValue
        in _environmentValues) {
      environmentValue.notifier.addListener(() {
        // environmentValue.option.onValueChanged(environmentValue.notifier.value);
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double panelWidth = min(MediaQuery.of(context).size.width * 0.8, 350);
    return MultiTouchLongPressGestureDetector(
      numberOfTouches: 2,
      onGestureDetected: () => setState(() {
        setState(() {
          _isControlPanelExpanded = !_isControlPanelExpanded;
        });
      }),
      child: Material(
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: _textScale,
                platformBrightness:
                    _isDarkMode ? Brightness.dark : Brightness.light,
              ),
              child: Theme(
                data: Theme.of(context).copyWith(platform: _targetPlatform),
                child: _showSemantics
                    ? SemanticsDebugger(child: widget.scene.build())
                    : widget.scene.build(),
              ),
            ),
            Container(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              transform: Matrix4.translationValues(
                _isControlPanelExpanded ? 0 : -panelWidth,
                0,
                0,
              ),
              child: SafeArea(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: panelWidth,
                      child: EnvironmentControlPanel(
                        targetPlatform: _targetPlatform,
                        children: <Widget>[
                          ..._environmentValues.map(
                            (EnvironmentValue<dynamic> e) =>
                                buildPanelButton(context, e),
                          ),
                          ...widget.scene.environmentOptionBuilders.map(
                            (WidgetBuilder builder) => builder(context),
                          ),
                          IconButton(
                            onPressed: () => setState(() {
                              _textScale -= 0.1;
                            }),
                            icon: const Icon(Icons.text_decrease),
                          ),
                          IconButton(
                            onPressed: () => setState(() {
                              _textScale += 0.1;
                            }),
                            icon: const Icon(Icons.text_increase),
                          ),
                          IconButton(
                            onPressed: () => setState(() {
                              _showSemantics = !_showSemantics;
                            }),
                            icon: const Icon(Icons.shelves),
                          ),
                          DropdownButton<TargetPlatform>(
                            items: TargetPlatform.values
                                .map(
                                  (TargetPlatform e) =>
                                      DropdownMenuItem<TargetPlatform>(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (TargetPlatform? newValue) =>
                                setState(() {
                              if (newValue != null) {
                                _targetPlatform = newValue;
                              }
                            }),
                            value:
                                _targetPlatform ?? Theme.of(context).platform,
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                      onPressed: () {
                        setState(() {
                          _isControlPanelExpanded = !_isControlPanelExpanded;
                        });
                      },
                      child: Icon(
                        _isControlPanelExpanded
                            ? Icons.arrow_back
                            : Icons.arrow_forward,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
