import 'dart:async';
import 'dart:convert';

import 'package:http/browser_client.dart';
import 'package:http/http.dart';

class InscriptionUtilisateurService {
  final String baseUrl = 'http://localhost:9090/matounso/personnel';
  final BrowserClient client = BrowserClient()..withCredentials = true;

  Future<String> inscriptionUtilisateur(
    String? nom,
    String? postNom,
    String? preNom,
    String? sexe,
    DateTime? dateNaissance,
    String? lieuNaissance,
    String? nationalite,
    String? ville,
    String? quartier,
    String? avenue,
    String? numeroMaison,
    String? role,
    List<String>? permissionsSelectionnees,
    String? numeroTelephone,
    String? email,
    String? motDePasse,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/inscription');
      final response = await client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'nom': nom,
              'postNom': postNom,
              'preNom': preNom,
              'sexe': sexe,
              'dateNaissance': dateNaissance?.toIso8601String(),
              'lieuNaissance': lieuNaissance,
              'nationalite': nationalite,
              'ville': ville,
              'quartier': quartier,
              'avenue': avenue,
              'numeroMaison': numeroMaison,
              'role': role,
              'permissions': permissionsSelectionnees,
              'numeroTelephone': numeroTelephone,
              'email': email,
              'motDePasse': motDePasse,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      if (data['statut'] == "succes") {
        return data['statut'];
      } else {
        return data['message'] ?? 'Erreur inconnue';
      }
    } on TimeoutException {
      return 'la demande a expire (timeout)';
    } on ClientException {
      return 'le serveur est momentanement indisponible';
    }
  }
}
