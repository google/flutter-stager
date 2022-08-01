import 'package:flutter/material.dart';

import 'scene.dart';
import 'scene_container.dart';

class StagerApp extends StatelessWidget {
  final List<Scene> scenes;

  const StagerApp({super.key, required this.scenes});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SceneList(
        scenes: scenes,
      ),
    );
  }
}

class SceneList extends StatefulWidget {
  final List<Scene> scenes;

  SceneList({super.key, required this.scenes});

  @override
  State<SceneList> createState() => _SceneListState();
}

class _SceneListState extends State<SceneList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scenes')),
      body: ListView.separated(
        itemBuilder: (context, index) {
          final scene = widget.scenes[index];
          return ListTile(
            title: Text(widget.scenes[index].title),
            onTap: () async {
              await scene.setUp();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SceneContainer(
                    child: scene.build(),
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
