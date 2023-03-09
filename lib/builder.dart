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

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/stager_app_generator.dart';

/// Generates a .stager_app.dart file with a runnable main that calls [runApp]
/// with a [StagerApp] displaying all titled [Scene]s.
Builder buildStagerApp(BuilderOptions options) => LibraryBuilder(
      StagerAppGenerator(),
      generatedExtension: '.stager_app.g.dart',
    );
