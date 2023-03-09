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

import 'package:equatable/equatable.dart';

import 'user.dart';

/// A single tweet-like entry.
class Post extends Equatable {
  /// Creates a [Post].
  const Post({
    required this.id,
    required this.text,
    required this.author,
    required this.time,
  });

  /// The id of this post.
  final int id;

  /// The content of this post.
  final String text;

  /// The author of this post.
  final User author;

  /// When this post was created.
  final DateTime time;

  @override
  List<Object?> get props => <Object?>[id, text, author, time];

  @override
  String toString() {
    return '$author: $text';
  }

  /// Generates a List of [Post]s. If [user] is specified, all posts will have
  /// that user as an author. If no [user] is specified, each [Post] will have a
  /// distinct fake [User] as its author.
  static List<Post> fakePosts({User? user}) => List<Post>.generate(
        20,
        (int index) => Post(
          id: index + 1,
          text: 'Post ${index + 1}',
          author: user ?? User.fakeUser(id: index + 1),
          time: DateTime(2023, 1, 1, 1).add(Duration(minutes: index)),
        ),
      );
}
