import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stager/stager.dart';

import '../shared/api.dart';
import '../shared/post.dart';
import 'posts_list.dart';

class FakeApi implements Api {
  List<Post> posts = [];

  @override
  Future<List<Post>> fetchPosts() async => posts;
}

class LoadingApi implements Api {
  @override
  Future<List<Post>> fetchPosts() {
    final completer = Completer<List<Post>>();
    return completer.future;
  }
}

abstract class BasePostsListScene extends Scene {
  final fakeApi = FakeApi();

  @override
  Widget build() {
    return PostsList(api: fakeApi);
  }

  @override
  Future<void> setUp() async {}
}

class EmptyListScene extends BasePostsListScene {
  @override
  String get title => 'Empty List';
}

class WithPostsScene extends BasePostsListScene {
  @override
  String get title => 'With Posts';

  @override
  Future<void> setUp() async {
    fakeApi.posts = Post.fakePosts;
  }
}

class LoadingScene extends Scene {
  final api = LoadingApi();

  @override
  Widget build() {
    return PostsList(api: api);
  }

  @override
  String get title => 'Loading';
}
