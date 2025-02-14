import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectlavage/screens/signin_screen.dart';
import '../models/signup_request.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;


  void _showToast(String message, {Color? color}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: color ?? Colors.red,
      textColor: Colors.white,
    );
  }
  void _showConfirmSignUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xFF00BCD0),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 80,
                    ),
                    Positioned(
                      top: 30,
                      right: 50,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Color(0xFF8ED3ED),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 50,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Color(0xFF8ED3ED),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Félicitations !',
                  style: GoogleFonts.rochester(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Inscription réussie ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                          (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00BCD0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Retour à la connexion',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'S\'inscrire',
                    style: GoogleFonts.rochester(
                      fontSize: 64,
                      color: const Color(0xFF00BCD0),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildInputField('Email Address', _emailController, (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    } else if (!RegExp(r'^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$').hasMatch(value)) {
                      return 'Email should be valid and contain "@"';
                    }
                    return null;
                  }),
                  const SizedBox(height: 16),
                  _buildInputField('Username', _usernameController, (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    } else if (value.length < 3 || value.length > 50) {
                      return 'Username must be between 3 and 50 characters';
                    }
                    return null;
                  }),
                  const SizedBox(height: 16),
                  _buildInputField('Phone Number', _phoneController, (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    } else if (!RegExp(r"^\+?[0-9]{8}$").hasMatch(value)) {
                      return 'Phone number must be up to 8 digits';
                    }
                    return null;
                  }),
                  const SizedBox(height: 16),
                  _buildPasswordInputField(
                      'Password', _isPasswordVisible, (isVisible) {
                    setState(() {
                      _isPasswordVisible = isVisible;
                    });
                  }, _passwordController),
                  const SizedBox(height: 16),
                  _buildPasswordInputField(
                      'Confirm Password', _isConfirmPasswordVisible, (isVisible) {
                    setState(() {
                      _isConfirmPasswordVisible = isVisible;
                    });
                  }, _confirmPasswordController, isConfirmPassword: true),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_passwordController.text != _confirmPasswordController.text) {
                            _showToast('Passwords do not match!');
                            return;
                          }
                          bool emailExists = await _authService.checkEmail(_emailController.text);
                          bool phoneExists = await _authService.checkPhone(_phoneController.text);

                          if (phoneExists) {
                            _showToast('Phone number already exists. Please choose another one.');
                          } else if (emailExists) {
                            _showToast('Email already exists. Please choose another one.');
                          } else {
                            final signUpRequest = SignUpRequest(
                              email: _emailController.text,
                              username: _usernameController.text,
                              password: _passwordController.text,
                              confirmPassword: _confirmPasswordController.text,
                              phone: _phoneController.text,
                            );
                            final success = await _authService.signUp(signUpRequest);
                            if (success) {
                              _showConfirmSignUpDialog();  // Show the custom dialog
                            } else {
                              _showToast('An error occurred. Please try again.');
                            }

                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BCD0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'S\'INSCRIRE',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Ou avec",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      // Action pour connexion avec Google
                    },
                    child: Text(
                      "Se connecter avec Google",
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Vous avez déjà un compte? ',
                        style: TextStyle(fontSize: 16, color: Color(0xFF808080)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignInScreen()),
                          );
                        },
                        child: const Text(
                          'Se connecter.',
                          style: TextStyle(
                            color: Color(0xFF00BCD0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, String? Function(String?) validator) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF00BCD0)),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordInputField(String label, bool isVisible, Function(bool) onVisibilityToggle, TextEditingController controller, {bool isConfirmPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF435783)),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () => onVisibilityToggle(!isVisible),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        if (isConfirmPassword && value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}
