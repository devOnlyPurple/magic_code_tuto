import 'package:http/http.dart' as http;

class ConnectivityChecker {
  Future<bool> checkInternetConnectivity() async {
    try {
      final response = await http.get(Uri.parse("https://www.google.com"));
      if (response.statusCode == 200) {
        return true; // Connexion Internet fonctionnelle
      } else {
        return false; // La requête a échoué
      }
    } catch (e) {
      return false; // Une erreur s'est produite
    }
  }
}
