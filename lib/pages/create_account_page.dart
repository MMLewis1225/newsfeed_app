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
  //text field controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  void signUserUp() async {
    //sign user up method
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
        //check if password matches confirm password
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Pop loading circle and navigate
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // Ensure loading dialog is dismissed
        Navigator.pop(context);
        errorMessage(e.code);
      }
    }
  }

  void errorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          //    backgroundColor: Colors.deepPurple,
          title: Center(
              child: Text(
            message,
            //     style: const TextStyle(color: Colors.white),
          )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Color(0xfff5f0f6),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50), //used to space things out

                //logo
                /*
                const Icon(
                  Icons.newspaper,
                  size: 100,
                ), */

                const Text(
                  'NewsFeed',
                  style: TextStyle(
                    // color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 50),

                //welcome phrase
                const Text(
                  'Welcome!',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20.0,
                  ),
                ),

                const SizedBox(height: 25),

                //username field
                MyLoginField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                //password field
                MyLoginField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // confirm password field
                MyLoginField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                //sign in button
                LoginButton(
                  text: "Create Account",
                  onTap: signUserUp,
                ),

                const SizedBox(height: 30),

                //continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('Or continue with ',
                            style: TextStyle(color: Colors.grey[700])),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                //google sign in
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(imagePath: 'lib/images/google-color-icon.png'),
                  ],
                ),

                const SizedBox(height: 20),

                //create account link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
