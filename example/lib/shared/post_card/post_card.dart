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

import '../post.dart';

/// A [Card] that displays a single [Post], intended to be used in a list.
class PostCard extends StatelessWidget {
  /// Creates a tappable [PostCard] displaying [post].
  const PostCard({super.key, required this.post, this.onTap});

  /// The post being displayed.
  final Post post;

  /// Executed when this [PostCard] is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(post.author.handle),
                  const Spacer(),
                  Text('${post.time}'),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                post.text,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
