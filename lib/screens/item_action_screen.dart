import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pbl_collector/controllers/main_controller.dart';
import 'package:pbl_collector/models/item_details_action.dart';
import 'package:pbl_collector/widgets/navigators/go_back_navigator.dart';
import '../models/sub_models/item_details_route_arguments.dart';
import '../models/sub_models/qr_scanner_route_arguments.dart';
import '../services/app_localizations.dart';
import '../models/service_response.dart';
import '../enums/service_errors.dart';
import '../widgets/buttons/small_button.dart';

class ItemActionScreen extends StatelessWidget {
  final MainController mainController;
  final int itemId;

  const ItemActionScreen({
    super.key,
    required this.mainController,
    required this.itemId,
  });

  Future<void> _performAction(
      BuildContext context,
      Future<ServiceResponse<ItemDetailsAction>> Function(int) action,
      ) async {
    final response = await action(itemId);

    if (response.error == ServiceErrors.ok && response.data != null) {
      Navigator.pushReplacementNamed(
        context,
        '/items/details',
        arguments: ItemDetailsRouteArguments(
          itemId: itemId,
          routeOrigin: 'action',
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.translate('error_performing_action')),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HalfWidthButton(
              text: AppLocalizations.of(context)!.translate('dispose'),
              onPressed: () => _performAction(context, mainController.service.disposeItem),
            ),
            const SizedBox(height: 16),
            HalfWidthButton(
              text: AppLocalizations.of(context)!.translate('mark_empty'),
              onPressed: () => _performAction(context, mainController.service.markEmpty),
            ),
            const SizedBox(height: 16),
            HalfWidthButton(
              text: AppLocalizations.of(context)!.translate('mark_missing'),
              onPressed: () => _performAction(context, mainController.service.markMissing),
            ),
            const SizedBox(height: 16),
            HalfWidthButton(
              text: AppLocalizations.of(context)!.translate('mark_low'),
              onPressed: () => _performAction(context, mainController.service.markLow),
            ),
            const SizedBox(height: 16),
            HalfWidthButton(
              text: AppLocalizations.of(context)!.translate('borrow'),
              onPressed: () => {
                Navigator.pushNamed(
                  context,
                  '/item/details/edit/assign',
                  arguments: itemId,
                )
              },
            ),
            const SizedBox(height: 16),
            HalfWidthButton(
              text: AppLocalizations.of(context)!.translate('return'),
              onPressed: () => _performAction(context, mainController.service.returnItem),
            ),
            const SizedBox(height: 16),
            HalfWidthButton(
              text: AppLocalizations.of(context)!.translate('change_location'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/qr-scanner',
                  arguments: QRScannerRouteArguments(
                    onQRCodeScanned: (String code) {
                      Navigator.pushNamed(
                        context,
                        '/change-location',
                        arguments: {
                          'itemId': itemId,
                          'qrCode': code,
                        },
                      );
                    },
                    instruction: AppLocalizations.of(context)!.translate('scan_location'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: GoBackNavigator(
        onTabSelected: (tab) {
          switch (tab) {
            case 'back':
              Navigator.pushNamed(
                context,
                '/items/details',
                arguments: ItemDetailsRouteArguments(
                  itemId: itemId,
                  routeOrigin: 'itemsList',
                ),
              );
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
