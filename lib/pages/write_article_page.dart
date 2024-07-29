import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WriteArticlePage extends StatefulWidget {
  @override
  _WriteArticlePageState createState() => _WriteArticlePageState();
}

class _WriteArticlePageState extends State<WriteArticlePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final titleController = TextEditingController();
  final textController = TextEditingController();
  String username = '';

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  void fetchUsername() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email) // Assuming email is used as the document ID
        .get();
    setState(() {
      username = userDoc['username'];
    });
  }

  void postArticle() {
    if (titleController.text.length >= 7 &&
        titleController.text.length <= 100 &&
        textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'UserName': username, // Include the username in the post
        'Title': titleController.text,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
        //   'Views': [],
      });
      Navigator.pop(context); // Go back to the previous page after posting
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Write Article"),
        actions: [
          IconButton(
            onPressed: postArticle,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title (min 7 letters, max 100)',
                border: OutlineInputBorder(),
              ),
              maxLength: 100,
            ),
            const SizedBox(height: 8),
            //Text("By ${currentUser.email}"),
            Text("By $username"),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Write your article here...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true, // Align hint with the top-left
                ),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
