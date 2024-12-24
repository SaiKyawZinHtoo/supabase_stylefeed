class Post {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
