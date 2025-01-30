import 'package:flutter/material.dart';
import 'package:projectlavage/screens/signin_screen.dart'; // Assurez-vous que vous importez la page de connexion
import 'package:projectlavage/services/auth_service.dart'; // Importez le service d'authentification

class AdminScreen extends StatelessWidget {
  // Instance du service AuthService
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello Admin'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // Appel de la méthode signOut depuis le service
              await authService.signOut();

              // Rediriger l'utilisateur vers la page de connexion après la déconnexion
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(child: Text('Welcome, Admin!')),
    );
  }
}
