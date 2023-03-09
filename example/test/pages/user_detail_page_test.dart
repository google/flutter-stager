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
