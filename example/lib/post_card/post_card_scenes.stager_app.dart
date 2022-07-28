// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StagerAppGenerator
// **************************************************************************

import 'post_card_scenes.dart';

import 'package:flutter/material.dart';
import 'package:stager/stager.dart';

Future<void> main() async {
  final scenes = [
    PostCardScene(),
    PostsListScene(),
  ];

  if (const String.fromEnvironment('Scene').isNotEmpty) {
    const sceneName = String.fromEnvironment('Scene');
    final scene = scenes.firstWhere((scene) => scene.title == sceneName);
    await scene.setUp();
    runApp(scene.build());
  } else {
    runApp(StagerApp(scenes: scenes));
  }
}
