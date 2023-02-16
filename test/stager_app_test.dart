import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stager/src/scene_container.dart';
import 'package:stager/stager.dart';

void main() {
  final List<Scene> scenes = <Scene>[
    ButtonScene(),
    TextScene(),
  ];

  testWidgets('Displays a list of Scenes', (WidgetTester tester) async {
    final StagerApp stagerApp = StagerApp(scenes: scenes);
    await tester.pumpWidget(stagerApp);
    await tester.pumpAndSettle();
    expect(find.text('Text'), findsOneWidget);
    expect(find.text('Button'), findsOneWidget);
  });

  testWidgets('Displays a back button after navigating to a Scene',
      (WidgetTester tester) async {
    final StagerApp stagerApp = StagerApp(scenes: scenes);
    await tester.pumpWidget(stagerApp);
    await tester.pumpAndSettle();

    // Tap the "Text" row to push TextScene onto the navigation stack.
    await tester.tap(find.text('Text'));
    await tester.pumpAndSettle();

    // Verify that our SceneContainer is present.
    expect(find.byType(SceneContainer), findsOneWidget);

    // Expand the EnvironmentControlPanel.
    await tester.tap(
      find.byKey(const ValueKey<String>('ToggleEnvironmentControlPanelButton')),
    );
    await tester.pumpAndSettle();

    // Verify that tapping the back button navigates back.
    await tester.tap(find.byKey(
      const ValueKey<String>('PopToSceneListButton'),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(SceneContainer), findsNothing);
    expect(find.text('Text'), findsOneWidget);
    expect(find.text('Button'), findsOneWidget);
  });
}

class TextScene extends Scene {
  @override
  String get title => 'Text';

  @override
  Widget build() => const Text('Text Scene');
}

class ButtonScene extends Scene {
  @override
  String get title => 'Button';

  @override
  Widget build() => ElevatedButton(
        onPressed: () {},
        child: const Text('My Button'),
      );
}
