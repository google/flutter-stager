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
