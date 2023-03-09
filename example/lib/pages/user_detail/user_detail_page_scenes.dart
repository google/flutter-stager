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
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:stager/stager.dart';

import '../../shared/api.dart';
import '../../shared/post.dart';
import '../../shared/user.dart';
import '../posts_list/posts_list_page_scenes.mocks.dart';
import 'user_detail_page.dart';

/// A Scene demonstrating the [UserDetailPage].
abstract class UserDetailPageScene extends Scene {
  /// An example of an [EnvironmentControl] that is shared by multiple [Scenes].
  ///
  /// This is used by [WithPostsUserDetailPageScene] and
  /// [ComplexUserDetailPageScene]. Changes the post count in either of these
  /// scenes will be reflected in the other.
  final StepperControl<int> postCountControl = StepperControl<int>(
    title: 'Post Count',
    stateKey: 'UserDetailNumPosts',
    defaultValue: 20,
    onDecrementPressed: (int currentValue) => max(0, currentValue - 1),
    onIncrementPressed: (int currentValue) => min(20, currentValue + 1),
  );

  /// A mock dependency of [UserDetailPage]. Mock the value of [Api.fetchPosts]
  /// to put the staged [UserDetailPage] into different states.
  late MockApi mockApi;

  /// The [User] whose information is being displayed.
  User user = User.joeUser;

  @override
  Future<void> setUp() async {
    await super.setUp();
    mockApi = MockApi();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<Api>.value(
      value: mockApi,
      child: EnvironmentAwareApp(
        home: UserDetailPage(
          user: user,
        ),
      ),
    );
  }
}

/// A Scene showing the loading state of the [UserDetailPage].
class LoadingUserDetailPageScene extends UserDetailPageScene {
  @override
  String get title => 'Loading';

  @override
  Future<void> setUp() async {
    await super.setUp();
    when(mockApi.fetchPosts(user: user)).thenAnswer((_) {
      final Completer<List<Post>> completer = Completer<List<Post>>();
      return completer.future;
    });
  }
}

/// A Scene showing the error state of the [UserDetailPage].
class ErrorUserDetailPageScene extends UserDetailPageScene {
  @override
  String get title => 'Error';

  @override
  Future<void> setUp() async {
    await super.setUp();
    when(mockApi.fetchPosts(user: user)).thenAnswer(
      (_) async => Future<List<Post>>.error(
        Exception('on no!'),
      ),
    );
  }
}

/// A Scene showing the empty state of the [UserDetailPage].
class EmptyUserDetailPageScene extends UserDetailPageScene {
  @override
  String get title => 'Empty';

  @override
  Future<void> setUp() async {
    await super.setUp();
    when(mockApi.fetchPosts(user: user)).thenAnswer((_) async => <Post>[]);
  }
}

/// A Scene showing the content state of the [UserDetailPage].
class WithPostsUserDetailPageScene extends UserDetailPageScene {
  @override
  late final List<EnvironmentControl<Object?>> environmentControls =
      <EnvironmentControl<Object?>>[
    postCountControl,
  ];

  @override
  String get title => 'With posts';

  @override
  Future<void> setUp() async {
    await super.setUp();
    when(mockApi.fetchPosts(user: user)).thenAnswer(
      (_) async => Post.fakePosts(user: user)
          .take(postCountControl.currentValue)
          .toList(),
    );
  }
}

/// A Scene showing the [UserDetailPage] for a [User] with a long name.
class ComplexUserDetailPageScene extends UserDetailPageScene {
  @override
  late final List<EnvironmentControl<Object?>> environmentControls =
      <EnvironmentControl<Object?>>[
    postCountControl,
  ];

  @override
  String get title => 'User with long name';

  @override
  Future<void> setUp() async {
    await super.setUp();
    user = const User(
      id: 1234,
      handle: '@asdf',
      name: 'Super cool poster with great hot takes',
    );
    when(mockApi.fetchPosts(user: user)).thenAnswer(
      (_) async =>
          Post.fakePosts().take(postCountControl.currentValue).toList(),
    );
  }
}
