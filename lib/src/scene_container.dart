import 'dart:math';

import 'package:flutter/material.dart';

import 'control_panel/boolean_control.dart';
import 'control_panel/display_size_picker.dart';
import 'control_panel/dropdown_control.dart';
import 'control_panel/environment_control_panel.dart';
import 'control_panel/number_stepper_control.dart';
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
  Key _containerKey = UniqueKey();
  bool _isControlPanelExpanded = false;
  double _textScale = 1;
  bool _isDarkMode = false;
  bool _showSemantics = false;
  TargetPlatform? _targetPlatform;
  num? _heightOverride;
  num? _widthOverride;

  void _rebuildScene() {
    setState(() => _containerKey = UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    final double panelWidth =
        min(MediaQuery.of(context).size.width * 0.75, 400);
    return Material(
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          MediaQuery(
            key: const ValueKey<String>('SceneContainerMediaQuery'),
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: _textScale,
              platformBrightness:
                  _isDarkMode ? Brightness.dark : Brightness.light,
            ),
            child: Theme(
              data: Theme.of(context).copyWith(platform: _targetPlatform),
              child: SizedBox(
                key: _containerKey,
                width: _widthOverride?.toDouble(),
                height: _heightOverride?.toDouble(),
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
                        if (Navigator.of(context).canPop())
                          IconButton(
                            key: const ValueKey<String>('PopToSceneListButton'),
                            onPressed: () =>
                                Navigator.of(context, rootNavigator: true)
                                    .pop(),
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
                        NumberStepperControl(
                          key: const ValueKey<String>(
                            'TextScaleStepperControl',
                          ),
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
                          didChangeSize: (num? width, num? height) {
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
                        ...widget.scene.environmentControlBuilders
                            .map((EnvironmentControlBuilder builder) {
                          return builder(context, _rebuildScene);
                        }),
                      ],
                    ),
                  ),
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
