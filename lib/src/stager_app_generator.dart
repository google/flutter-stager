import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class StagerAppGenerator extends Generator {
  @override
  Future<String?> generate(
    LibraryReader library,
    BuildStep buildStep,
  ) async {
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

    final imports = sceneElements
        .map((e) => e.source.shortName)
        .toSet()
        .map((shortName) => "import '$shortName';");
    buffer.write(imports.join('\n'));

    final sceneConstructors = [];

    for (final sceneElement in sceneElements) {
      sceneConstructors.add('${sceneElement.name}()');
    }

    final sceneConstructorsString = sceneConstructors.join(',\n');
    buffer.write('''

import 'package:flutter/material.dart';
import 'package:stager/stager.dart';

Future<void> main() async {
  final scenes = [
    $sceneConstructorsString
  ];

  for (final scene in scenes) {
    await scene.setUp();
  }

  runApp(SceneListApp(scenes: scenes));
}
''');

    return buffer.toString();
  }
}
