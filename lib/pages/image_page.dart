import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  XFile? selectedImage;
  bool isLoading = false;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  Future<void> handleUpload() async {
    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedImage == null) {
      _showSnackBar('Please fill all fields and select an image.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await uploadPost(
        titleController.text,
        descriptionController.text,
        selectedImage!,
      );
      _showSnackBar('Post uploaded successfully!');
    } catch (e) {
      _showSnackBar('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> uploadPost(
    String title,
    String description,
    XFile imageFile,
  ) async {
    final storage = Supabase.instance.client.storage;
    final bucket = storage.from('images');

    // Generate a unique name for the image
    final imageName = DateTime.now().toIso8601String() + '.jpg';

    try {
      // Upload image to storage
      final uploadResponse =
          await bucket.upload(imageName, File(imageFile.path));

      if (uploadResponse == null) {
        throw Exception('Image upload failed.');
      }

      // Get public URL for the uploaded image
      final imageUrl = bucket.getPublicUrl(imageName);

      // Save data to the database
      final response = await Supabase.instance.client.from('posts').insert({
        'title': title,
        'description': description,
        'image_url': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (response.error != null) {
        throw Exception('Failed to save post: ${response.error!.message}');
      }
    } catch (e) {
      throw Exception('Upload failed: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            if (selectedImage != null)
              Image.file(
                File(selectedImage!.path),
                height: 200,
                width: 200,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: handleUpload,
                    child: const Text('Upload Post'),
                  ),
          ],
        ),
      ),
    );
  }
}
