import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stager/src/control_panel/environment_control_panel.dart';
import 'package:stager/stager.dart';

void main() {
  MediaQuery sceneContainerMediaQuery() {
    return find
        .byKey(const ValueKey<String>('SceneContainerMediaQuery'))
        .evaluate()
        .first
        .widget as MediaQuery;
  }

  Future<void> createAppAndShowControlPanel(WidgetTester tester) async {
    final StagerApp stagerApp =
        StagerApp(scenes: <Scene>[EnvironmentControlScene()]);
    await tester.pumpWidget(stagerApp);
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey<String>('ToggleEnvironmentControlPanelButton')),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Dark mode toggles brightness', (WidgetTester tester) async {
    await createAppAndShowControlPanel(tester);

    expect(
      sceneContainerMediaQuery().data.platformBrightness,
      Brightness.light,
    );

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey<String>('ToggleDarkModeControl')),
        matching: find.byType(Switch),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      sceneContainerMediaQuery().data.platformBrightness,
      Brightness.dark,
    );

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey<String>('ToggleDarkModeControl')),
        matching: find.byType(Switch),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      sceneContainerMediaQuery().data.platformBrightness,
      Brightness.light,
    );
  });

  testWidgets('Text size stepper adjusts text scale',
      (WidgetTester tester) async {
    await createAppAndShowControlPanel(tester);

    expect(sceneContainerMediaQuery().data.textScaleFactor, 1.0);

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey<String>('TextScaleStepperControl')),
        matching: find.byIcon(Icons.add),
      ),
    );
    await tester.pumpAndSettle();

    expect(sceneContainerMediaQuery().data.textScaleFactor, 1.1);

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey<String>('TextScaleStepperControl')),
        matching: find.byIcon(Icons.remove),
      ),
    );
    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey<String>('TextScaleStepperControl')),
        matching: find.byIcon(Icons.remove),
      ),
    );
    await tester.pumpAndSettle();

    expect(sceneContainerMediaQuery().data.textScaleFactor, 0.9);
  });

  testWidgets('Toggles semantics overlay', (WidgetTester tester) async {
    await createAppAndShowControlPanel(tester);

    expect(find.byType(SemanticsDebugger), findsNothing);

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey<String>('ToggleSemanticsOverlayControl')),
        matching: find.byType(Switch),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SemanticsDebugger), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey<String>('ToggleSemanticsOverlayControl')),
        matching: find.byType(Switch),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SemanticsDebugger), findsNothing);
  });

  group('Adjusts display size', () {
    SizedBox findSceneFrame() {
      return find
          .descendant(
            of: find.byKey(
              const ValueKey<String>('SceneContainerMediaQuery'),
            ),
            matching: find.byType(SizedBox),
          )
          .evaluate()
          .first
          .widget as SizedBox;
    }

    testWidgets('When height and width text fields are edited',
        (WidgetTester tester) async {
      await createAppAndShowControlPanel(tester);

      expect(findSceneFrame().height, 600);
      expect(findSceneFrame().width, 800);

      await tester.enterText(
        find.byKey(const ValueKey<String>('DisplayWidthTextField')),
        '200',
      );
      await tester.pumpAndSettle();

      expect(findSceneFrame().height, 600);
      expect(findSceneFrame().width, 200);

      await tester.enterText(
        find.byKey(const ValueKey<String>('DisplayHeightTextField')),
        '500',
      );
      await tester.pumpAndSettle();

      expect(findSceneFrame().height, 500);
      expect(findSceneFrame().width, 200);
    });

    testWidgets('When a preset is chosen from the dropdown',
        (WidgetTester tester) async {
      await createAppAndShowControlPanel(tester);

      expect(findSceneFrame().height, 600);
      expect(findSceneFrame().width, 800);

      await tester.tap(find.text('Current Window'));
      await tester.pumpAndSettle();

      // We use [last] on this finder because each [DropdownMneuItem] will
      // appear twice when the dropdown is expanded. See
      // https://github.com/flutter/flutter/blob/504e66920005937b6ffbc3ccd6b59d594b0e98c4/packages/flutter/test/material/dropdown_test.dart#L2230
      await tester.tap(
        find.byKey(const ValueKey<String>('Galaxy Fold')).last,
      );
      await tester.pumpAndSettle();

      expect(findSceneFrame().height, 653);
      expect(findSceneFrame().width, 280);
    });
  });

  testWidgets('Changes target platform', (WidgetTester tester) async {
    await createAppAndShowControlPanel(tester);
    // [Theme.platform] defaults to [TargetPlatform.android]
    expect(
      Theme.of(
        tester.element(find.byKey(EnvironmentControlScene.sceneKey)),
      ).platform,
      TargetPlatform.android,
    );

    // Open the dropdown.
    await tester.tap(find.text(TargetPlatform.android.name));
    await tester.pumpAndSettle();

    // Select iOS from the list of target platforms.
    await tester.tap(find.text(TargetPlatform.iOS.name).last);
    await tester.pumpAndSettle();

    expect(
      Theme.of(tester.element(
        find.byKey(EnvironmentControlScene.sceneKey),
      )).platform,
      TargetPlatform.iOS,
    );
  });

  testWidgets('Shows custom environment controls when present',
      (WidgetTester tester) async {
    await createAppAndShowControlPanel(tester);

    expect(find.byType(EnvironmentControlPanel), findsOneWidget);

    expect(
      find.byKey(EnvironmentControlScene.environmentControlKey),
      findsOneWidget,
    );
  });
}

class EnvironmentControlScene extends Scene {
  static const ValueKey<String> sceneKey = ValueKey<String>('Scene');

  static const ValueKey<String> environmentControlKey =
      ValueKey<String>('EnvironmentControlButton');

  @override
  Widget build() => const Text(
        'My Scene',
        key: EnvironmentControlScene.sceneKey,
      );

  @override
  String get title => 'My Scene';

  @override
  List<EnvironmentControlBuilder> get environmentControlBuilders =>
      <EnvironmentControlBuilder>[
        (_, __) => ElevatedButton(
              key: environmentControlKey,
              onPressed: () {},
              child: const Text('Click me'),
            ),
      ];
}
