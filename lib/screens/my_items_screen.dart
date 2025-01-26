import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pbl_collector/controllers/main_controller.dart';
import 'package:pbl_collector/models/items_list.dart';
import 'package:pbl_collector/models/item_details.dart';
import '../models/service_response.dart';
import '../services/app_localizations.dart';
import '../enums/service_errors.dart';
import '../widgets/navigators/bottom_navigator.dart';

class MyItemsScreen extends StatefulWidget {
  final MainController mainController;

  const MyItemsScreen({super.key, required this.mainController});

  @override
  _ChemicalsListScreenState createState() => _ChemicalsListScreenState();
}

class _ChemicalsListScreenState extends State<MyItemsScreen> {
  late Future<ServiceResponse<ItemsList>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = widget.mainController.service.getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('chemical_items_list')),
      ),
      body: FutureBuilder<ServiceResponse<ItemsList>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.error != ServiceErrors.ok) {
            return Center(
              child: Text(AppLocalizations.of(context)!.translate('error_loading_items')),
            );
          }

          final itemsList = snapshot.data!.data!.itemsList;

          return ListView.builder(
            itemCount: itemsList.length,
            itemBuilder: (context, index) {
              final item = itemsList[index];
              return _buildItemTile(item);
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigation(
        onTabSelected: (tab) {
          switch (tab) {
            case 'settings':
              Navigator.pushNamed(context, '/settings');
              break;
            case 'main':
              Navigator.pushNamed(context, '/main-screen');
            case 'exit':
              SystemNavigator.pop();
              break;
          }
        },
      ),
    );
  }

  Widget _buildItemTile(ItemDetails item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(
          item.userId == item.currentUser ? Icons.check_circle : Icons.cancel,
          color: item.userId == item.currentUser ? Colors.green : Colors.red,
        ),
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Status: ${item.status.name}'),
        trailing: Text('ID: ${item.id}'),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/items/details',
            arguments: item,
          );
        },
      ),
    );
  }
}