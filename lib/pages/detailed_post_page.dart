import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/title_design.dart'; // Import the TitleDesign component

class PostDetailPage extends StatefulWidget {
  final String postId;

  const PostDetailPage({super.key, required this.postId});

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
        title: const TitleDesign(text: "Read Post"),
        backgroundColor: const Color(0xFF00B0BB),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('User Posts')
                  .doc(widget.postId)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final post = snapshot.data!;
                  final category = post['Category'];
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB2FF9E),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
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

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "By $username",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontStyle: FontStyle.italic),
                        ),
                        Text(
                          formattedTime,
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(
                      thickness: 2.0,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
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
        backgroundColor: const Color(0xFF00B0BB),
      ),
    );
  }

  String formatTimestamp(Timestamp timestamp) {
    var date = timestamp.toDate();
    return "${date.month}/${date.day}/${date.year}, ${date.hour}:${date.minute}";
  }
}
