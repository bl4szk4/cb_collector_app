import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pbl_collector/controllers/main_controller.dart';
import 'package:pbl_collector/models/user.dart';
import 'package:pbl_collector/widgets/buttons/small_button.dart';
import '../models/sub_models/item_details_route_arguments.dart';
import '../services/app_localizations.dart';
import '../models/service_response.dart';
import '../models/users_list.dart';
import '../enums/service_errors.dart';
import '../widgets/navigators/go_back_navigator.dart';

class UserSelectionScreen extends StatefulWidget {
  final MainController mainController;
  final int itemId;

  const UserSelectionScreen({super.key, required this.mainController, required this.itemId});

  @override
  _UserSelectionScreenState createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  List<User> _users = [];
  List<User> _filteredUsers = [];
  final TextEditingController _searchController = TextEditingController();
  User? _selectedUser;

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _searchController.addListener(_filterUsers);
  }

  Future<void> _loadUsers() async {
    final response = await widget.mainController.service.getUsersList(null, null);
    if (response.error == ServiceErrors.ok && response.data != null) {
      setState(() {
        _users = response.data!.usersList;
        _filteredUsers = _users;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.translate('error_loading_users')),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _filterUsers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _users.where((user) {
        final fullName = '${user.name} ${user.surname}'.toLowerCase();
        return fullName.contains(query);
      }).toList();
    });
  }

  Future<void> _assignUser() async {
    if (_selectedUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.translate('select_user_first')),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final response = await widget.mainController.service.assignItem(widget.itemId, _selectedUser!.id);

    if (response.error == ServiceErrors.ok && response.data != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.translate('user_assigned_successfully')),
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.pushNamed(
        context,
        '/items/details',
        arguments: ItemDetailsRouteArguments(itemId: widget.itemId, routeOrigin: 'action'),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.translate('error_assigning_user')),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.translate('search_user'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _filteredUsers.isEmpty
                ? Center(child: Text(AppLocalizations.of(context)!.translate('no_users_found')))
                : ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return _buildUserTile(user);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: HalfWidthButton(
              onPressed: _assignUser,
              text: AppLocalizations.of(context)!.translate('assign'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: GoBackNavigator(
        onTabSelected: (tab) {
          switch (tab) {
            case 'back':
              Navigator.pop(context);
              break;
            case 'exit':
              SystemNavigator.pop();
              break;
          }
        },
      ),
    );
  }

  Widget _buildUserTile(User user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: _selectedUser == user
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.person, color: Colors.blue),
        title: Text('${user.title} ${user.name} ${user.surname}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(user.department?.name ?? 'N/A', style: const TextStyle(color: Colors.grey)),
        onTap: () {
          setState(() {
            _selectedUser = user;
          });
        },
      ),
    );
  }
}
