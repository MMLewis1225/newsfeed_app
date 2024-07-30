import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostDetailPage extends StatefulWidget {
  final String postId;

  const PostDetailPage({Key? key, required this.postId}) : super(key: key);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    fetchPostDetails();
  }

  void fetchPostDetails() async {
    DocumentSnapshot postDoc = await FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postId)
        .get();

    setState(() {
      likeCount = (postDoc['Likes'] as List<dynamic>).length;
      isLiked = (postDoc['Likes'] as List<dynamic>).contains(currentUser.email);
    });
  }

  void toggleLike() async {
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      await postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
      setState(() {
        isLiked = false;
        likeCount--;
      });
    } else {
      await postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
      setState(() {
        isLiked = true;
        likeCount++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Details"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('User Posts')
            .doc(widget.postId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final post = snapshot.data!;
            final timestamp = post['TimeStamp'] as Timestamp;
            final formattedTime = formatTimestamp(timestamp);
            final username = post['UserName'];
            final message = post['Message'];
            final title = post['Title'];
            final category = post['Category'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "By $username",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Category: $category",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    formattedTime,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        message,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: toggleLike,
        icon: Icon(
          isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
        ),
        label: Text('$likeCount'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    var date = timestamp.toDate();
    return "${date.month}/${date.day}/${date.year}, ${date.hour}:${date.minute}";
  }
}
