import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<bool> loginWithQRCode(String qrCode) async {
    final url = Uri.parse('$baseUrl/login'); // Adres endpointu logowania
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'qr_code': qrCode}),
    );

    if (response.statusCode == 200) {
      // Obsługa sukcesu logowania
      return true;
    } else {
      // Obsługa błędu
      throw Exception('Failed to log in: ${response.body}');
    }
  }
}
