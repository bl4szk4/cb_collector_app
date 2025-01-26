import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/buttons/full_width_button.dart';
import '../services/app_localizations.dart';
import '../widgets/navigators/bottom_navigator.dart';
import '../controllers/main_controller.dart';

class HomeScreen extends StatelessWidget {
  final MainController mainController;

  const HomeScreen({Key? key, required this.mainController}) : super(key: key);

  void _checkLogin(BuildContext context) {
    if (!mainController.user.isLogged) {
      Navigator.pushNamed(context, '/qr-scanner');
    } else {
      Navigator.pushNamed(context, '/main-screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FullWidthButton(
              text: AppLocalizations.of(context)!.translate('login_screen_title'),
              onPressed: () {
                Navigator.pushNamed(context, '/qr-scanner');
              },
            ),
            FullWidthButton(
              text: AppLocalizations.of(context)!.translate('settings'),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        onTabSelected: (tab) {
          switch (tab) {
            case 'settings':
              Navigator.pushNamed(context, '/settings');
              break;
            case 'main':
              _checkLogin(context);
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
