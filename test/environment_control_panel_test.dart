import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stager/src/environment/environment_control_panel.dart';
import 'package:stager/stager.dart';

void main() {
  // Test dimensions are 800x600
  // The EnvironmentControlPanel is 300px wide, and there is a 1px divider to
  // its right.
  // 800 - 300 - 1 = 499
  const double defaultSceneContainerWidth = 499;

  late EnvironmentState environmentState;

  setUp(() {
    environmentState = EnvironmentState.forTest();
  });

  MediaQuery sceneContainerMediaQuery() {
    return find
        .byKey(const ValueKey<String>('SceneContainerMediaQuery'))
        .evaluate()
        .first
        .widget as MediaQuery;
  }

  Future<void> createAppAndShowControlPanel(WidgetTester tester) async {
    final StagerApp stagerApp = StagerApp(
      scenes: <Scene>[EnvironmentControlScene()],
      environmentState: environmentState,
    );
    await tester.pumpWidget(stagerApp);
    await tester.pumpAndSettle();
  }

  testWidgets('dark mode control toggles brightness',
      (WidgetTester tester) async {
    await createAppAndShowControlPanel(tester);

    expect(
      sceneContainerMediaQuery().data.platformBrightness,
      Brightness.light,
    );

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey<String>(EnvironmentState.isDarkModeKey)),
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
        of: find.byKey(const ValueKey<String>(EnvironmentState.isDarkModeKey)),
        matching: find.byType(Switch),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      sceneContainerMediaQuery().data.platformBrightness,
      Brightness.light,
    );
  });
  testWidgets('bold text control toggles bold text',
      (WidgetTester tester) async {
    await createAppAndShowControlPanel(tester);

    expect(sceneContainerMediaQuery().data.boldText, false);

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey<String>(EnvironmentState.isTextBoldKey)),
        matching: find.byType(Switch),
      ),
    );
    await tester.pumpAndSettle();

    expect(sceneContainerMediaQuery().data.boldText, true);

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey<String>(EnvironmentState.isTextBoldKey)),
        matching: find.byType(Switch),
      ),
    );
    await tester.pumpAndSettle();

    expect(sceneContainerMediaQuery().data.boldText, false);
  });

  testWidgets('text size stepper adjusts text scale',
      (WidgetTester tester) async {
    await createAppAndShowControlPanel(tester);

    expect(sceneContainerMediaQuery().data.textScaleFactor, 1.0);

    await tester.tap(
      find.descendant(
        of: find.byKey(
          const ValueKey<String>(EnvironmentState.textScaleKey),
        ),
        matching: find.byIcon(Icons.add),
      ),
    );
    await tester.pumpAndSettle();

    expect(sceneContainerMediaQuery().data.textScaleFactor, 1.1);

    await tester.tap(
      find.descendant(
        of: find.byKey(
          const ValueKey<String>(EnvironmentState.textScaleKey),
        ),
        matching: find.byIcon(Icons.remove),
      ),
    );
    await tester.pump();

    await tester.tap(
      find.descendant(
        of: find.byKey(
          const ValueKey<String>(EnvironmentState.textScaleKey),
        ),
        matching: find.byIcon(Icons.remove),
      ),
    );
    await tester.pump();

    expect(sceneContainerMediaQuery().data.textScaleFactor, 0.9);
  });

  testWidgets('semantics overlay control toggles SemanticsDebugger',
      (WidgetTester tester) async {
    await createAppAndShowControlPanel(tester);

    expect(find.byType(SemanticsDebugger), findsNothing);

    await tester.tap(
      find.descendant(
        of: find.byKey(
          const ValueKey<String>(EnvironmentState.showSemanticsKey),
        ),
        matching: find.byType(Switch),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SemanticsDebugger), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byKey(
          const ValueKey<String>(EnvironmentState.showSemanticsKey),
        ),
        matching: find.byType(Switch),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SemanticsDebugger), findsNothing);
  });

  group('adjusts display size', () {
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

    testWidgets('when height and width text fields are edited',
        (WidgetTester tester) async {
      await createAppAndShowControlPanel(tester);

      expect(findSceneFrame().height, 600);
      expect(findSceneFrame().width, defaultSceneContainerWidth);

      await tester.enterText(
        find.descendant(
          of: find.byKey(
            const ValueKey<String>(EnvironmentState.widthOverrideKey),
          ),
          matching: find.byType(TextField),
        ),
        '200',
      );
      await tester.pumpAndSettle();

      expect(findSceneFrame().height, 600);
      expect(findSceneFrame().width, 200);

      await tester.enterText(
        find.descendant(
          of: find.byKey(
            const ValueKey<String>(EnvironmentState.heightOverrideKey),
          ),
          matching: find.byType(TextField),
        ),
        '500',
      );
      await tester.pumpAndSettle();

      expect(findSceneFrame().height, 500);
      expect(findSceneFrame().width, 200);
    });

    testWidgets('when a preset is chosen from the dropdown',
        (WidgetTester tester) async {
      await createAppAndShowControlPanel(tester);

      expect(findSceneFrame().height, 600);
      expect(findSceneFrame().width, defaultSceneContainerWidth);

      await tester.tap(
        find.descendant(
          of: find.byKey(
            const ValueKey<String>(EnvironmentState.devicePreviewKey),
          ),
          matching: find.byType(DropdownButton<ScreenSizePreset?>),
        ),
      );
      await tester.pumpAndSettle();

      // We use [last] on this finder because each [DropdownMenuItem] will
      // appear twice when the dropdown is expanded. See
      // https://github.com/flutter/flutter/blob/504e66920005937b6ffbc3ccd6b59d594b0e98c4/packages/flutter/test/material/dropdown_test.dart#L2230
      await tester.tap(
        find.text('Galaxy Fold (280 x 653)').last,
      );
      await tester.pumpAndSettle();

      expect(findSceneFrame().height, 653);
      expect(findSceneFrame().width, 280);
    });
  });

  testWidgets('target platform control changes target platform',
      (WidgetTester tester) async {
    await createAppAndShowControlPanel(tester);
    // [Theme.platform] defaults to [TargetPlatform.android]
    expect(
      Theme.of(
        tester.element(find.byKey(EnvironmentControlScene.sceneKey)),
      ).platform,
      TargetPlatform.android,
    );

    // Open the dropdown.
    await tester.tap(
      find.descendant(
        of: find.byKey(
          const ValueKey<String>(EnvironmentState.targetPlatformKey),
        ),
        matching: find.byType(DropdownButton<TargetPlatform?>),
      ),
    );
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

  testWidgets('panel shows custom environment controls when present',
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
  Widget build(BuildContext context) => const Text(
        'My Scene',
        key: EnvironmentControlScene.sceneKey,
      );

  @override
  String get title => 'My Scene';

  @override
  final List<EnvironmentControl<Object?>> environmentControls =
      <EnvironmentControl<Object?>>[
    StepperControl<int>(
      title: 'My Control',
      stateKey: environmentControlKey.value,
      defaultValue: 0,
      onDecrementPressed: (int currentValue) => currentValue + 1,
      onIncrementPressed: (int currentValue) => currentValue - 1,
    ),
  ];
}
