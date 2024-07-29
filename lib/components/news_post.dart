import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/like_button.dart';

class NewsPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes; //contains list of all users that liked it

  const NewsPost({
    super.key,
    required this.message,
    required this.user,
    required this.time,
    required this.postId,
    required this.likes,
    //has viewed-- when user clicks on read me button and opens it
  });

  @override
  State<NewsPost> createState() => _NewsPostState();
}

class _NewsPostState extends State<NewsPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    //access the document in firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      //if post is liked, add the user's email to the likes list
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      //if post is unliked, remove the user from likes list
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          Text(widget.user, style: TextStyle(color: Colors.grey[500])),
          const SizedBox(height: 10),
          Text(
            widget.message,
            maxLines: null, // Allows the text to wrap
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.time),
              //wrap together

              Row(
                children: [
                  LikeButton(isLiked: isLiked, onTap: toggleLike),
                  // Icon(Icons.thumb_up, color: Colors.grey, size: 20),
                  const SizedBox(
                      width:
                          5), // Add some space between the icon and the count

                  Text(widget.likes.length.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                      )),

                  /*
                  Text(
            widget.text, // Use the text parameter
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
                  */
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
