import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pbl_collector/controllers/main_controller.dart';
import 'package:pbl_collector/models/location.dart';
import 'package:pbl_collector/models/room.dart';
import '../enums/qr_code_type.dart';
import '../services/app_localizations.dart';
import '../enums/service_errors.dart';
import '../widgets/buttons/small_button.dart';
import '../widgets/navigators/go_back_navigator.dart';

class PrintLocationCodeScreen extends StatefulWidget {
  final MainController mainController;

  const PrintLocationCodeScreen({super.key, required this.mainController});

  @override
  _PrintLocationCodeScreenState createState() => _PrintLocationCodeScreenState();
}

class _PrintLocationCodeScreenState extends State<PrintLocationCodeScreen> {
  List<Room> _rooms = [];
  List<Location> _locations = [];

  Room? _selectedRoom;
  Location? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    final response = await widget.mainController.service.getRooms(null);
    if (response.error == ServiceErrors.ok && response.data != null) {
      setState(() {
        _rooms = response.data!.roomsList;
        _selectedRoom = null;
      });
    } else {
      _showError('error_loading_rooms');
    }
  }

  Future<void> _loadLocations(int roomId) async {
    final response = await widget.mainController.service.getLocations(roomId);
    if (response.error == ServiceErrors.ok && response.data != null) {
      setState(() {
        _locations = response.data!.locationsList;
        _selectedLocation = null;
      });
    } else {
      _showError('error_loading_locations');
    }
  }

  void _showError(String messageKey) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.translate(messageKey)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _submitLocation(QrCodeType type) async {
    if (type == QrCodeType.room && _selectedRoom == null) {
      _showError('no_room_selected');
      return;
    } else if (type == QrCodeType.location && _selectedLocation == null) {
      _showError('no_location_selected');
      return;
    }

    Navigator.pushNamed(
      context,
      '/print-screen',
      arguments: {
        'itemId': type == QrCodeType.room ? _selectedRoom!.id : _selectedLocation!.id,
        'type': type
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.translate('select_room'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Room>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                  filled: true,
                  fillColor: Colors.black,
                ),
                dropdownColor: Colors.black,
                style: TextStyle(color: Colors.white),
                items: _rooms.map((room) {
                  return DropdownMenuItem(
                    value: room,
                      child: Text(
                        room.number,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                  );
                }).toList(),
                value: _selectedRoom,
                onChanged: (room) {
                  setState(() {
                    _selectedRoom = room;
                    _selectedLocation = null;
                    if (room != null) _loadLocations(room.id);
                  });
                },
              ),
              const SizedBox(height: 24),

              Text(
                AppLocalizations.of(context)!.translate('select_location'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Location>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[600]!),
                  ),
                  filled: true,
                  fillColor: Colors.black,
                ),
                dropdownColor: Colors.black,
                style: TextStyle(color: Colors.white),
                items: _locations.map((location) {
                  return DropdownMenuItem(
                    value: location,
                      child: Text(
                        location.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                  );
                }).toList(),
                value: _selectedLocation,
                onChanged: (location) {
                  setState(() {
                    _selectedLocation = location;
                  });
                },
              ),
              const SizedBox(height: 32),

              HalfWidthButton(
                onPressed: () => _submitLocation(QrCodeType.room),
                text: AppLocalizations.of(context)!.translate('print_room_qr_code'),
              ),
              const SizedBox(height: 16),
              HalfWidthButton(
                onPressed: () => _submitLocation(QrCodeType.location),
                text: AppLocalizations.of(context)!.translate('print_location_qr_code'),
              ),
            ],
          ),
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
