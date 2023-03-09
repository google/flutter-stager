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

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

/// Generates a dart file containing a main function that launches a [StagerApp]
/// which lists all titled [Scene] subclasses.
class StagerAppGenerator extends Generator {
  @override
  Future<String?> generate(
    LibraryReader library,
    BuildStep buildStep,
  ) async {
    // We only want to display scenes with titles. We assume [Scene]
    // subclasses without titles are base classes.
    final Iterable<ClassElement> sceneElements = library.allElements
        .whereType<ClassElement>()
        .where(
          (ClassElement classElement) => classElement.allSupertypes.any(
            (InterfaceType supertype) => supertype.element.name == 'Scene',
          ),
        )
        .where(
          (ClassElement classElement) => classElement.accessors.any(
            (PropertyAccessorElement accessor) =>
                accessor.hasOverride && accessor.name == 'title',
          ),
        );
    if (sceneElements.isEmpty) {
      return null;
    }

    final StringBuffer buffer = StringBuffer();

    final String importsString = sceneElements
        .map((ClassElement e) => e.source.shortName)
        .toSet()
        .map((String shortName) => "import '$shortName';")
        .join('\n');

    final String sceneConstructorsString =
        sceneElements.map((ClassElement e) => '${e.name}(),').join('\n');

    buffer.write('''

import 'package:stager/stager.dart';

$importsString

void main() {
  final List<Scene> scenes = <Scene>[
    $sceneConstructorsString
  ];

  if (const String.fromEnvironment('Scene').isNotEmpty) {
    const String sceneName = String.fromEnvironment('Scene');
    final Scene scene =
        scenes.firstWhere((Scene scene) => scene.title == sceneName);
    runStagerApp(scenes: <Scene>[scene]);
  } else {
    runStagerApp(scenes: scenes);
  }
}
''');

    return buffer.toString();
  }
}
