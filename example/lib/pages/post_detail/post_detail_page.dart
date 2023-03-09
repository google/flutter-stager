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

import '../../shared/post.dart';
import '../user_detail/user_detail_page.dart';

/// A page for a single [Post].
class PostDetailPage extends StatelessWidget {
  /// Creates a [PostDetailPage].
  const PostDetailPage({super.key, required this.post});

  /// The [Post] being displayed.
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
        actions: <PopupMenuButton<int>>[
          PopupMenuButton<int>(
            onSelected: (_) {
              final NavigatorState navigatorstate = Navigator.of(context);
              navigatorstate.push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      UserDetailPage(user: post.author),
                ),
              );
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 0,
                child: Text('View User'),
              ),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  child: Text(
                    post.author.name
                        .split(' ')
                        .map((String e) => e[0].toUpperCase())
                        .join(),
                  ),
                ),
                const SizedBox(width: 10),
                Text(post.time.toString()),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              post.text,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
