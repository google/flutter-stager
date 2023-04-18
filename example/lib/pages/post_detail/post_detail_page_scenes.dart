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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:stager/stager.dart';

import '../../shared/post.dart';
import 'post_detail_page.dart';

/// A scene demonstrating a [PostDetailPage] with content.
class PostDetailPageScene extends Scene {
  /// The [EnvironmentState] key that maps to the currentPost value.
  static const String _currentPostKey = 'PostDetailPageScene.CurrentPost';

  /// Creates an [EnvironmentControl] that allows the user to choose which
  /// [Post] is displayed in this Scene.
  final DropdownControl<Post> postSelectorControl = DropdownControl<Post>(
    title: 'Post',
    stateKey: _currentPostKey,
    defaultValue: Post.fakePosts().first,
    items: Post.fakePosts(),
  );

  @override
  String get title => 'Post Detail';

  @override
  List<Locale>? get supportedLocales => AppLocalizations.supportedLocales;

  /// This [Scene] overrides the otional [environmentControls] getter to add a
  /// custom control to the Stager environment control panel.
  @override
  late final List<EnvironmentControl<Object?>> environmentControls =
      <EnvironmentControl<Object?>>[
    postSelectorControl,
  ];

  @override
  Widget build(BuildContext context) {
    return EnvironmentAwareApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      home: PostDetailPage(
        post: postSelectorControl.currentValue,
      ),
    );
  }
}
