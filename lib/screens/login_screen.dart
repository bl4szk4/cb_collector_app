import 'package:flutter/material.dart';
import 'package:pbl_collector/controllers/main_controller.dart';
import '../enums/service_errors.dart';
import '../widgets/buttons/full_width_button.dart';
import '../services/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  final MainController mainController;

  const LoginScreen({super.key, required this.mainController});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String? _message;
  bool _hasAttemptedLogin = false;

  Future<void> _login(String qrCode, BuildContext context) async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    final service = widget.mainController.service;
    final response = await service.login(qrCode);

    setState(() {
      _isLoading = false;
      if (response.error == ServiceErrors.ok) {
        _message = AppLocalizations.of(context)!.translate('login_success');
        Navigator.pushReplacementNamed(context, '/main-screen');
      } else {
        _message = 'Login failed: ${response.error.toString()}';
        Navigator.pushReplacementNamed(context, '/home-screen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final qrCode = ModalRoute.of(context)?.settings.arguments as String?;

    if (qrCode != null && !_hasAttemptedLogin) {
      _hasAttemptedLogin = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _login(qrCode, context);
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.translate('logging_in'))),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_message != null) ...[
              Text(
                _message!,
                style: TextStyle(
                  fontSize: 16,
                  color: _message == 'Login successful!'
                      ? Colors.green
                      : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
            if (_message != null && _message!.contains('Login failed')) ...[
              FullWidthButton(
                text: AppLocalizations.of(context)!.translate('return'),
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
              ),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}
