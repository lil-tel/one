import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PagePeople extends StatefulWidget {
  const PagePeople({super.key});

  @override
  _PagePeopleState createState() => _PagePeopleState();
}

class _PagePeopleState extends State<PagePeople> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _newFriendController = TextEditingController();
  late CollectionReference _friendsCollection;

  @override
  void initState() {
    super.initState();
    _friendsCollection = _firestore.collection('friends');
  }

  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _friendsCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                List<String>? friends = snapshot.data?.docs.map((doc) => doc['name'] as String).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Friends',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: friends?.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(friends![index]),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteFriend(snapshot.data!.docs[index].reference),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Add Friend',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newFriendController,
                    decoration: InputDecoration(
                      hintText: 'Enter friend name',
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: _addFriend,
                  child: Text('Add'),
                ),
              ],
            ),
          ],
        ),
      );
  }

  void _addFriend() async {
    String newFriend = _newFriendController.text.trim();
    if (newFriend.isNotEmpty) {
      await _friendsCollection.add({'name': newFriend});
      _newFriendController.clear();
    }
  }

  Future<void> _deleteFriend(DocumentReference friendRef) async {
    try {
      await friendRef.delete();
    } catch (e) {
      print('Error deleting friend: $e');
    }
  }
}
