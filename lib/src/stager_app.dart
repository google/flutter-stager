import 'package:flutter/material.dart';

import 'environment/state/environment_state.dart';
import 'scene.dart';
import 'scene_container.dart';
import 'scene_list.dart';

/// A convenience method to run [scenes] in a [StagerApp].
void runStagerApp({required List<Scene> scenes}) =>
    runApp(StagerApp(scenes: scenes));

/// A simple app that displays a list of [Scene]s and navigates to them on tap.
///
/// If only one Scene is provided, that Scene will be shown as though it had
/// been navigated to from a list of Scenes.
class StagerApp extends StatefulWidget {
  /// Creates a [StagerApp] with the given [scenes], which share
  /// [environmentState]. If no value is provided for [environmentState], the
  /// default [EnvironmentState.instance] will be used.
  StagerApp({
    super.key,
    required this.scenes,
    EnvironmentState? environmentState,
  }) : environmentState = environmentState ?? EnvironmentState.instance;

  /// The [Scene]s being displayed by this app.
  final List<Scene> scenes;

  /// An observable data store containing values that control how Scenes are
  /// presented, such as whether dark mode is enabled, whether bold text is
  /// enabled, etc.
  final EnvironmentState environmentState;

  @override
  State<StagerApp> createState() => _StagerAppState();
}

class _StagerAppState extends State<StagerApp> {
  late Future<void> _sceneSetUpFuture;

  bool get isSingleScene => widget.scenes.length == 1;

  EnvironmentState get environmentState => widget.environmentState;

  @override
  void initState() {
    super.initState();
    if (isSingleScene) {
      _sceneSetUpFuture = widget.scenes.first.setUp();
    } else {
      _sceneSetUpFuture = Future<void>.value();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _sceneSetUpFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return AnimatedBuilder(
          animation: environmentState,
          builder: (BuildContext context, _) => MaterialApp(
            home: isSingleScene
                ? SceneContainer(
                    scene: widget.scenes.first,
                    environmentState: environmentState,
                  )
                : SceneList(
                    scenes: widget.scenes,
                    environmentState: environmentState,
                  ),
          ),
        );
      },
    );
  }
}
