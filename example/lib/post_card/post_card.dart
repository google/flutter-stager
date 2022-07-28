import 'package:flutter/material.dart';

import '../shared/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(post.author),
                const Spacer(),
                Text('${post.time}'),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              post.text,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}
