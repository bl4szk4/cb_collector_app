import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pbl_collector/controllers/main_controller.dart';
import 'package:pbl_collector/enums/qr_code_type.dart';
import 'package:pbl_collector/enums/service_errors.dart';
import 'package:pbl_collector/services/printers/printer_service.dart';

import '../models/qr_code.dart';
import '../models/sub_models/item_details_route_arguments.dart';
import '../services/app_localizations.dart';
import '../widgets/buttons/small_button.dart';
import '../widgets/navigators/go_back_navigator.dart';

class PrinterScreen extends StatefulWidget {
  final PrintingService printingService;
  final int itemId;
  final MainController mainController;
  final QrCodeType type;

  const PrinterScreen({
    Key? key,
    required this.printingService,
    required this.itemId,
    required this.type,
    required this.mainController,
  }) : super(key: key);

  @override
  _PrinterScreenState createState() => _PrinterScreenState();
}

class _PrinterScreenState extends State<PrinterScreen> {
  String _printerStatus = 'Loading QR code...';
  bool _loading = true;
  String? _error;
  ItemLabel? _itemLabel;

  @override
  void initState() {
    super.initState();
    _loadItemLabel();
  }

  Future<void> _loadItemLabel() async {
    final response = await widget.mainController
        .service.getItemQrCode(
        widget.itemId, widget.type
    );
    if (response.error == ServiceErrors.ok && response.data != null) {
      setState(() {
        _itemLabel = response.data;
        _loading = false;
        _printerStatus = AppLocalizations.of(context)!
            .translate('qr_code_loaded');
      });
    } else {
      setState(() {
        _error = 'Error loading QR code.';
        _loading = false;
        _printerStatus = AppLocalizations.of(context)!
            .translate('error_loading_qr_code');
      });
    }
  }

  Future<void> _printQRCode() async {
    if (_itemLabel == null) return;
    setState(() {
      _printerStatus = AppLocalizations.of(context)!.translate('printing');
    });
    try {
      final result = await widget.printingService.printQRCodeImage(_itemLabel!.qrImage);
      setState(() {
        _printerStatus = result;
      });
    } catch (e) {
      setState(() {
        _printerStatus = AppLocalizations.of(context)!
            .translate('error_printing_qr_code');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(child: Text(_error!))
            : Column(
          children: [
            if (_itemLabel != null)
              Image.memory(
                _itemLabel!.qrImage,
                fit: BoxFit.contain,
                width: 300,
                height: 300,
              ),
            const SizedBox(height: 20),
            Card(
              color: Colors.grey[50],
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _printerStatus,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            HalfWidthButton(
              onPressed: _printQRCode,
              text: AppLocalizations.of(context)!.translate('print'),
              ),
          ],
        ),
      ),
      bottomNavigationBar: GoBackNavigator(
        onTabSelected: (tab) {
          switch (tab) {
            case 'back':
              Navigator.pushNamed(context, '/main-screen');
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
