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
