import 'dart:math';

import 'package:flutter/material.dart';

import 'control_panel/boolean_control.dart';
import 'control_panel/display_size_picker.dart';
import 'control_panel/dropdown_control.dart';
import 'control_panel/environment_control_panel.dart';
import 'control_panel/number_stepper_control.dart';
import 'environment_option.dart';
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

  late final EnvironmentOption<bool> semanticsOverlayOption =
      EnvironmentOption<bool>(
    name: 'Semantics',
    initialValue: false,
    onValueChanged: (bool newValue) {
      _showSemantics = newValue;
    },
  );

  Widget buildPanelButton(
    BuildContext context,
    EnvironmentValue<dynamic> environmentValue,
  ) {
    if (environmentValue is EnvironmentValue<bool>) {
      return BooleanControl.fromEnvironmentValue(environmentValue);
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

  bool _isControlPanelExpanded = false;
  double _textScale = 1;
  bool _isDarkMode = false;
  bool _showSemantics = false;
  TargetPlatform? _targetPlatform;
  double? _widthOverride;
  double? _heightOverride;

  List<EnvironmentValue<dynamic>> _environmentValues =
      <EnvironmentValue<dynamic>>[];

  @override
  void initState() {
    super.initState();

    widget.scene.rebuildScene = () => setState(() {});

    _environmentValues = <EnvironmentValue<dynamic>>[
      darkModeEnvironmentOption.makeEnvironmentValue(),
      semanticsOverlayOption.makeEnvironmentValue(),
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
    return Material(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: _textScale,
              platformBrightness:
                  _isDarkMode ? Brightness.dark : Brightness.light,
            ),
            child: Theme(
              data: Theme.of(context).copyWith(platform: _targetPlatform),
              child: SizedBox(
                width: _widthOverride ?? MediaQuery.of(context).size.width,
                height: _heightOverride ?? MediaQuery.of(context).size.height,
                child: _showSemantics
                    ? SemanticsDebugger(child: widget.scene.build())
                    : widget.scene.build(),
              ),
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
                        NumberStepperControl(
                          title: const Text('Text Scale'),
                          value: _textScale,
                          onDecrementPressed: () => setState(() {
                            _textScale -= 0.1;
                          }),
                          onIncrementPressed: () => setState(() {
                            _textScale += 0.1;
                          }),
                        ),
                        DisplaySizePicker(
                          initialSize: MediaQuery.of(context).size,
                          didChangeSize: (double? width, double? height) {
                            setState(() {
                              _widthOverride = width;
                              _heightOverride = height;
                            });
                          },
                        ),
                        DropdownControl<TargetPlatform>(
                          title: const Text('Target Platform'),
                          items: TargetPlatform.values,
                          onChanged: (TargetPlatform? newValue) => setState(() {
                            if (newValue != null) {
                              _targetPlatform = newValue;
                            }
                          }),
                          value: _targetPlatform ?? Theme.of(context).platform,
                          itemTitleBuilder: (TargetPlatform platform) =>
                              platform.name,
                        ),
                        ...widget.scene.environmentOptionBuilders.map(
                          (WidgetBuilder builder) => builder(context),
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
    );
  }
}
