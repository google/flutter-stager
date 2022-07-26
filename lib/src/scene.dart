import 'package:flutter/widgets.dart';

abstract class Scene {
  /// This Scene's name in the [StagerApp]'s list of scenes.
  String get title;

  /// Used to configure this Scene's dependencies.
  ///
  /// Analogous to StatefulWidget's `initState`, this is called once at app
  /// launch.
  Future<void> setUp() async {}

  /// Creates the widget tree for this Scene.
  ///
  /// This is called on every rebuild, including by Hot Reload.
  Widget build();
}
