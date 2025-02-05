
import 'dart:async';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'ForgotPasswordPage.dart';
import 'ResetPasswordPage.dart';

class VerifyCodePage extends StatefulWidget {
  final String email;

  VerifyCodePage({required this.email});

  @override
  _VerifyCodePageState createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final List<TextEditingController> codeControllers =
  List.generate(6, (_) => TextEditingController());
  final AuthService authService = AuthService();

  int attemptCount = 0;
  bool canResend = true;
  late Timer resendTimer;
  int countdown = 120;
  bool isCodeExpired = false;

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  bool isCodeValid() {
    return codeControllers.every((controller) => controller.text.isNotEmpty);
  }

  void startResendTimer() {
    setState(() {
      canResend = false;
      countdown = 120;
      isCodeExpired = false;
    });

    resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        setState(() {
          canResend = true;
          isCodeExpired = true; // Le code devient invalide après expiration
        });
        resendTimer.cancel();
      }
    });
  }
  void resendCode() async {
    if (attemptCount < 3 && canResend) {
      bool codeSent = await authService.resendVerificationCode(widget.email);
      if (codeSent) {
        setState(() {
          attemptCount++;
          isCodeExpired = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Un nouveau code a été envoyé à ${widget.email}.')),
        );
        startResendTimer();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur lors de l'envoi du code.'")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vous avez atteint le nombre de tentatives. Veuillez répéter le processus.')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
      );
    }
  }
  @override
  void dispose() {
    resendTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vérifier le code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: codeControllers
                  .map((controller) => _buildCodeTextField(controller))
                  .toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (isCodeExpired) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Le code est expiré. Veuillez en demander un nouveau.')),
                  );
                  return;
                }

                if (!isCodeValid()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Veuillez entrer le code complet.')),
                  );
                  return;
                }

                String fullCode = codeControllers.map((c) => c.text).join();
                bool success = await authService.verifyResetCode(widget.email, fullCode);

                if (success) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPasswordPage(
                        email: widget.email,
                        oldPassword: '',
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Code invalide. Veuillez réessayer.')),
                  );
                }
              },
              child: Text('Vérifier le code'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: canResend ? resendCode : null,
              child: Text(canResend ? 'Renvoyer le code' : 'Réessayez dans $countdown sec'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeTextField(TextEditingController controller) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

