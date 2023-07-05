import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PagePlus extends StatelessWidget {
  const PagePlus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const default_padding = EdgeInsets.symmetric(horizontal: 8, vertical: 16);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: default_padding,
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "What's on your mind?",
            ),
            maxLength: 480,
            maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
            maxLines: null,
          ),
        ),
        Padding(
          padding: default_padding,
          child: Text(
            "More coming soon",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary ,
              fontSize: 45,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  File? _imageFile;
  final picker = ImagePicker();
  TextEditingController _captionController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  void _createPost() {
    // TODO: Implement post creation logic, including sending it to people
    // Access the selected image using `_imageFile` and the caption using `_captionController.text`
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildImagePreview(),
            SizedBox(height: 16.0),
            TextField(
              controller: _captionController,
              decoration: InputDecoration(labelText: 'Caption'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _showImageSourceDialog();
              },
              child: Text('Select Photo'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createPost,
              child: Text('Create Post'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_imageFile != null) {
      return Image.file(_imageFile!);
    } else {
      return Placeholder(
        fallbackHeight: 200.0,
      );
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
            child: Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
            child: Text('Gallery'),
          ),
        ],
      ),
    );
  }
}
