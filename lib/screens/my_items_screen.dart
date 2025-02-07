import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pbl_collector/controllers/main_controller.dart';
import 'package:pbl_collector/models/item_details_list.dart';
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

  Widget _buildItemTile(ItemDetailsList item) {
    return GestureDetector(
      onTap: () async {
        final response = await widget.mainController.service.getItemDetailsById(item.id);

        if (response.error == ServiceErrors.ok && response.data != null) {
          Navigator.pushNamed(
            context,
            '/items/details',
            arguments: response.data,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load item details')),
          );
        }
      },
    child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              item.userId == item.currentUser ? Icons.check_circle : Icons.cancel,
              color: item.userId == item.currentUser ? Colors.green : Colors.red,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Status: ${item.status.name}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'ID: ${item.id}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Exp: ${item.expirationDay?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),

              ],
            ),
          ],
        ),

      ),
    )
    );
  }

}