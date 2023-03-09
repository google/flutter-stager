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

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stager/src/scene_container.dart';
import 'package:stager/stager.dart';

EnvironmentState environmentState = EnvironmentState.forTest();

void main() {
  final List<Scene> scenes = <Scene>[
    ButtonScene(),
    TextScene(),
  ];

  setUp(() {
    environmentState.reset();
  });

  testWidgets('displays a list of Scenes', (WidgetTester tester) async {
    final StagerApp stagerApp = StagerApp(scenes: scenes);
    await tester.pumpWidget(stagerApp);
    await tester.pumpAndSettle();
    expect(find.text('Text'), findsOneWidget);
    expect(find.text('Button'), findsOneWidget);
  });

  testWidgets('displays a back button after navigating to a Scene',
      (WidgetTester tester) async {
    final StagerApp stagerApp = StagerApp(scenes: scenes);
    await tester.pumpWidget(stagerApp);
    await tester.pumpAndSettle();

    // Tap the "Text" row to push TextScene onto the navigation stack.
    await tester.tap(find.text('Text'));
    await tester.pumpAndSettle();

    // Verify that our SceneContainer is present.
    expect(find.byType(SceneContainer), findsOneWidget);

    // Verify that tapping the back button navigates back.
    await tester.tap(find.byKey(
      const ValueKey<String>('PopToSceneListButton'),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(SceneContainer), findsNothing);
    expect(find.text('Text'), findsOneWidget);
    expect(find.text('Button'), findsOneWidget);
  });

  testWidgets('environment state persists between scenes',
      (WidgetTester tester) async {
    final StagerApp stagerApp = StagerApp(
      scenes: scenes,
      environmentState: environmentState,
    );
    await tester.pumpWidget(stagerApp);
    await tester.pumpAndSettle();

    // Tap the "Text" row to push TextScene onto the navigation stack.
    await tester.tap(find.text('Text'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.descendant(
        of: find.byKey(
          const ValueKey<String>('state'),
        ),
        matching: find.byType(TextField),
      ),
      'testing testing testing',
    );
    await tester.pumpAndSettle();

    // Navigate back to the Scene list.
    await tester.tap(find.byKey(
      const ValueKey<String>('PopToSceneListButton'),
    ));
    await tester.pumpAndSettle();

    // Navigate to the button scene.
    await tester.tap(find.text('Button'));
    await tester.pumpAndSettle();

    expect(
      find.text('testing testing testing'),
      findsOneWidget,
    );
  });
}

final TextInputControl textInputControl = TextInputControl(
  title: 'Custom control',
  stateKey: 'state',
  defaultValue: '',
  environmentState: environmentState,
);

class TextScene extends Scene {
  @override
  final List<EnvironmentControl<Object?>> environmentControls =
      <EnvironmentControl<Object?>>[
    textInputControl,
  ];

  @override
  String get title => 'Text';

  @override
  Widget build(BuildContext context) => const Text('Text Scene');
}

class ButtonScene extends Scene {
  @override
  final List<EnvironmentControl<Object?>> environmentControls =
      <EnvironmentControl<Object?>>[
    textInputControl,
  ];

  @override
  String get title => 'Button';

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: () {},
        child: const Text('My Button'),
      );
}
