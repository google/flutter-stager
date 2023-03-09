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
import 'package:stager_example/pages/user_detail/user_detail_page_scenes.dart';

import '../scene_test_extensions.dart';

void main() {
  testWidgets('shows a loading state', (WidgetTester tester) async {
    final Scene scene = LoadingUserDetailPageScene();
    await scene.setUpAndPump(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows an error state', (WidgetTester tester) async {
    final Scene scene = ErrorUserDetailPageScene();
    await scene.setUpAndPump(tester);
    expect(find.text('Error'), findsOneWidget);
  });

  testWidgets('shows an empty state', (WidgetTester tester) async {
    final Scene scene = EmptyUserDetailPageScene();
    await scene.setUpAndPump(tester);
    expect(find.text('No posts'), findsOneWidget);
  });

  testWidgets('shows posts', (WidgetTester tester) async {
    final Scene scene = WithPostsUserDetailPageScene();
    await scene.setUpAndPump(tester);
    expect(find.text('Post 1'), findsOneWidget);
  });
}
