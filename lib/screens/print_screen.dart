import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pbl_collector/controllers/main_controller.dart';
import 'package:pbl_collector/enums/service_errors.dart';
import 'package:pbl_collector/services/printers/printer_service.dart';

import '../models/qr_code.dart';
import '../models/sub_models/item_details_route_arguments.dart';
import '../widgets/navigators/go_back_navigator.dart';

class PrinterScreen extends StatefulWidget {
  final PrintingService printingService;
  final int itemId;
  final MainController mainController;

  const PrinterScreen({
    Key? key,
    required this.printingService,
    required this.itemId,
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
    final response = await widget.mainController.service.getItemQrCode(widget.itemId);
    if (response.error == ServiceErrors.ok && response.data != null) {
      setState(() {
        _itemLabel = response.data;
        _loading = false;
        _printerStatus = 'QR code loaded.';
      });
    } else {
      setState(() {
        _error = 'Error loading QR code.';
        _loading = false;
        _printerStatus = 'Error loading QR code.';
      });
    }
  }

  Future<void> _printQRCode() async {
    if (_itemLabel == null) return;
    setState(() {
      _printerStatus = 'Printing QR code...';
    });
    try {
      final result = await widget.printingService.printQRCodeImage(_itemLabel!.qrImage);
      setState(() {
        _printerStatus = result;
      });
    } catch (e) {
      setState(() {
        _printerStatus = 'Error printing QR code: $e';
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _printQRCode,
                icon: const Icon(Icons.print),
                label: const Text('Print QR Code'),
              ),
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
                  itemId: widget.itemId,
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
