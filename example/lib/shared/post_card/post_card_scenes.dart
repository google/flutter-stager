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
import 'package:stager/stager.dart';

import '../post.dart';
import '../user.dart';
import 'post_card.dart';

/// A Scene showing a single [PostCard] widget with a fake [Post].
class PostCardScene extends Scene {
  @override
  String get title => 'Single Card';

  @override
  Widget build(BuildContext context) {
    return PostCard(
      post: Post.fakePosts().first,
      onTap: () {},
    );
  }
}

/// A Scene showing a [PostsList] with fake [Post]s.
class PostsListScene extends Scene {
  /// The posts being shown in this scene.
  final List<Post> posts = <Post>[
    Post(
      id: 1,
      author: User.joeUser,
      text: 'Hello, this is a post',
      time: DateTime(2022, 7, 28, 10, 30),
    ),
    Post(
      id: 2,
      author: User.aliceUser,
      text: 'Hi, Joe! Nice to hear from you. This is a much longer reply '
          'intended to test text wrapping in the PostCard widget.',
      time: DateTime(2022, 7, 28, 11, 30),
    ),
    Post(
      id: 3,
      author: User.joeUser,
      text: 'Hi Alice! Thanks for testing that.',
      time: DateTime(2022, 7, 28, 11, 45),
    ),
  ];

  @override
  String get title => 'Card List';

  @override
  Widget build(BuildContext context) {
    return EnvironmentAwareApp(
      home: Container(
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) => PostCard(
            post: posts[index],
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
