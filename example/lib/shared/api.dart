import 'post.dart';

class Api {
  Future<List<Post>> fetchPosts() async {
    await Future.delayed(const Duration(seconds: 2));
    return Post.fakePosts;
  }
}
