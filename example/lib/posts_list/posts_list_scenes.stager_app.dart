// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StagerAppGenerator
// **************************************************************************

import 'posts_list_scenes.dart';

import 'package:flutter/material.dart';
import 'package:stager/stager.dart';

Future<void> main() async {
  final scenes = [
    EmptyListScene(),
    WithPostsScene(),
    LoadingScene(),
  ];

  for (final scene in scenes) {
    await scene.setUp();
  }

  runApp(StagerApp(scenes: scenes));
}
