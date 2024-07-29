import 'package:flutter/material.dart';
import 'package:newsfeed_app/pages/login_page.dart';
import 'package:newsfeed_app/pages/create_account_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
//show login page intially
  bool showLoginPage = true;

//toggle between login and register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return CreateAccountPage(
        onTap: togglePages,
      );
    }
  }
}
