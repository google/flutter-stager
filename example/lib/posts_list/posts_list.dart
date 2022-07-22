import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../shared/api.dart';
import '../shared/post.dart';

class PostsList extends StatefulWidget {
  final Api api;

  const PostsList({super.key, required this.api});

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  late Future<List<Post>> _fetchPostsFuture;

  @override
  void initState() {
    super.initState();
    _fetchPostsFuture = widget.api.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: FutureBuilder(
        future: _fetchPostsFuture,
        builder: (context, snapshot) {
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

          final posts = snapshot.data;
          if (posts == null || posts.isEmpty) {
            return const Center(
              child: Text('No posts'),
            );
          }

          return ListView.separated(
            itemBuilder: (context, index) => ListTile(
              title: Text(posts[index].text),
            ),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: posts.length,
          );
        },
      ),
    );
  }
}
