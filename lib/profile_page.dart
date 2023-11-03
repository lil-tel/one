import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _user;
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  String _email = '';
  String _phoneNumber = '';
  String _gender = '';
  DateTime _birthday = DateTime(1975, 10, 4);

  int _numberOfChains = 0;
  File? _profilePicture;

  String _currentEmail = '';
  String _currentPhoneNumber = '';

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _displayNameController.text = _user.displayName ?? '';

    _fetchUserProfile();
  }

  void _fetchUserProfile() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await _firestore.collection('users').doc(_user.uid).get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data()!;
      setState(() {
        _email = userData['email'];
        _phoneNumber = userData['phoneNumber'];
        _gender = userData['gender'];
        _birthday = userData['birthday']?.toDate();
        _bioController.text = userData['bio'] ?? '';
        _numberOfChains = userData['numberOfChains'] ?? 0;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _profilePicture = File(pickedFile.path);
      });
    }
  }

  void _updateProfile() async {
    String displayName = _displayNameController.text.trim();
    String bio = _bioController.text.trim();

    try {
      await _user.updateDisplayName(displayName);

      if (_profilePicture != null) {
        // Upload the profile picture to Firebase Storage
        String profilePictureUrl = await _uploadProfilePicture(_profilePicture!);

        // Update the user's profile picture URL in Firestore
        await _firestore.collection('users').doc(_user.uid).set({
          'displayName': displayName,
          'bio': bio,
          'profilePictureUrl': profilePictureUrl,
        }, SetOptions(merge: true));
      } else {
        // If no new profile picture is selected, update only the display name and bio
        await _firestore.collection('users').doc(_user.uid).set({
          'displayName': displayName,
          'bio': bio,
        }, SetOptions(merge: true));
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile. Please try again.'),
        ),
      );
    }
  }

  Future<String> _uploadProfilePicture(File profilePicture) async {
    try {
      // Generate a unique filename for the profile picture
      String fileName = '${_user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Create a reference to the Firebase Storage location
      final Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

      // Upload the file to Firebase Storage
      await storageRef.putFile(profilePicture);

      // Get the download URL for the uploaded file
      String downloadUrl = await storageRef.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      // Handle any errors that occur during the upload process
      throw Exception('Failed to upload profile picture');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _profilePicture != null
                    ? FileImage(_profilePicture!)
                    : null,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                    child: const Text('Choose Photo'),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                    child: const Text('Take Photo'),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _displayNameController,
                decoration: const InputDecoration(labelText: 'Display Name'),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Email',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(_email),
              TextFormField(
                onChanged: (newEmail) {
                  setState(() {
                    _currentEmail = newEmail;
                  });
                },
                decoration: const InputDecoration(labelText: 'New email address'),
              ),
              Visibility(
                visible: _currentEmail.isNotEmpty,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      // Send a verification email to the new email address
                      await _user.verifyBeforeUpdateEmail(_currentEmail);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Confirmation email sent. Verify to update your email.'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to send confirmation email. Please try again.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Send Confirmation Email'),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Phone Number',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(_phoneNumber),
              TextFormField(
                onChanged: (newPhoneNumber) {
                  setState(() {
                    _currentPhoneNumber = newPhoneNumber;
                  });
                },
                decoration: const InputDecoration(labelText: 'New Phone Number'),
              ),
              Visibility(
                visible: _currentPhoneNumber.isNotEmpty,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      // Send a verification code via SMS to the new phone number
                      await _auth.verifyPhoneNumber(
                        phoneNumber: _currentPhoneNumber,
                        verificationCompleted: (phoneAuthCredential) {},
                        verificationFailed: (verificationFailed) {},
                        codeSent: (verificationId, [forceResendingToken]) {},
                        codeAutoRetrievalTimeout: (verificationId) {},
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('SMS verification sent. Enter the code to update your phone number.'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to send SMS verification. Please try again.'),
                        ),
                      );
                    }
                  },
                  child: Text('Send Confirmation SMS'),
                ),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _gender,
                items: ['Male', 'Female', 'Non-binary', 'Other']
                    .map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _gender = newValue!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Birthday',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(DateFormat.yMMMMd(Intl.systemLocale).format(_birthday)),
              ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _birthday,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (selectedDate != null) {
                    setState(() {
                      _birthday = selectedDate;
                    });
                  }
                },
                child: Text('Pick Birthday'),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Bio',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: 'Bio'),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Number of Chains',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(_numberOfChains.toString()),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _updateProfile,
                child: const Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
