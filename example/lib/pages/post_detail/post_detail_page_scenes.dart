import 'package:flutter/material.dart';
import 'package:stager/stager.dart';

import '../../shared/post.dart';
import 'post_detail_page.dart';

/// A scene demonstrating a [PostDetailPage] with content.
class PostDetailPageScene extends Scene {
  /// The post being previewed.
  Post currentPost = Post.fakePosts().first;

  @override
  String get title => 'Post Detail';

  /// This [Scene] overrides the otional [environmentControlBuilders] getter to
  /// add a custom control to the Stager environment control panel.
  @override
  List<EnvironmentControlBuilder> get environmentControlBuilders =>
      <EnvironmentControlBuilder>[
        (_, VoidCallback rebuildScene) {
          return DropdownControl<Post>(
              value: currentPost,
              title: const Text('Post'),
              items: Post.fakePosts(),
              onChanged: (Post? newPost) {
                if (newPost == null) {
                  return;
                }

                // When a new [Post] is chosen, call [rebuildScene()] to update
                // the UI with the newly chosen post.
                currentPost = newPost;
                rebuildScene();
              });
        },
      ];

  @override
  Widget build() {
    return EnvironmentAwareApp(
      home: PostDetailPage(
        post: currentPost,
      ),
    );
  }
}
