import 'package:http/http.dart' as http;

class ConnectivityChecker {
  static final http.Client _client = http.Client();

  Future<bool> checkInternetConnectivity() async {
    try {
      final response = await _client
          .get(Uri.parse("https://www.google.com"))
          .timeout(Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
