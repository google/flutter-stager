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

import 'package:flutter/material.dart';

import 'environment/state/environment_state.dart';
import 'scene.dart';
import 'scene_container.dart';

/// A [ListView] showing available [Scenes]. Tapping on a Scene name will setUp
/// the Scene before displaying it.
class SceneList extends StatefulWidget {
  /// Creates a [SceneList] widget.
  const SceneList({
    super.key,
    required this.scenes,
    required this.environmentState,
  });

  /// The list of [Scene]s displayed by this widget.
  final List<Scene> scenes;

  /// The shared state backing [scenes].
  final EnvironmentState environmentState;

  @override
  State<SceneList> createState() => _SceneListState();
}

class _SceneListState extends State<SceneList> {
  EnvironmentState get environmentState => widget.environmentState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scenes')),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          final Scene scene = widget.scenes[index];
          return ListTile(
            title: Text(widget.scenes[index].title),
            onTap: () async {
              await scene.setUp();
              if (!mounted) {
                return;
              }

              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => SceneContainer(
                    scene: scene,
                    environmentState: environmentState,
                  ),
                ),
              );
            },
          );
        },
        separatorBuilder: (_, __) => const Divider(),
        itemCount: widget.scenes.length,
      ),
    );
  }
}
