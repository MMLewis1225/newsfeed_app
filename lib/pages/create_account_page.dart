import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/login_field.dart';
import '../components/login_button.dart';
import '../components/square_tile.dart';

class CreateAccountPage extends StatefulWidget {
  final Function()? onTap;
  const CreateAccountPage({super.key, required this.onTap});

  @override
  State<CreateAccountPage> createState() => CreateAccountPageState();
}

class CreateAccountPageState extends State<CreateAccountPage> {
  // Text field controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController(); // Username controller

  void signUserUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);
      errorMessage("Passwords do not match");
    } else {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('username', isEqualTo: usernameController.text)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          Navigator.pop(context);
          errorMessage("Username already taken");
        } else {
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          Navigator.pop(context);

          await FirebaseFirestore.instance
              .collection("Users")
              .doc(userCredential.user!.email!)
              .set({'username': usernameController.text, 'bio': 'Empty bio..'});
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        errorMessage(e.message ?? "Error");
      }
    }
  }

  void errorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text(message)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff6665DD), // Purple background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70),

                // Logo
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "Welcome!" text
                      const Text(
                        'Welcome!',
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // "NewsFeed" text with 3D effect
                      Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Positioned(
                            left: 2,
                            top: 2,
                            child: const Text(
                              'NewsFeed',
                              style: TextStyle(
                                fontSize: 36,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Text(
                            'NewsFeed',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // Fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: MyLoginField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: MyLoginField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: MyLoginField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: MyLoginField(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                  ),
                ),
                const SizedBox(height: 25),

                // Create Account button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: LoginButton(
                    text: "Create Account",
                    onTap: signUserUp,
                  ),
                ),

                const SizedBox(height: 20),

                // Sign in link
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                              color: Color(0xFFB2FF9E),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
