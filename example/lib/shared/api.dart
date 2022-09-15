import 'post.dart';
import 'user.dart';

/// A fake class meant to represent an API client.
class Api {
  /// Waits 2 seconds and returns [Post.fakePosts].
  Future<List<Post>> fetchPosts({User? user}) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return Post.fakePosts(user: user);
  }
}
