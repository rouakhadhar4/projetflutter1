import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For TextInputFormatter

import '../services/auth_service.dart';
import 'VerifyCodePage.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final AuthService authService = AuthService();

  ForgotPasswordPage({super.key});

  // Function to validate the email format with a simple regex
  bool isValidEmail(String email) {
    // Regular expression to check if email contains '@' and a basic format
    final emailRegex = RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Réinitialisation du mot de passe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TextField for the email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Entrez votre email ici',
                errorText: emailController.text.isNotEmpty &&
                    !isValidEmail(emailController.text)
                    ? 'L\'email ne semble pas valide. Vérifiez le format.'
                    : null, // Display error if the email is invalid
                errorStyle: TextStyle(
                  color: Colors.redAccent, // Customize error text color
                  fontSize: 14, // Customize font size for error
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Check if email is not empty and valid
                if (emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Veuillez entrer un email')),
                  );
                  return;
                }

                if (!isValidEmail(emailController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(
                        'L\'email ne semble pas valide. Vérifiez le format.')),
                  );
                  return;
                }

                // Request password reset
                bool success = await authService.requestPasswordReset(
                    emailController.text);
                if (success) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VerifyCodePage(email: emailController.text),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(
                        "Échec de la demande de réinitialisation ,Email Adresse n'existe pas")),
                  );
                }
              },
              child: Text('Envoyer le code de vérification'),
            ),
          ],
        ),
      ),
    );
  }
}
