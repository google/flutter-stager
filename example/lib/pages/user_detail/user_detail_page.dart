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
import '../../shared/user.dart';

/// A page for a single [User].
class UserDetailPage extends StatefulWidget {
  /// Creates a [UserDetailPage] which displays information about [user].
  const UserDetailPage({super.key, required this.user});

  /// The [User] whose info is being displayed.
  final User user;

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late Future<List<Post>> _userPostsFuture;

  @override
  void initState() {
    super.initState();

    _userPostsFuture = Provider.of<Api>(context, listen: false).fetchPosts(
      user: widget.user,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user.name,
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              '${widget.user.name} (${widget.user.handle})',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          Expanded(
            child: PostsList.fromFuture(_userPostsFuture),
          ),
        ],
      ),
    );
  }
}
