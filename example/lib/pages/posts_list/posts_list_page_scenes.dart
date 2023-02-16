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
  Widget build() {
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
  int _numPosts = Post.fakePosts().length;

  @override
  String get title => 'With Posts';

  @override
  List<EnvironmentControlBuilder> get environmentControlBuilders =>
      <EnvironmentControlBuilder>[
        (_, VoidCallback rebuildScene) {
          return NumberStepperControl(
            title: const Text('# Posts'),
            value: _numPosts,
            onDecrementPressed: () async {
              _numPosts = max(0, _numPosts - 1);
              rebuildScene();
            },
            onIncrementPressed: () async {
              _numPosts = min(_numPosts + 1, Post.fakePosts().length);
              rebuildScene();
            },
          );
        },
      ];

  @override
  Future<void> setUp() async {
    await super.setUp();
    when(mockApi.fetchPosts()).thenAnswer((_) async {
      return Post.fakePosts().take(_numPosts).toList();
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
