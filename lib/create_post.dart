import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CreatePostPage extends StatelessWidget {
  final String? postText;
  final String? caption;
  final File? imageFile;
  final BuildContext context;

  const CreatePostPage({Key? key, this.postText, this.caption, this.imageFile, required this.context}) : super(key: key);

  void _sendPost() async {
    if (postText != null) {
      try {
        final FirebaseFirestore firestore = FirebaseFirestore.instance;

        final DocumentReference postRef = firestore.collection('posts').doc();

        final Map<String, dynamic> postData = {
          'postText': postText,
          'caption': caption ?? '',
          'timestamp': FieldValue.serverTimestamp(),
        };

        await postRef.set(postData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Post sent successfully'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send post. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        actions: [IconButton(onPressed: _sendPost, icon: Icon(Icons.send))],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (postText != null)
              Text(
                postText!,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (imageFile != null) Image.file(imageFile!),
            if (caption != null)
              Text(
                caption!,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
