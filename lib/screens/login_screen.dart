import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pbl_collector/controllers/main_controller.dart';
import '../enums/service_errors.dart';
import '../widgets/buttons/full_width_button.dart';
import '../services/app_localizations.dart';
import '../widgets/navigators/go_back_navigator.dart';

class LoginScreen extends StatefulWidget {
  final MainController mainController;
  final bool withCredentials;

  const LoginScreen({
    Key? key,
    required this.mainController,
    this.withCredentials = false,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  String? _message;
  bool _hasAttemptedLogin = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(String qrCode, BuildContext context) async {
    setState(() {
      _isLoading = true;
      _message = null;
    });
    final Map<String, dynamic> credentials = jsonDecode(qrCode);
    if (!credentials.containsKey('username') || !credentials.containsKey('password')) {
      setState(() {
        _isLoading = false;
        _message = AppLocalizations.of(context)!.translate('invalid_credentials');
      });
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }
    final String username = credentials['username'];
    final String password = credentials['password'];

    final service = widget.mainController.service;
    final response = await service.login(username, password);

    setState(() {
      _isLoading = false;
      if (response.error == ServiceErrors.ok) {
        _message = AppLocalizations.of(context)!.translate('login_success');
      } else {
        _message = AppLocalizations.of(context)!.translate('invalid_credentials');
      }
    });

    if (response.error == ServiceErrors.ok) {
      Navigator.pushReplacementNamed(context, '/main-screen');
    } else {
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _manualLogin(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final service = widget.mainController.service;
    final response = await service.login(username, password);

    setState(() {
      _isLoading = false;
      if (response.error == ServiceErrors.ok) {
        _message = AppLocalizations.of(context)!.translate('login_success');
      } else {
        _message = AppLocalizations.of(context)!.translate('invalid_credentials');
      }
    });

    if (response.error == ServiceErrors.ok) {
      Navigator.pushReplacementNamed(context, '/main-screen');
    } else {
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.withCredentials) {
      final qrCode = ModalRoute.of(context)?.settings.arguments as String?;
      if (qrCode != null && !_hasAttemptedLogin) {
        _hasAttemptedLogin = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _login(qrCode, context);
        });
      }
      return Scaffold(
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
                    color: _message == AppLocalizations.of(context)!.translate('login_success')
                        ? Colors.green
                        : Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],
              if (_message != null && _message!.contains('failed')) ...[
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
    } else {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.translate('username'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.translate('password'),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : FullWidthButton(
                    text: AppLocalizations.of(context)!.translate('login'),
                    onPressed: () {
                      _manualLogin(context);
                    },
                  ),
                  if (_message != null) ...[
                    const SizedBox(height: 20),
                    Text(
                      _message!,
                      style: TextStyle(
                        fontSize: 16,
                        color: _message == AppLocalizations.of(context)!.translate('login_success')
                            ? Colors.green
                            : Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: GoBackNavigator(
          onTabSelected: (tab) {
            switch (tab) {
              case 'back':
                if (mounted) {
                  Navigator.pop(context);
                }
                break;
              case 'exit':
                SystemNavigator.pop();
                break;
            }
          },
        ),
      );

    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
