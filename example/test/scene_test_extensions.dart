import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stager/stager.dart';

/// Convenience functions for widget testing [Scene]s.
///
/// TODO: move this to a new stager_testing package
extension Testing on Scene {
  /// A convenience function that prepares a [Scene] for widget testing.
  ///
  /// Calls [Scene.setUp] with either [environmentState] or a default
  /// [EnvironmentState] if none is provided and provides [Scene.build] with a
  /// valid BuildContext.
  Future<void> setUpAndPump(WidgetTester tester) async {
    await this.setUp();

    await tester.pumpWidget(
      Builder(
        builder: (BuildContext context) => build(context),
      ),
    );

    await tester.pump();
  }
}
