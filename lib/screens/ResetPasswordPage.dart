import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectlavage/screens/signin_screen.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Importer le package fluttertoast

import '../services/auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  final String oldPassword; // Ancien mot de passe

  ResetPasswordPage({required this.email, required this.oldPassword});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final AuthService authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Réinitialiser le mot de passe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Nouveau mot de passe'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  } else if (value.length < 8) {
                    return 'Le mot de passe doit contenir au moins 8 caractères';
                  } else if (value == widget.oldPassword) {
                    return "Le nouveau mot de passe ne peut pas être identique à l'ancien";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                    labelText: 'Confirmer le mot de passe'),
                obscureText: true,
                validator: (value) {
                  if (value != passwordController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    bool success = await authService.resetPassword(
                      widget.email,
                      passwordController.text,
                    );

                    if (success) {
                      // Afficher un toast pour indiquer que le mot de passe a été modifié avec succès
                      Fluttertoast.showToast(
                        msg: "Mot de passe modifié avec succès",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );

                      // Rediriger l'utilisateur vers la page de connexion
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                      );
                    } else {
                      // Affichage d'un message d'erreur
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Mot de passe identique à l\'ancien')),
                      );
                    }
                  }
                },
                child: Text('Réinitialiser le mot de passe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
