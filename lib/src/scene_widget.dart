import 'package:flutter/material.dart';
import 'package:stager/stager.dart';

class SceneWidget extends StatefulWidget {
  final Scene scene;

  const SceneWidget({super.key, required this.scene});

  @override
  State<SceneWidget> createState() => _SceneWidgetState();
}

class _SceneWidgetState extends State<SceneWidget> {
  @override
  void initState() {
    super.initState();
    widget.scene.setUp();
  }

  @override
  Widget build(BuildContext context) => widget.scene.build();
}
