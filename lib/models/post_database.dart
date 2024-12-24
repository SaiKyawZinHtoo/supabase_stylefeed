import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:superbase_project/models/post_model.dart';

class PostDatabase {
  final database = Supabase.instance.client.from('posts');

  // Create a new post
  Future<void> createPost(Post newPost) async {
    await database.insert(newPost.toMap());
  }

  // Stream all posts
  final stream = Supabase.instance.client.from('posts').stream(
    primaryKey: ['id'],
  ).map((data) => data.map((postMap) => Post.fromJson(postMap)).toList());

  // Update a post
  Future<void> updatePost(Post oldPost, String newDescription) async {
    await database.update({'description': newDescription}).eq('id', oldPost.id);
  }

  // Delete a post
  Future<void> deletePost(Post post) async {
    await database.delete().eq('id', post.id);
  }
}
