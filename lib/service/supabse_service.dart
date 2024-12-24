// import 'dart:io';

// import 'package:supabase_flutter/supabase_flutter.dart';

// class SupabaseService {
//   final _client = Supabase.instance.client;

//   Future<String> uploadImage(String bucket, String path, String filePath) async {
//     try {
//       final response = await _client.storage.from(bucket).upload(path, filePath as File);
//       if (response.error != null) {
//         throw Exception('Image upload failed: ${response.error!.message}');
//       }
//       return _client.storage.from(bucket).getPublicUrl(path);
//     } catch (e) {
//       throw Exception('Error uploading image: $e');
//     }
//   }

//   Future<void> savePost(String title, String description, String imageUrl) async {
//     try {
//       final response = await _client.from('posts').insert({
//         'title': title,
//         'description': description,
//         'image_url': imageUrl,
//       })._execute();
//       if (response.error != null) {
//         throw Exception('Failed to save post: ${response.error!.message}');
//       }
//     } catch (e) {
//       throw Exception('Error saving post: $e');
//     }
//   }
// }
