import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:one/create_post.dart';

class PagePlus extends StatefulWidget {
  PagePlus({Key? key}) : super(key: key);

  @override
  _PagePlusState createState() => _PagePlusState();
}

class _PagePlusState extends State<PagePlus>{

  final TextEditingController _postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const defaultPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 16);
    String malone = _postController.text.trim();
    print(malone);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: defaultPadding,
          child: TextField(
            controller: _postController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "What's on your mind?",
            ),
            maxLength: 480,
            maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
            maxLines: null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    _createPost();
                  },
                  child: Text('Create Post')
              ),
              TextButton(
                  child: Text('Or import a file'),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ImportFile()));
                  }
              )
            ],
          ),
        )
      ],
    );
  }

  void _createPost() {
    String postText = _postController.text.trim();

    if (postText.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreatePostPage(postText: postText, context: context)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a post.'),
        ),
      );
    }
  }

}


class ImportFile extends StatefulWidget {
  @override
  _ImportFileState createState() => _ImportFileState();
}

class _ImportFileState extends State<ImportFile> {
  File? _imageFile;
  final picker = ImagePicker();
  final TextEditingController _captionController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  void _createImage() {
    String caption = _captionController.text.trim();

    if (/*caption.isNotEmpty ||*/ _imageFile != null) {
      // TODO: Implement post creation logic, including sending it to people
      // Access the selected image using `_imageFile` and the caption using `_captionController.text`
      if (caption.isNotEmpty) {
        print('Text Post: $caption');
      }
      if (_imageFile != null) {
        print('Image File: $_imageFile');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a caption or select a photo.'),
        ),
      );
    }
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
              onPressed: _createImage,
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
