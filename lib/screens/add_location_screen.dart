import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pbl_collector/controllers/main_controller.dart';
import 'package:pbl_collector/models/faculty.dart';
import 'package:pbl_collector/models/department.dart';
import 'package:pbl_collector/models/room.dart';
import '../services/app_localizations.dart';
import '../models/service_response.dart';
import '../enums/service_errors.dart';
import '../widgets/navigators/go_back_navigator.dart';

class AddLocationScreen extends StatefulWidget {
  final MainController mainController;

  const AddLocationScreen({super.key, required this.mainController});

  @override
  _AddLocationScreenState createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  List<Faculty> _faculties = [];
  List<Department> _departments = [];
  List<Room> _rooms = [];

  Faculty? _selectedFaculty;
  Department? _selectedDepartment;
  Room? _selectedRoom;

  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFaculties();
  }

  Future<void> _loadFaculties() async {
    final response = await widget.mainController.service.getFaculties();
    if (response.error == ServiceErrors.ok && response.data != null) {
      setState(() {
        _faculties = response.data!.facultiesList;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.translate('error_loading_faculties')),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _loadDepartments(int facultyId) async {
    final response = await widget.mainController.service.getDepartments(facultyId);
    if (response.error == ServiceErrors.ok && response.data != null) {
      setState(() {
        _departments = response.data!.departmentsList;
        _selectedDepartment = null;
        _rooms = [];
        _selectedRoom = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.translate('error_loading_departments')),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _loadRooms(int departmentId) async {
    final response = await widget.mainController.service.getRooms(departmentId);
    if (response.error == ServiceErrors.ok && response.data != null) {
      setState(() {
        _rooms = response.data!.roomsList;
        _selectedRoom = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.translate('error_loading_rooms')),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _submitLocation() async {
    if (_selectedRoom == null || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.translate('please_fill_all_fields')),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final response = await widget.mainController.service.addLocation(
      _selectedRoom!.id,
      _descriptionController.text,
    );

    if (response.error == ServiceErrors.ok && response.data != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.translate('location_added_successfully')),
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.pop(context); // Return to the previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.translate('error_adding_location')),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<Faculty>(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.translate('select_faculty'),
                border: OutlineInputBorder(),
              ),
              items: _faculties.map((faculty) {
                return DropdownMenuItem(
                  value: faculty,
                  child: Text(faculty.name),
                );
              }).toList(),
              value: _selectedFaculty,
              onChanged: (faculty) {
                setState(() {
                  _selectedFaculty = faculty;
                });
                if (faculty != null) {
                  _loadDepartments(faculty.id);
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Department>(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.translate('select_department'),
                border: OutlineInputBorder(),
              ),
              items: _departments.map((department) {
                return DropdownMenuItem(
                  value: department,
                  child: Text(department.name),
                );
              }).toList(),
              value: _selectedDepartment,
              onChanged: (department) {
                setState(() {
                  _selectedDepartment = department;
                });
                if (department != null) {
                  _loadRooms(department.id);
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Room>(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.translate('select_room'),
                border: OutlineInputBorder(),
              ),
              items: _rooms.map((room) {
                return DropdownMenuItem(
                  value: room,
                  child: Text('Room ${room.number}'),
                );
              }).toList(),
              value: _selectedRoom,
              onChanged: (room) {
                setState(() {
                  _selectedRoom = room;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.translate('description'),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitLocation,
              child: Text(AppLocalizations.of(context)!.translate('confirm')),
            ),
          ],
        ),
      ),
      bottomNavigationBar: GoBackNavigator(
        onTabSelected: (tab) {
          switch (tab) {
            case 'back':
              Navigator.pushNamed(context, '/main-menu');
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
