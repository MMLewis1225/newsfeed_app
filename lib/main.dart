import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/auth_page.dart';
import 'pages/home_page.dart';
import 'pages/write_article_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const AuthPage(),
      routes: {
        '/home': (context) => HomePage(),
        '/writeArticle': (context) => WriteArticlePage(),
      },
    );
  }
}
