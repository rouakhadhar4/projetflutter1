
import 'package:flutter/material.dart';
import 'package:projectlavage/screens/MyHomePage.dart';
import 'package:projectlavage/screens/signin_screen.dart';
import 'package:projectlavage/screens/signup_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Authentication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(), // Page d'accueil (connexion)
      routes: {
        '/signup': (context) => SignUpScreen(), // Route vers la page d'inscription
        '/signin': (context) => SignInScreen(), // Route vers la page de connexion
      },
    );
  }
}
