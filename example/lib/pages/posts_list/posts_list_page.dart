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
import 'package:provider/provider.dart';

import '../../shared/api.dart';
import '../../shared/post.dart';
import '../../shared/posts_list/posts_list.dart';

/// Shows a timeline view of all [Post]s.
class PostsListPage extends StatefulWidget {
  /// Creates a [PostsListPage].
  const PostsListPage({super.key});

  @override
  State<PostsListPage> createState() => _PostsListPageState();
}

class _PostsListPageState extends State<PostsListPage> {
  late Future<List<Post>> _fetchPostsFuture;

  @override
  void initState() {
    super.initState();
    _fetchPostsFuture = Provider.of<Api>(context, listen: false).fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: PostsList.fromFuture(_fetchPostsFuture),
    );
  }
}
