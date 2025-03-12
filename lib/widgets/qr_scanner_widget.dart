import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'navigators/go_back_navigator.dart';
import 'package:logger/logger.dart';

class QRScannerWidget extends StatefulWidget {
  final Function(String) onQRCodeScanned;
  final String instruction;
  final bool scanOnce;
  final bool autoTorch;

  const QRScannerWidget({
    Key? key,
    required this.onQRCodeScanned,
    this.instruction = '',
    this.scanOnce = true,
    this.autoTorch = true,
  }) : super(key: key);

  @override
  State<QRScannerWidget> createState() => _QRScannerWidgetState();
}

class _QRScannerWidgetState extends State<QRScannerWidget> {
  late final MobileScannerController _localScannerController;
  bool _hasScanned = false;
  bool _torchOn = false;
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _localScannerController = MobileScannerController(autoStart: false);

    _initializeScanner();
  }

  Future<void> _initializeScanner() async {
    await _localScannerController.start();
    await Future.delayed(Duration(milliseconds: 300));

    if (widget.autoTorch) {
      try {
        await _localScannerController.toggleTorch();
        setState(() {
          _torchOn = true;
        });
        logger.i("Torch turned on at start");
      } catch (e) {
        logger.e("Error toggling torch: $e");
      }
    }
  }

  void _toggleTorch() async {
    try {
      await _localScannerController.toggleTorch();
      setState(() {
        _torchOn = !_torchOn;
      });
      logger.i(_torchOn ? "Torch turned on" : "Torch turned off");
    } catch (e) {
      logger.e("Error toggling torch: $e");
    }
  }

  @override
  void dispose() {
    if (_torchOn) {
      _localScannerController.toggleTorch();
    }
    _localScannerController.stop();
    _localScannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: _localScannerController,
            onDetect: (barcodeCapture) {
              if (!_hasScanned || !widget.scanOnce) {
                for (final barcode in barcodeCapture.barcodes) {
                  if (barcode.rawValue != null) {
                    _handleScannedCode(barcode.rawValue!);
                    break;
                  }
                }
              }
            },
          ),
          if (widget.instruction.isNotEmpty)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black.withOpacity(0.7),
                child: Text(
                  widget.instruction,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          Positioned(
            top: 50,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: _torchOn ? Colors.yellow : Colors.grey,
              onPressed: _toggleTorch,
              child: Icon(_torchOn ? Icons.flash_on : Icons.flash_off),
            ),
          ),
        ],
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

  void _handleScannedCode(String code) {
    logger.i(code);
    if (widget.scanOnce) {
      setState(() {
        _hasScanned = true;
      });
    }
    Navigator.pop(context);
    logger.i("Handling code");
    widget.onQRCodeScanned(code);
  }
}
