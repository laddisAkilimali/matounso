import 'dart:async';
import 'dart:convert';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';
//import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://localhost:9090/matounso/auth';
  final BrowserClient client = BrowserClient()
    ..withCredentials = true; // Utiliser pour Flutter Web

  Future<Map<String, dynamic>> login(String email, String motDePasse) async {
    try {
      final url = Uri.parse('$baseUrl/login');
      final response = await client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'motDePasse': motDePasse}),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      if (data['statut'] == 'success') {
        return {'userName': data['userName'], 'statut': data['statut']};
      } else {
        if (data['statut'] == 'error') {
          return {'message': data['message']};
        }
        return {
          'statut': 'error',
          'message': data['message'] ?? 'Erreur inconnue',
        };
      }
    } on TimeoutException {
      return {'statut': 'erreur', 'message': 'la demande a expire (timeout)'};
    } on ClientException {
      return {
        'statut': 'erreur',
        'message': 'le serveur est momentanement indisponible',
      };
    }
  }

  Future<Map<String, dynamic>> getUserPermissions() async {
    final url = Uri.parse('$baseUrl/userPermissions');
    final response = await client.get(url); // Cookie envoye automatiquement

    if (response.statusCode == 200) {
      final data = List<String>.from(jsonDecode(response.body));

      // Trouver l'element qui commence par "ROLE_"
      final roleItem = data.firstWhere(
        (e) => e.startsWith('ROLE_'),
        orElse: () => 'ROLE_UNKNOWN',
      );

      // Toutes les autres valeurs sont les permissions
      final permissions = data.where((e) => e != roleItem).toList();

      return {'role': roleItem, 'permissions': permissions};
    } else {
      throw Exception('Erreur serveur: ${response.statusCode}');
    }
  }

  // Recuperer toutes les permissions disponibles
  Future<List<String>> getAllPermissions() async {
    final url = Uri.parse('$baseUrl/getAllPermissions');
    try {
      final response = await client
          .get(url)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      if (body is List) {
        return body.map((item) => item.toString()).toList();
      }

      throw const FormatException(
        'Format de reponse inattendu pour les permissions',
      );
    } on TimeoutException {
      throw Exception('La demande a expire (timeout)');
    } on ClientException {
      throw Exception('Le serveur est momentanement indisponible');
    }
  }
}
