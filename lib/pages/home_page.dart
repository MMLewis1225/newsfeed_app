import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/news_post.dart';
import '../components/drawer.dart';
import 'profile_page.dart';
import 'write_article_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  // Sign out
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // Go to profile page
  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  // Go to write article page
  void onWriteArticleTap() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WriteArticlePage(),
      ),
    );
  }

  void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
        'Title': 'Untitled', // Add a default title
        'Category': 'Uncategorized', // Add a default category
      });
      textController.clear();
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    var date = timestamp.toDate();
    return "${date.month}/${date.day}/${date.year}, ${date.hour}:${date.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Color(0xFF00B0BB),
        title: Stack(
          alignment: Alignment.center,
          children: [
            // White text
            Positioned(
              bottom: 1.5,
              left: 0.5,
              child: Text(
                "NewsFeed",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Black text
            Text(
              "NewsFeed",
              style: TextStyle(
                fontSize: 28,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signUserOut,
        onWriteArticleTap: onWriteArticleTap,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // StreamBuilder to display posts
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .orderBy("TimeStamp", descending: true) // New posts first
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data!.docs.map((post) {
                      final timestamp = post['TimeStamp'] as Timestamp;
                      return NewsPost(
                        title: post['Title'] ?? 'Untitled',
                        message: post['Message'] ?? '',
                        userEmail: post['UserEmail'] ?? '',
                        time: formatTimestamp(timestamp),
                        postId: post.id,
                        likes: List<String>.from(post['Likes'] ?? []),
                        category: post['Category'] ?? 'N/A',
                      );
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            // "Logged in as" text at the bottom
            Container(
              color: Colors.grey[300],
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                  "Logged in as ${currentUser.email}",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WriteArticlePage(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF00B0BB), // Match the AppBar color
      ),
    );
  }
}
