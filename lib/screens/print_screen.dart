import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/brother_printer/brother_connection_service.dart';

class PrintScreen extends StatefulWidget {
  @override
  _PrintScreenState createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  late LabelPrinter printer;
  String statusMessage = "Loading status...";
  File? selectedImage; // Przechowuje wybrane zdjęcie

  @override
  void initState() {
    super.initState();
    _fetchStatus('192.168.0.179');
  }

  Future<void> _fetchStatus(String ip) async {
    try {
      final connection = await Connection.connect(ip);
      final printer = LabelPrinter(connection);

      // Pobieranie konfiguracji i statusu
      final config = await printer.getConfiguration();
      final status = await printer.getStatus();

      // Obliczenie pozostałej taśmy
      String tapeRemain = '';
      if (config.tapeLengthInitial != null && status.tapeLengthRemaining != null) {
        final totalLengthMm = config.tapeLengthInitial! * 25.4; // Przekształcenie cali na mm
        final remainingLengthMm = status.tapeLengthRemaining! * 25.4; // Przekształcenie cali na mm
        final percentage = (remainingLengthMm / totalLengthMm * 100).toInt();

        tapeRemain =
        'Remaining tape: $percentage% (${remainingLengthMm.toInt()} mm out of ${totalLengthMm.toInt()} mm).';
      }

      setState(() {
        statusMessage = 'Model: ${config.model}\n'
            'Tape Width: ${config.tapeWidth ?? "Unknown"} inches\n'
            '$tapeRemain\n'
            'Status: ${status.printState}\n'
            'Job Stage: ${status.printJobStage}\n'
            'Error: ${status.printJobError}';
      });

      connection.close();
    } catch (e) {
      setState(() {
        statusMessage = 'Failed to get printer status: $e';
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedImage = File(pickedFile.path); // Przechowujemy plik, ale nie wyświetlamy
        print('Image selected: ${pickedFile.path}');
      }
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> _printImage() async {
    if (selectedImage == null) {
      print('No image selected.');
      return;
    }

    try {
      final connection = await Connection.connect('192.168.0.179');
      final printer = LabelPrinter(connection);
      await printer.printJpeg(selectedImage!, 'normal', 'full');
      print('Print job completed successfully.');
      connection.close();
    } catch (e) {
      print('Failed to print: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Printer Status'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            statusMessage,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Pick Image'),
          ),
          ElevatedButton(
            onPressed: _printImage,
            child: Text('Print Image'),
          ),
        ],
      ),
    );
  }
}
