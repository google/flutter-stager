import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stager/stager.dart';

void main() {
  testWidgets('collapses EnvironmentControlPanel on narrow screens',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(500, 600);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    final StagerApp stagerApp = StagerApp(scenes: <Scene>[TextScene()]);
    await tester.pumpWidget(stagerApp);
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('ToggleEnvironmentControlPanelButton')),
      findsOneWidget,
    );
  });

  testWidgets('expands EnvironmentControlPanel on larger screens',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(2160, 3840);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    final StagerApp stagerApp = StagerApp(scenes: <Scene>[TextScene()]);
    await tester.pumpWidget(stagerApp);
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('ToggleEnvironmentControlPanelButton')),
      findsNothing,
    );
  });
}

class TextScene extends Scene {
  @override
  String get title => 'Text';

  @override
  Widget build(BuildContext context) {
    return const Text('Text Scene');
  }
}
