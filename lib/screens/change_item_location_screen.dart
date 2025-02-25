import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pbl_collector/controllers/main_controller.dart';
import 'package:pbl_collector/widgets/navigators/go_back_navigator.dart';
import '../models/sub_models/item_details_route_arguments.dart';
import '../models/sub_models/my_items_route_arguments.dart';
import '../services/app_localizations.dart';
import '../enums/service_errors.dart';
import '../widgets/buttons/full_width_button.dart';
import 'package:logger/logger.dart';

class ChangeLocationScreen extends StatefulWidget {
  final MainController mainController;
  final int itemId;
  final String qrCode;

  const ChangeLocationScreen({
    Key? key,
    required this.mainController,
    required this.itemId,
    required this.qrCode
  }) : super(key: key);

  @override
  _ChangeLocationScreenState createState() => _ChangeLocationScreenState();
}

class _ChangeLocationScreenState extends State<ChangeLocationScreen> {
  String? _errorMessage;
  bool _isLoading = false;
  final Logger logger = Logger();


  Future<void> _changeLocation(String qrCode) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      logger.i(qrCode);
      final Map<String, dynamic> data = jsonDecode(qrCode);
      final int id = data['id'] is int ? data['id'] : int.tryParse(data['id'].toString()) ?? -1;
      final String type = data['type'].toString().toLowerCase();
      logger.i(data);
      if (type != 'location') {
        setState(() {
          _errorMessage = AppLocalizations.of(context)!.translate('error_invalid_qr_type');
          _isLoading = false;
        });
        return;
      }

      final response = await widget.mainController.service.changeLocation(widget.itemId, id);

      if (response.error == ServiceErrors.ok && response.data != null) {
        if (!mounted) return;
        Navigator.pushNamed(
          context,
          '/items/details',
          arguments: ItemDetailsRouteArguments(
            itemId: response.data!.id,
            routeOrigin: 'itemsList',
          ),
        );
      } else {
        setState(() {
          _errorMessage = AppLocalizations.of(context)!.translate('error_changing_location');
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.translate('error_invalid_qr_code');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading && _errorMessage == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _changeLocation(widget.qrCode);
      });
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isLoading) ...[
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 16),
            ],
            if (_errorMessage != null) ...[
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FullWidthButton(
                text: AppLocalizations.of(context)!.translate('go_back'),
                onPressed: () {
                  setState(() {
                    _errorMessage = null;
                  });
                  Navigator.pushNamed(
                    context,
                    '/my-items',
                    arguments: MyItemsRouteArguments(
                      routeOrigin: 'home',
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: GoBackNavigator(
        onTabSelected: (tab) {
          switch (tab) {
            case 'back':
              Navigator.pushNamed(context, '/item/details/edit', arguments: widget.itemId);
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
