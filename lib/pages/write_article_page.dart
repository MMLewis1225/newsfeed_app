import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/category_button.dart'; // Import the category button component
import '../components/title_design.dart'; // Import the TitleDesign component

class WriteArticlePage extends StatefulWidget {
  @override
  _WriteArticlePageState createState() => _WriteArticlePageState();
}

class _WriteArticlePageState extends State<WriteArticlePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final titleController = TextEditingController();
  final textController = TextEditingController();
  String username = '';
  String selectedCategory = 'N/A';

  final categories = [
    'Entertainment',
    'Health & Lifestyle',
    'Science',
    'Sports',
    'Politics',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  void fetchUsername() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.email)
        .get();
    setState(() {
      username = userDoc['username'];
    });
  }

  void postArticle() {
    if (titleController.text.length >= 7 &&
        titleController.text.length <= 100 &&
        textController.text.isNotEmpty &&
        selectedCategory != 'N/A') {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser.email,
        'UserName': username,
        'Title': titleController.text,
        'Message': textController.text,
        'Category': selectedCategory,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
      Navigator.pop(context);
    }
  }

  void showCategorySelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempCategory = selectedCategory;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12), // Smaller border radius
              ),
              title: Text("Select Category"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      spacing: 8.0,
                      children: categories.map((category) {
                        return CategoryButton(
                          text: category,
                          isSelected: tempCategory == category,
                          onPressed: () {
                            setState(() {
                              tempCategory = category;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: tempCategory != 'N/A'
                      ? () {
                          setState(() {
                            selectedCategory = tempCategory;
                          });
                          Navigator.of(context).pop(); // Close the dialog
                          postArticle(); // Post the article
                        }
                      : null,
                  child: Text("Publish Article"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Smaller border radius
          ),
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void handleContinueButton() {
    String title = titleController.text.trim();
    String article = textController.text.trim();

    if (title.length < 7) {
      showErrorDialog("Title must be at least 7 characters long.");
    } else if (article.isEmpty) {
      showErrorDialog("Article cannot be empty.");
    } else {
      showCategorySelectionDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleDesign(text: "Write Article"),
        backgroundColor: const Color(0xFF00B0BB),
        actions: [
          ElevatedButton(
            onPressed: handleContinueButton,
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color(0xFF00B0BB),
              backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
              // backgroundColor: const Color(0xFF00B0BB),
              side: BorderSide(color: Colors.black), // Black outline
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Smaller border radius
              ),
            ),
            child: Text("Continue"),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFB2FF9E), width: 2),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFB2FF9E), width: 1),
                ),
              ),
              maxLength: 100,
              maxLines: null,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            //  const SizedBox(height: 16),
            Text(
              "By $username",
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            // Custom divider with increased thickness
            Container(
              height: 2, // Thicker divider
              color: Colors.black,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Write your article here...',
                contentPadding: EdgeInsets.all(16),
                border: InputBorder.none, // Remove border
              ),
              maxLines: null,
              minLines: 10,
              expands: false,
            ),
          ],
        ),
      ),
    );
  }
}
