import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/login_field.dart';
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

//go to profile page
  void goToProfilePage() {
    //pop menu drawer
    Navigator.pop(context);
    //go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

//go to write article page
  void onWriteArticleTap() {
    //pop menu drawer
    Navigator.pop(context);
    //go to write article page
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
        title: Text("NewsFeed"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signUserOut,
        onWriteArticleTap: onWriteArticleTap,
      ),
      body: Center(
        child: Column(
          children: [
            // Articles
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy("TimeStamp", descending: true) //new posts first
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        final timestamp = post['TimeStamp'] as Timestamp;
                        return NewsPost(
                          title: post['Title'],
                          message: post['Message'],
                          userEmail:
                              post['UserEmail'], //user: post['UserEmail'],
                          time: formatTimestamp(timestamp),
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                        );
                      },
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
            ),

            // Post an article
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyLoginField(
                      controller: textController,
                      hintText: "Write your article here..",
                      obscureText: false,
                    ),
                  ),

                  // Post button
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.arrow_circle_up),
                  ),
                ],
              ),
            ),

            Text("Logged in as ${currentUser.email}"),
            const SizedBox(height: 50),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/writeArticle');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
