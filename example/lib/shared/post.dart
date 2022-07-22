class Post {
  final int id;
  final String text;

  Post({
    required this.id,
    required this.text,
  });

  static List<Post> fakePosts = List.generate(
    20,
    (index) => Post(
      id: index + 1,
      text: 'Post ${index + 1}',
    ),
  );
}
