import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/signin_request.dart';
import '../services/auth_service.dart';
import 'ForgotPasswordPage.dart';
import 'admin_screen.dart';
import 'user_screen.dart';


class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  void _showToast(String message, {Color? color}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: color ?? Colors.red,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  // Validation for email format
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  } else if (!RegExp(r'^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$').hasMatch(value)) {
                    return 'Email should be valid and contain "@"';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  // Validation for password length
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Vérifier si l'email existe avant de tenter de se connecter
                    bool emailExists = await _authService.checkEmail(_emailController.text);

                    if (!emailExists) {
                      _showToast('Email not registered. Please sign up first.', color: Colors.red);
                    } else {
                      final signInRequest = SigninRequest(
                        email: _emailController.text, // Using email as username
                        password: _passwordController.text,
                      );
                      final token = await _authService.signIn(signInRequest);
                      if (token != null) {
                        String role = await _authService.checkUserRole();
                        if (role == 'ADMIN') {
                          _showToast('Welcome Admin!', color: Colors.green);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => AdminScreen()),
                          );
                        } else {
                          _showToast('Welcome ${_emailController.text}!', color: Colors.green);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserScreen(username: _emailController.text),
                            ),
                          );
                        }
                      } else {
                        _showToast('Invalid email or password', color: Colors.red); // Message d'erreur pour identifiants incorrects
                      }
                    }
                  }
                },
                child: Text('Sign In'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text("Don't have an account? Sign up"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                },
                child: Text('Mot de passe oublié ?'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
