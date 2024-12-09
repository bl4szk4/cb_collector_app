import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LoginScreen extends StatelessWidget {
  final ApiService apiService = ApiService(baseUrl: 'https://your-api-url.com');

  Future<void> _login(String qrCode, BuildContext context) async {
    try {
      bool success = await apiService.loginWithQRCode(qrCode);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful!')),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final qrCode = ModalRoute.of(context)?.settings.arguments as String?;

    if (qrCode != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _login(qrCode, context);
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text('Logging in')),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
