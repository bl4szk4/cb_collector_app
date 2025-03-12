import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pbl_collector/controllers/main_controller.dart';
import 'package:pbl_collector/enums/qr_code_type.dart';
import 'package:pbl_collector/enums/service_errors.dart';
import 'package:pbl_collector/services/printers/printer_service.dart';

import '../models/item_label_blob.dart';
import '../models/item_label_blob_list.dart';
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
  bool _loading = true;
  bool _printing = false;
  String? _error;
  List<ItemLabelBlob> _labels = [];
  ItemLabelBlob? _selectedLabel;
  Uint8List? _qrCode;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final qrResponse = await widget.mainController.service.getItemQrCode(
      widget.itemId,
      widget.type,
    );

    final labelResponse = await widget.mainController.service.getLabel(widget.itemId);

    if (qrResponse.error == ServiceErrors.ok && qrResponse.data != null) {
      _qrCode = qrResponse.data!.qrImage;
    } else {
      _error = 'Error loading QR code.';
    }

    if (labelResponse.error == ServiceErrors.ok && labelResponse.data != null) {
      _labels = labelResponse.data!.blobList;
    } else {
      _error = _error ?? 'Error loading labels.';
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _handlePrint(Function printFunction) async {
    setState(() {
      _printing = true;
    });

    await printFunction();

    setState(() {
      _printing = false;
    });
  }

  Future<void> _printQRCode() async {
    if (_qrCode == null) return;
    await widget.printingService.printQRCodeImage(_qrCode!);
  }

  Future<void> _printLabel() async {
    if (_selectedLabel == null) return;
    await widget.printingService.printLabelImage(_selectedLabel!.labelImage);
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
            if (_qrCode != null) ...[
              Image.memory(
                _qrCode!,
                fit: BoxFit.contain,
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 10),
              HalfWidthButton(
                onPressed: () => _handlePrint(_printQRCode),
                text: AppLocalizations.of(context)!.translate('print_qr_code'),
              ),
              const SizedBox(height: 20),
            ],
            const Text(
              "Select a Label to Print:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _labels.isEmpty
                ? Text(AppLocalizations.of(context)!.translate('no_qr_codes'))
                : Column(
              children: _labels.map((label) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedLabel = label;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedLabel == label ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Image.memory(
                          label.labelImage,
                          fit: BoxFit.contain,
                          width: 150,
                          height: 150,
                        ),
                        const SizedBox(height: 5),
                        Text("Label ID: ${label.id}"),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            HalfWidthButton(
              onPressed: () => _handlePrint(_printLabel),
              text: AppLocalizations.of(context)!.translate('print_label'),
            ),
            const SizedBox(height: 20),
            if (_printing) const Center(child: CircularProgressIndicator()),
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
