/*
 Copyright 2023 Google LLC

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'environment/controls/boolean_control.dart';
import 'environment/controls/dropdown_control.dart';
import 'environment/controls/environment_control.dart';
import 'environment/controls/stepper_control.dart';
import 'environment/controls/text_input_control.dart';
import 'environment/environment_control_panel.dart';
import 'environment/state/environment_state.dart';
import 'environment/state/screen_size_preset.dart';
import 'scene.dart';

/// Wraps [child] in a MediaQuery whose properties (such as textScale and
/// brightness) are editable using an on-screen widget.
///
/// The environment editing widget can be toggled using a two-finger long press.
class SceneContainer extends StatefulWidget {
  /// Creates a [SceneContainer].
  const SceneContainer({
    super.key,
    required this.environmentState,
    required this.scene,
  });

  /// The [Scene] being displayed.
  final Scene scene;

  /// The shared state backing [scene].
  final EnvironmentState environmentState;

  @override
  State<SceneContainer> createState() => _SceneContainerState();
}

class _SceneContainerState extends State<SceneContainer> {
  /// The length of the [EnvironmentControlPanel] show/hide animation.
  static const Duration panelAnimationDuration = Duration(milliseconds: 250);

  /// The width of the divider between the [EnvironmentControlPanel] and the
  /// body of the Scene.
  static const double panelDividerWidth = 1;

  /// A key used to identify the Scene's parent widget. This is set to a new
  /// [UniqueKey] value when [Scene.setNeedsReconstruct] is called to force
  /// StatefulWidgets in the Scene to recreate their state.
  Key containerKey = UniqueKey();

  /// Whether or not the [EnvironmentControlPanel] is expanded. Only applicable
  /// on small screens.
  bool isControlPanelExpanded = false;

  /// Used to listen to [Scene.setNeedsReconstruct].
  late StreamSubscription<void> sceneReconstructSubscription;

  /// The backing environment state for this Scene.
  EnvironmentState get environmentState => widget.environmentState;

  /// The width of the [EnvironmentControlPanel].
  double get panelWidth => min(MediaQuery.of(context).size.width * 0.75, 300);

  /// Whether the screen is too small to accommodate a master-detail layout for
  /// the [EnvironmentControlPanel] and the Scene.
  bool get isControlPanelCollapsible => MediaQuery.of(context).size.width < 600;

  /// The largest possible vertical dimension for the Scene.
  double get maxSceneHeight => MediaQuery.of(context).size.height;

  /// The largest possible horizontal dimension for the Scene.
  double get maxSceneWidth => isControlPanelCollapsible
      ? MediaQuery.of(context).size.width
      : MediaQuery.of(context).size.width - panelWidth - panelDividerWidth;

  /// Effective height for the Scene.
  double get sceneHeight {
    final String? heightOverride = heightOverrideControl.currentValue;
    if (heightOverride != null && double.tryParse(heightOverride) != null) {
      return double.parse(heightOverride);
    } else {
      return maxSceneHeight;
    }
  }

  /// Effective width for the Scene.
  double get sceneWidth {
    final String? widthOverride = widthOverrideControl.currentValue;
    if (widthOverride != null && double.tryParse(widthOverride) != null) {
      return double.parse(widthOverride);
    } else {
      return maxSceneWidth;
    }
  }

  late final BooleanControl darkModeControl = BooleanControl(
    title: 'Dark Mode',
    stateKey: EnvironmentState.isDarkModeKey,
    defaultValue: false,
    environmentState: environmentState,
  );

  late final StepperControl<double> textScaleControl = StepperControl<double>(
    title: 'Text Scale',
    stateKey: EnvironmentState.textScaleKey,
    defaultValue: 1.0,
    onDecrementPressed: (double currentValue) => currentValue -= 0.1,
    onIncrementPressed: (double currentValue) => currentValue += 0.1,
    displayValueBuilder: (double currentValue) =>
        currentValue.toStringAsFixed(1),
    environmentState: environmentState,
  );

  late final BooleanControl isTextBoldControl = BooleanControl(
    title: 'Bold Text',
    stateKey: EnvironmentState.isTextBoldKey,
    defaultValue: false,
    environmentState: environmentState,
  );

  late final BooleanControl showSemanticsControl = BooleanControl(
    title: 'Show Semantics',
    stateKey: EnvironmentState.showSemanticsKey,
    defaultValue: false,
    environmentState: environmentState,
  );

  late final DropdownControl<TargetPlatform?> targetPlatformControl =
      DropdownControl<TargetPlatform?>(
    title: 'Platform',
    stateKey: EnvironmentState.targetPlatformKey,
    defaultValue: null,
    items: TargetPlatform.values,
    itemTitleBuilder: (TargetPlatform? platform) =>
        platform?.name ?? '(Current)',
    environmentState: environmentState,
  );

  late final TextInputControl heightOverrideControl = TextInputControl(
    title: 'Height',
    stateKey: EnvironmentState.heightOverrideKey,
    defaultValue: null,
    environmentState: environmentState,
  );

  late final TextInputControl widthOverrideControl = TextInputControl(
    title: 'Width',
    stateKey: EnvironmentState.widthOverrideKey,
    defaultValue: null,
    environmentState: environmentState,
  );

  late final DropdownControl<ScreenSizePreset?> devicePickerControl =
      DropdownControl<ScreenSizePreset?>(
    title: 'Device',
    stateKey: EnvironmentState.devicePreviewKey,
    defaultValue: null,
    items: <ScreenSizePreset?>[null, ...ScreenSizePreset.all],
    itemTitleBuilder: (ScreenSizePreset? preset) =>
        preset?.toString() ?? '(none)',
    onValueUpdated: (ScreenSizePreset? preset) {
      final Size newSize = preset?.size ?? Size(maxSceneWidth, maxSceneHeight);
      heightOverrideControl.updateValue(newSize.height.toStringAsFixed(0));
      widthOverrideControl.updateValue(newSize.width.toStringAsFixed(0));
    },
  );

  @override
  void initState() {
    super.initState();

    environmentState.addListener(rebuildScene);

    sceneReconstructSubscription = widget.scene.onNeedsReconstruct.listen((_) {
      // Create a new UniqueKey to force recreation of StatefulWidgets' states.
      setState(() => containerKey = UniqueKey());
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      targetPlatformControl.updateValue(Theme.of(context).platform);
      heightOverrideControl.updateValue(sceneHeight.toStringAsFixed(0));
      widthOverrideControl.updateValue(sceneWidth.toStringAsFixed(0));
    });
  }

  @override
  void dispose() {
    sceneReconstructSubscription.cancel();

    if (context.mounted) {
      environmentState.removeListener(rebuildScene);
    }
    super.dispose();
  }

  void rebuildScene() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  void resetScene() {
    setState(() {
      environmentState.reset();
      rebuildScene();
    });
  }

  Widget _panel() {
    return SizedBox(
      width: panelWidth,
      child: EnvironmentControlPanel(
        targetPlatform: targetPlatformControl.currentValue,
        children: <Widget>[
          if (Navigator.of(context).canPop())
            IconButton(
              key: const ValueKey<String>('PopToSceneListButton'),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              icon: const Icon(Icons.arrow_back),
            ),
          darkModeControl.build(context),
          isTextBoldControl.build(context),
          showSemanticsControl.build(context),
          textScaleControl.build(context),
          targetPlatformControl.build(context),
          heightOverrideControl.build(context),
          widthOverrideControl.build(context),
          devicePickerControl.build(context),
          ...widget.scene.environmentControls
              .map((EnvironmentControl<Object?> control) {
            return control.build(context);
          }),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: resetScene,
              child: const Text('Reset'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sceneWrapper() {
    return MediaQuery(
      key: const ValueKey<String>('SceneContainerMediaQuery'),
      data: MediaQuery.of(context).copyWith(
        boldText: isTextBoldControl.currentValue,
        textScaleFactor: textScaleControl.currentValue,
        platformBrightness:
            (darkModeControl.currentValue) ? Brightness.dark : Brightness.light,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          platform: targetPlatformControl.currentValue,
        ),
        child: SizedBox(
          key: containerKey,
          width: sceneWidth,
          height: sceneHeight,
          child: ClipRect(
            child: (showSemanticsControl.currentValue)
                ? SemanticsDebugger(child: widget.scene.build(context))
                : widget.scene.build(context),
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
            isControlPanelExpanded ? 0 : -panelWidth,
            0,
            0,
          ),
          duration: panelAnimationDuration,
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
                      isControlPanelExpanded = !isControlPanelExpanded;
                    });
                  },
                  child: AnimatedRotation(
                    duration: panelAnimationDuration,
                    turns: isControlPanelExpanded ? 0.5 : 0.0,
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
        const VerticalDivider(width: panelDividerWidth),
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
      child: isControlPanelCollapsible
          ? _smallScreenLayout()
          : _largeScreenLayout(),
    );
  }
}
