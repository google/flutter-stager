import 'package:flutter/material.dart';
import 'package:stager/stager.dart';

class StagerApp extends StatelessWidget {
  final List<Scene> scenes;

  const StagerApp({super.key, required this.scenes});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Scenes')),
        body: ListView.separated(
          itemBuilder: (context, index) => ListTile(
            title: Text(scenes[index].title),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => scenes[index].build(),
                ),
              );
            },
          ),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: scenes.length,
        ),
      ),
    );
  }
}
