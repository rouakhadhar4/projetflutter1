import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Importer fluttertoast
import 'package:http/http.dart' as http; // Importer http pour gérer les exceptions réseau
import '../services/auth_service.dart';
import 'VerifyCodePage.dart';
import 'LoadingPage.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final AuthService authService = AuthService();
  String? _emailError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_emailFocusNode);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zAZ0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  // Fonction pour vérifier la connexion réseau
  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  // Fonction pour afficher un message d'alerte en cas de connexion absente
  void showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Problème de connexion"),
          content: const Text("Veuillez vérifier votre connexion Internet."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Modifier mot de passe',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Veuillez entrer votre adresse e-mail pour recevoir un code de vérification',
              style: TextStyle(
                color: Color(0xFF80869A),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                setState(() {
                  _emailError = isValidEmail(value) ? null : "L'email ne semble pas valide. Vérifiez le format.";
                });
              },
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(
                  color: Color(0xFF808080),  // Change this to a gray color
                  fontWeight: FontWeight.w500,
                ),

                hintText: 'exemple@gmail.com',
                hintStyle: const TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
                errorText: _emailError,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Vérification de la connexion réseau avant d'envoyer la requête
                  bool connected = await isConnected();
                  if (!connected) {
                    // Si la connexion est perdue, afficher un message spécifique
                    Fluttertoast.showToast(
                      msg: "Connexion perdue. Vérifiez votre réseau.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                    return; // Arrêter l'exécution ici
                  }

                  if (_emailController.text.isEmpty) {
                    setState(() {
                      _emailError = 'Veuillez entrer un email';
                    });
                    return;
                  }

                  if (!isValidEmail(_emailController.text)) {
                    setState(() {
                      _emailError = "L'email ne semble pas valide. Vérifiez le format.";
                    });
                    return;
                  }

                  // Afficher la page de chargement avant de commencer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoadingPage()),
                  );

                  try {
                    bool success = await authService.requestPasswordReset(_emailController.text);

                    // Fermer la page de chargement après la réponse du serveur
                    Navigator.pop(context);

                    if (success) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyCodePage(email: _emailController.text),
                        ),
                      );
                    } else {
                      // Si l'email n'existe pas, afficher un message d'erreur.
                      Fluttertoast.showToast(
                        msg: "Email n'existe pas. Veuillez vous inscrire.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  } catch (e) {
                    // Fermer la page de chargement
                    Navigator.pop(context);

                    // Gestion des erreurs réseau
                    if (e is SocketException || e is http.ClientException) {
                      Fluttertoast.showToast(
                        msg: "Connexion perdue. Vérifiez votre réseau.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    } else {
                      // Vérification si le backend a renvoyé une erreur "Email n'existe pas"
                      if (e.toString().contains("Email n'existe pas")) {
                        Fluttertoast.showToast(
                          msg: "Email n'existe pas. Veuillez vous inscrire.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: "Une erreur s'est produite. Veuillez réessayer.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BCD0),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Envoyer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
