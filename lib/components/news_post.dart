import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/like_button.dart';
import '../pages/detailed_post_page.dart';

class NewsPost extends StatefulWidget {
  final String title;
  final String message;
  final String userEmail; // Updated from 'user' to 'userEmail'
  final String time;
  final String postId;
  final List<String> likes; // Contains list of all users that liked it
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
  String username = '';
  String bio = '';

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
    fetchUserData();
  }

  void fetchUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userEmail)
        .get();
    setState(() {
      username = userDoc['username'];
      bio = userDoc['bio'];
    });
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailPage(postId: widget.postId),
          ),
        );
      },
      child: StreamBuilder<DocumentSnapshot>(
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
                color: Color(0xFFB2FF9E),
                borderRadius: BorderRadius.circular(2),
              ),
              padding: EdgeInsets.only(top: 10, left: 0, right: 25),
              margin: EdgeInsets.all(25),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(username,
                          style: TextStyle(
                              //  color: Colors.[500],
                              fontStyle: FontStyle.italic)),
                      const SizedBox(height: 10),
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 20, // Increased font size
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),

                      Divider(),
                      //   const SizedBox(height: 10),
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
                    ],
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF00B0BB), // Category box color
                        //borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.category,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          //     color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
