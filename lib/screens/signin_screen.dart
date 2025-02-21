import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:projectlavage/screens/signup_screen.dart';
import 'ForgotPasswordPage.dart';
import 'TechnicienDashboard.dart';
import 'admin_screen.dart';
import 'user_screen.dart';
import '../models/signin_request.dart';
import '../services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _loading = false;
  bool _isObscured = true;

  void _showToast(String message, {Color? color}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: color ?? Colors.red,
      textColor: Colors.white,
    );
  }

  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      bool emailExists = await _authService.checkEmail(_emailController.text);

      if (!emailExists) {
        setState(() {
          _loading = false;
        });
        _showToast('Email not registered. Please sign up first.', color: Colors.red);
      } else {
        final signInRequest = SigninRequest(
          email: _emailController.text,
          password: _passwordController.text,
        );

        final token = await _authService.signIn(signInRequest);
        setState(() {
          _loading = false;
        });

        if (token != null) {
          String role = await _authService.checkUserRole();
          if (role == 'ADMIN') {
            _showToast('Welcome Admin ${_emailController.text}!',color: Color(0xFF00BCD0),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminScreen()),
            );
          }else if (role == 'TECHNICIEN') {
            _showToast('Welcome Technician ${_emailController.text}!', color: Color(0xFF00BCD0));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TechnicienDashboard(),
              ),
            );
          }
          else if (role == 'USER') {
            _showToast('Welcome ${_emailController.text}!', color: Color(0xFF00BCD0));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserScreen(username: _emailController.text),
              ),
            );
          } else {
            _showToast('Invalid role', color: Colors.red);
          }
        } else {
          _showToast('Invalid email or password', color: Colors.red);
        }

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                Text(
                  'Connexion',
                  style: GoogleFonts.robotoFlex(
                    fontSize: 48,
                    color: Color(0xFF00BCD0),
                    fontWeight: FontWeight.normal, // Assure que le texte n'est pas en gras
                    letterSpacing: 1.2, // Optionnel pour améliorer la lisibilité
                  ),

                ),
                SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF00BCD0)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          } else if (!RegExp(r'^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$').hasMatch(value)) {
                            return 'Email should be valid';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),


                  TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscured, // Gère la visibilité du texte
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00BCD0)),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: Color(0xFF00BCD0),
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    } else if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null;
                  },
                ),

              ],
                  ),
                ),
                SizedBox(height: 24),
                _loading
                    ? CircularProgressIndicator() // Loading indicator when signing in
                    : SizedBox(
                  width: 362,
                  height: 65,
                  child: ElevatedButton(
                    onPressed: _handleSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00BCD0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'SE CONNECTER',
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Si vous n\'avez pas de compte? ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'S\'inscrire.',
                        style: TextStyle(
                          color: Color(0xFF00BCD0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                  },
                  child: Text(
                    'Mot de passe oublié?',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 32),
                Image.asset(
                  'assets/images/2.png',
                  width: 270,
                  height: 196,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
