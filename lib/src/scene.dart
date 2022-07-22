import 'package:flutter/widgets.dart';

abstract class Scene {
  String get title;
  Future<void> setUp() async {}
  Widget build();
}
