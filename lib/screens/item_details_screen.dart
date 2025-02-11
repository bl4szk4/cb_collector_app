import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pbl_collector/controllers/main_controller.dart';
import 'package:pbl_collector/models/item_details.dart';
import '../services/app_localizations.dart';
import '../widgets/buttons/small_button.dart';
import '../widgets/navigators/go_back_navigator.dart';

class ItemDetailsScreen extends StatefulWidget {
  final MainController mainController;
  final ItemDetails itemDetails;

  const ItemDetailsScreen({super.key, required this.mainController, required this.itemDetails});

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildItemDetails(widget.itemDetails),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            HalfWidthButton(
              text: AppLocalizations.of(context)!.translate('print'),
              onPressed: () {
                Navigator.pushNamed(
                    context,
                    '/print-screen',
                  arguments: widget.itemDetails.id
                );
              },
            ),
            const SizedBox(height: 16),
            HalfWidthButton(
              text: AppLocalizations.of(context)!.translate('edit'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/item/details/edit',
                  arguments: widget.itemDetails.id,
                );
              },
            ),
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

  Widget _buildItemDetails(ItemDetails item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
                AppLocalizations.of(context)!.translate('item_name'),
                item.name, fontSize: 20, isBold: true
            ),
            const Divider(),
            _buildDetailRow(
                AppLocalizations.of(context)!.translate('item_status'),
                item.status.name
            ),
            if (item.expirationDay != null)
              _buildDetailRow(
                  AppLocalizations.of(context)!.translate('expiration_date'),
                  '${item.expirationDay!.toLocal()}'.split(' ')[0]
              ),
            _buildDetailRow(
                AppLocalizations.of(context)!.translate('item_type_id'),
                item.itemTypeId.toString()
            ),

            const SizedBox(height: 12),
            _buildSectionTitle(AppLocalizations.of(context)!.translate('owner'),
            ),
            _buildDetailRow(
                AppLocalizations.of(context)!.translate('user_name'),
                '${item.user.name} ${item.user.surname}'
            ),
            _buildDetailRow(
                AppLocalizations.of(context)!.translate('department'),
                item.user.department?.name ?? 'N/A'
            ),

            const SizedBox(height: 12),
            _buildSectionTitle(
              AppLocalizations.of(context)!.translate('current_user'),
            ),
            _buildDetailRow(
                AppLocalizations.of(context)!.translate('user_name'),
                '${item.currentUser.name} ${item.currentUser.surname}'
            ),
            _buildDetailRow(
                AppLocalizations.of(context)!.translate('department'),
                item.currentUser.department?.name ?? 'N/A'
            ),

            const SizedBox(height: 12),
            _buildSectionTitle(AppLocalizations.of(context)!.translate('location'),
            ),
            _buildDetailRow(
                AppLocalizations.of(context)!.translate('room'),
                item.location?.room.number ?? 'N/A'
            ),
            _buildDetailRow(
                AppLocalizations.of(context)!.translate('department'),
                item.location?.room.department?.name ?? 'N/A'
            ),
            _buildDetailRow(
                AppLocalizations.of(context)!.translate('qr_code'),
                item.location?.qrCode ?? 'N/A'
            ),

            const SizedBox(height: 12),
            _buildSectionTitle(AppLocalizations.of(context)!.translate('safety_codes'),
                ),
            _buildDetailRow('P-Codes', item.pCodes != null ? item.pCodes!.join(', ') : 'N/A'),
            _buildDetailRow('H-Codes', item.hCodes != null ? item.hCodes!.join(', ') : 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {double fontSize = 16, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

}
