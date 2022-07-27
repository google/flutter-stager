import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class StagerAppGenerator extends Generator {
  @override
  Future<String?> generate(
    LibraryReader library,
    BuildStep buildStep,
  ) async {
    // We only want to display scenes with titles. We assume [Scene] subclasses
    // without titles are base classes.
    final sceneElements = library.allElements
        .whereType<ClassElement>()
        .where(
          (classElement) => classElement.allSupertypes.any(
            (supertype) => supertype.element.name == 'Scene',
          ),
        )
        .where(
          (classElement) => classElement.accessors.any(
            (accessor) => accessor.hasOverride && accessor.name == 'title',
          ),
        );
    if (sceneElements.isEmpty) {
      return null;
    }

    final buffer = StringBuffer();

    final importsString = sceneElements
        .map((e) => e.source.shortName)
        .toSet()
        .map((shortName) => "import '$shortName';")
        .join('\n');

    final sceneConstructorsString =
        sceneElements.map((e) => '${e.name}(),').join('\n');

    buffer.write('''
$importsString

import 'package:flutter/material.dart';
import 'package:stager/stager.dart';

Future<void> main() async {
  final scenes = [
    $sceneConstructorsString
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
''');

    return buffer.toString();
  }
}
