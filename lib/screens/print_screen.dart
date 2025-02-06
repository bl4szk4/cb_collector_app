import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/printers/printer_service.dart';

class PrinterScreen extends StatefulWidget {
  final PrintingService printingService;

  const PrinterScreen({Key? key, required this.printingService})
      : super(key: key);

  @override
  _PrinterScreenState createState() => _PrinterScreenState();
}

class _PrinterScreenState extends State<PrinterScreen> {
  String _printerStatus = 'Status drukarki nieznany';
  final TextEditingController _qrController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _initializePrinterStatus();
  }

  /// Inicjalizuje status drukarki
  Future<void> _initializePrinterStatus() async {
    setState(() {
      _printerStatus = 'Serwis drukowania został zainicjalizowany.';
    });
  }

  /// Drukuje kod QR
  Future<void> _printQRCode() async {
    final data = _qrController.text.trim();
    if (data.isEmpty) {
      setState(() {
        _printerStatus = 'Pole kodu QR nie może być puste.';
      });
      return;
    }

    try {
      final result = await widget.printingService.printCode(data);
      setState(() {
        _printerStatus = result;
      });
    } catch (e) {
      setState(() {
        _printerStatus = 'Błąd drukowania kodu QR: $e';
      });
    }
  }

  /// Wybiera obraz z galerii
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _printerStatus = 'Obraz wybrany: ${pickedFile.path}';
        });
      }
    } catch (e) {
      setState(() {
        _printerStatus = 'Błąd podczas wybierania obrazu: $e';
      });
    }
  }

  /// Drukuje wybrany obraz
  Future<void> _printImage() async {
    if (_selectedImage == null) {
      setState(() {
        _printerStatus = 'Najpierw wybierz obraz.';
      });
      return;
    }

    try {
      final result = await widget.printingService.printLabel(_selectedImage!);
      setState(() {
        _printerStatus = result;
      });
    } catch (e) {
      setState(() {
        _printerStatus = 'Błąd drukowania obrazu: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drukowanie'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Wyświetlanie statusu drukarki
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

            // Pole tekstowe do wpisania treści kodu QR
            TextField(
              controller: _qrController,
              decoration: InputDecoration(
                labelText: 'Treść kodu QR',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.qr_code),
              ),
            ),
            const SizedBox(height: 20),

            // Przycisk "Drukuj QR"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _printQRCode,
                icon: const Icon(Icons.qr_code),
                label: const Text('Drukuj kod QR'),
              ),
            ),
            const SizedBox(height: 20),

            // Przycisk "Wybierz obraz"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Wybierz obraz'),
              ),
            ),
            const SizedBox(height: 20),

            // Przycisk "Drukuj obraz"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _printImage,
                icon: const Icon(Icons.print),
                label: const Text('Drukuj obraz'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
