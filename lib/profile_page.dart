import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  TextEditingController _displayNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _displayNameController.text = _user.displayName ?? '';
  }

  void _updateProfile() async {
    String displayName = _displayNameController.text.trim();

    try {
      await _user.updateDisplayName(displayName);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:Icon(Icons.arrow_back),
          onPressed: (){ Navigator.pop(context); },
        ),
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _displayNameController,
              decoration: InputDecoration(labelText: 'Display Name'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
