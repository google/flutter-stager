import 'package:flutter/src/widgets/framework.dart';
import 'package:stager/src/scene.dart';

import '../shared/api.dart';
import '../shared/post.dart';
import 'posts_list.dart';

class FakeApi implements Api {
  List<Post> posts = [];

  @override
  Future<List<Post>> fetchPosts() async => posts;
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