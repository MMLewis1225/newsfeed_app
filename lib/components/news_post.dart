import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/like_button.dart';

class NewsPost extends StatefulWidget {
  final String title;
  final String message;
  final String userEmail; // Updated from 'user' to 'userEmail'
  final String time;
  final String postId;
  final List<String> likes; //contains list of all users that liked it
  final String category;

  const NewsPost({
    super.key,
    required this.title,
    required this.message,
    required this.userEmail, // Updated from this.user
    required this.time,
    required this.postId,
    required this.likes,
    required this.category, // Add this line
  });

  @override
  State<NewsPost> createState() => _NewsPostState();
}

class _NewsPostState extends State<NewsPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  String username = ''; // For storing the fetched username
  String bio = ''; // For storing the fetched bio

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
    fetchUserData(); // Fetch the user data when the widget initializes
  }

  void fetchUserData() async {
    // Fetch user data from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userEmail)
        .get();
    setState(() {
      username = userDoc['username'];
      bio = userDoc['bio']; // Get the bio from the document
    });
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    // Access the document in Firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      // If post is liked, add the user's email to the likes list
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      // If post is unliked, remove the user from likes list
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userEmail)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userDoc = snapshot.data!;
          final username = userDoc['username'];
          final bio = userDoc['bio'];

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.only(top: 25, left: 25, right: 25),
            padding: EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(username,
                    style: TextStyle(
                        color: Colors.grey[500], fontStyle: FontStyle.italic)),
                const SizedBox(height: 10),
                Text(
                  widget.title,
                  maxLines: null,
                  overflow: TextOverflow.visible,
                ),
                Text(
                  widget.message,
                  maxLines: null,
                  overflow: TextOverflow.visible,
                ),
                Text(
                  "Category: ${widget.category}", // Display the category
                  style: TextStyle(
                      color: Colors.grey[600], fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.time),
                    Row(
                      children: [
                        LikeButton(isLiked: isLiked, onTap: toggleLike),
                        const SizedBox(width: 5),
                        Text(widget.likes.length.toString(),
                            style: const TextStyle(
                              fontSize: 20,
                            )),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 5),
                Text(
                  "${username}'s bio: $bio",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}
