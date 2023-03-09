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

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:stager/stager.dart';

import '../../shared/api.dart';
import '../../shared/post.dart';
import 'posts_list_page.dart';

// #docregion PostsListPageScene
@GenerateMocks(<Type>[Api])
import 'posts_list_page_scenes.mocks.dart';

/// Defines a shared build method used by subclasses and a [MockApi] subclasses
/// can use to control the behavior of the [PostsListPage].
abstract class BasePostsListScene extends Scene {
  /// A mock dependency of [PostsListPage]. Mock the value of [Api.fetchPosts]
  /// to put the staged [PostsListPage] into different states.
  late MockApi mockApi;

  @override
  Widget build(BuildContext context) {
    return EnvironmentAwareApp(
      home: Provider<Api>.value(
        value: mockApi,
        child: const PostsListPage(),
      ),
    );
  }

  @override
  Future<void> setUp() async {
    mockApi = MockApi();
  }
}

/// A Scene showing the [PostsListPage] with no [Post]s.
class EmptyListScene extends BasePostsListScene {
  @override
  String get title => 'Empty List';

  @override
  Future<void> setUp() async {
    await super.setUp();
    when(mockApi.fetchPosts()).thenAnswer((_) async => <Post>[]);
  }
}
// #enddocregion PostsListPageScene

/// A Scene showing the [PostsListPage] with [Post]s.
class WithPostsScene extends BasePostsListScene {
  /// Allows the number of posts shown in this Scene to be set in the control
  /// panel.
  ///
  /// Because [PostListsPage] issues a request to fetch posts in [initState],
  /// we need to call [setNeedsReconstruct] in the onValueUpdated callback to
  /// tell Stager to fully recreate this Scene.
  late final StepperControl<int> postCountStepperControl = StepperControl<int>(
    title: 'Post Count',
    stateKey: 'WithPostsScene.PostCount',
    defaultValue: Post.fakePosts().length,
    onDecrementPressed: (int currentValue) => max(0, currentValue - 1),
    onIncrementPressed: (int currentValue) =>
        min(currentValue + 1, Post.fakePosts().length),
    onValueUpdated: (_) => setNeedsReconstruct(),
  );

  @override
  String get title => 'With Posts';

  @override
  late final List<EnvironmentControl<Object?>> environmentControls =
      <EnvironmentControl<Object?>>[
    postCountStepperControl,
  ];

  @override
  Future<void> setUp() async {
    await super.setUp();
    when(mockApi.fetchPosts()).thenAnswer((_) async {
      return Post.fakePosts()
          .take(postCountStepperControl.currentValue)
          .toList();
    });
  }
}

/// A Scene showing the [PostsListPage] in a loading state.
class LoadingScene extends BasePostsListScene {
  @override
  String get title => 'Loading';

  @override
  Future<void> setUp() async {
    await super.setUp();
    final Completer<List<Post>> completer = Completer<List<Post>>();
    when(mockApi.fetchPosts()).thenAnswer((_) async => completer.future);
  }
}

/// A Scene showing the [PostsListPage] in a error state.
class ErrorScene extends BasePostsListScene {
  @override
  String get title => 'Error';

  @override
  Future<void> setUp() async {
    await super.setUp();
    when(mockApi.fetchPosts()).thenAnswer(
      (_) => Future<List<Post>>.error(Exception()),
    );
  }
}
