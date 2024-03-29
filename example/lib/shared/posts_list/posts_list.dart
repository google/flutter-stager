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

import 'package:flutter/material.dart';

import '../../pages/post_detail/post_detail_page.dart';
import '../post.dart';
import '../post_card/post_card.dart';

// #docregion PostsList
/// A [ListView] of [PostCard]s
class PostsList extends StatefulWidget {
  /// Creates a [PostsList] displaying [posts].
  ///
  /// [postsFuture] will be set to the value of [posts].
  PostsList({
    Key? key,
    required List<Post> posts,
  }) : this.fromFuture(key: key, Future<List<Post>>.value(posts));

  /// Creates a [PostsList] with a Future that resolves to a list of [Post]s.
  const PostsList.fromFuture(this.postsFuture, {super.key});

  /// The Future that resolves to the list of [Post]s this widget will display.
  final Future<List<Post>> postsFuture;

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: widget.postsFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        }

        final List<Post>? posts = snapshot.data;
        if (posts == null || posts.isEmpty) {
          return const Center(
            child: Text('No posts'),
          );
        }

        return ListView.builder(
          itemBuilder: (BuildContext context, int index) => PostCard(
            post: posts[index],
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => PostDetailPage(
                    post: posts[index],
                  ),
                ),
              );
            },
          ),
          itemCount: posts.length,
        );
      },
    );
  }
}
// #enddocregion PostsList
