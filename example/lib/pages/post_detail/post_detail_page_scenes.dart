import 'package:flutter/material.dart';
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
      home: PostDetailPage(
        post: postSelectorControl.currentValue,
      ),
    );
  }
}
