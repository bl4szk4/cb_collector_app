import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imin_printer/imin_printer.dart';

class PrintScreen extends StatefulWidget {
  @override
  _PrintScreenState createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  String _printerStatus = 'Status drukarki nieznany';
  final iminPrinter = IminPrinter();

  // Pobieranie statusu drukarki
  Future<void> _getPrinterStatus() async {
    try {
      await iminPrinter.initPrinter(); // Inicjalizacja drukarki
      final state = await iminPrinter.getPrinterStatus();
      setState(() {
        _printerStatus = state['msg'] ?? 'Nieznany status';
      });
    } catch (e) {
      setState(() {
        _printerStatus = 'Błąd: $e';
      });
    }
  }

  // Wydruk tekstu "Hello World"
  Future<void> _printHelloWorld() async {
    try {
      await iminPrinter.initPrinter(); // Inicjalizacja drukarki
      await iminPrinter.printText(
        "Hello World",
      );
      setState(() {
        _printerStatus = 'Wysłano "Hello World" do drukarki';
      });
    } catch (e) {
      setState(() {
        _printerStatus = 'Błąd druku: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drukowanie'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _printerStatus,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getPrinterStatus,
              child: Text('Sprawdź status drukarki'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _printHelloWorld,
              child: Text('Drukuj "Hello World"'),
            ),
          ],
        ),
      ),
    );
  }
}
