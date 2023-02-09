import 'package:flutter/material.dart';
import 'package:stager/stager.dart';

import '../../shared/post.dart';
import 'post_detail_page.dart';

/// A scene demonstrating a [PostDetailPage] with content.
class PostDetailPageScene extends Scene {
  /// TODO
  double? heightOverride;

  /// TODO
  double? widthOverride;

  @override
  String get title => 'Post Detail';

  @override
  List<WidgetBuilder> get environmentOptionBuilders => <WidgetBuilder>[
        (BuildContext context) {
          return DisplaySizePicker(
            didChangeSize: (double? width, double? height) {
              widthOverride = width;
              heightOverride = height;
              if (rebuildScene != null) {
                rebuildScene!();
              }
            },
          );
        },
      ];

  @override
  Widget build() {
    return EnvironmentAwareApp(
      home: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            height: heightOverride,
            width: widthOverride,
            child: PostDetailPage(
              post: Post.fakePosts().first,
            ),
          ),
        ],
      ),
    );
  }
}
