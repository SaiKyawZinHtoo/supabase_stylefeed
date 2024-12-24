class Post {
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;

  Post(
      {required this.title,
      required this.description,
      required this.imageUrl,
      required this.createdAt});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
