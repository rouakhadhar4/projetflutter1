import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/signin_request.dart';
import '../models/signup_request.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8085/api/v1/auth';

  // Inscription
  Future<bool> signUp(SignUpRequest signUpRequest) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(signUpRequest.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // Connexion
  Future<String?> signIn(SigninRequest signinRequest) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signin'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(signinRequest.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final token = responseData['token'];

      // Stocker le token dans SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);

      return token;
    } else {
      return null;
    }
  }

  Future<String> checkUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token != null) {
      // Vérification pour l'admin
      final adminResponse = await http.get(
        Uri.parse('$baseUrl/admin'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (adminResponse.statusCode == 200) {
        // Si la réponse est 200, cela signifie que l'utilisateur est un admin
        return 'ADMIN';
      }

      // Vérification pour l'utilisateur
      final userResponse = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (userResponse.statusCode == 200) {
        // Si la réponse est 200, cela signifie que l'utilisateur est un user
        return 'USER';
      }
    }

    return 'UNKNOWN'; // Si le token est invalide ou aucun rôle n'est trouvé
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();

    // Supprimer le JWT token
    await prefs.remove('jwt_token');
  }

// Vérifier si l'email existe déjà
  Future<bool> checkEmail(String email) async {
    final response = await http.get(
      Uri.parse('$baseUrl/check-email?email=$email'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // L'email n'existe pas
      return false;
    } else if (response.statusCode == 400) {
      // L'email existe déjà
      return true;
    } else {
      // Erreur dans la requête
      throw Exception('Failed to check email');
    }
  }


  Future<bool> checkPhone(String phone) async {
    final response = await http.get(
      Uri.parse('$baseUrl/check-phone?phone=$phone'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Le numéro de téléphone n'existe pas
      return false;
    } else if (response.statusCode == 400) {
      // Le numéro de téléphone existe déjà
      return true;
    } else {
      // Erreur dans la requête
      throw Exception('Échec de la vérification du numéro de téléphone');
    }
  }
  Future<bool> requestPasswordReset(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    return response.statusCode == 200;
  }
  Future<bool> verifyResetCode(String email, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-code'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'token': token}),
    );

    return response.statusCode == 200;
  }
  Future<bool> resetPassword(String email, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'newPassword': newPassword}),
      );

      if (response.statusCode == 200) {
        return true;  // Succès de la réinitialisation
      } else {
        // Retourner l'erreur retournée par le backend
        throw Exception('Erreur de réinitialisation : ${response.body}');
      }
    } catch (e) {
      // Gérer les erreurs réseau ou autres erreurs
      print('Exception lors de la réinitialisation : $e');
      return false;
    }
  }




  Future<bool> resendVerificationCode(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/resend-verification-code'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    return response.statusCode == 200;
  }





  // Vérifier si l'utilisateur est authentifié
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('jwt_token');
  }
// Vérifier si l'email existe déjà
// Vérifier si l'email existe déjà
}
