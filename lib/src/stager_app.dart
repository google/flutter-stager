import 'package:flutter/material.dart';

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
  /// Creates a [StagerApp] with the given [scenes].
  const StagerApp({super.key, required this.scenes});

  /// The [Scene]s being displayed by this app.
  final List<Scene> scenes;

  @override
  State<StagerApp> createState() => _StagerAppState();
}

class _StagerAppState extends State<StagerApp> {
  late Future<void> _sceneSetUpFuture;

  bool get _isSingleScene => widget.scenes.length == 1;

  @override
  void initState() {
    super.initState();
    if (_isSingleScene) {
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

        return MaterialApp(
          home: _isSingleScene
              ? SceneContainer(scene: widget.scenes.first)
              : SceneList(scenes: widget.scenes),
        );
      },
    );
  }
}
