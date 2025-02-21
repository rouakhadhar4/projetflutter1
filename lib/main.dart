


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectlavage/screens/AboutUsScreen.dart';
import 'package:projectlavage/screens/EditProfilePage.dart';
import 'package:projectlavage/screens/MyHomePage.dart';
import 'package:projectlavage/screens/ProfileScreen.dart';
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
        '/signup': (context) =>
            SignUpScreen(), // Route vers la page d'inscription
        '/signin': (context) => SignInScreen(),
        '/aboutus': (context) => AboutUsScreen(),
        '/profile': (context) => ProfileScreen(),
        '/edit_profile': (context) => EditProfilePage(),
        // Route vers la page de connexion
      },
    );
  }
}