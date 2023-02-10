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

  @override
  List<WidgetBuilder> get environmentOptionBuilders => <WidgetBuilder>[
        (BuildContext context) {
          return DropdownControl<Post>(
              value: currentPost,
              title: const Text('Post'),
              items: Post.fakePosts(),
              onChanged: (Post? newPost) {
                if (newPost == null) {
                  return;
                }

                currentPost = newPost;
                rebuildScene!();
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
