import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pbl_collector/controllers/main_controller.dart';
import 'package:pbl_collector/models/item_details.dart';
import '../enums/label_type.dart';
import '../models/blobs_list.dart';
import '../models/service_response.dart';
import '../services/app_localizations.dart';
import '../enums/service_errors.dart';
import '../models/sub_models/blob_file.dart';
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
  late Future<ServiceResponse<BlobsList>> _labelFuture;

  @override
  void initState() {
    super.initState();
    _labelFuture = widget.mainController.service.getLabel(widget.itemDetails.id, LabelType.MULTIPLE_LABELS);
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
            FutureBuilder<ServiceResponse<BlobsList>>(
              future: _labelFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.error != ServiceErrors.ok) {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.translate('error_loading_label')),
                  );
                }

                final blobs = snapshot.data!.data!.blobsList;
                if (blobs.isEmpty) {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.translate('no_labels_available')),
                  );
                }

                return _buildLabelImage(blobs.first);
              },
            ),
            const SizedBox(height: 16),
            HalfWidthButton(
              text: AppLocalizations.of(context)!.translate('print'),
              onPressed: () {
                Navigator.pushNamed(context, '/print-screen');
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
            _buildDetailRow('Name', item.name, fontSize: 20, isBold: true),
            const Divider(),
            _buildDetailRow('Status', item.status.name),
            if (item.expirationDay != null)
              _buildDetailRow('Expiration Date', '${item.expirationDay!.toLocal()}'.split(' ')[0]),
            _buildDetailRow('Item Type ID', item.itemTypeId.toString()),

            const SizedBox(height: 12),
            _buildSectionTitle('Owner'),
            _buildDetailRow('Name', '${item.user.name} ${item.user.surname}'),
            _buildDetailRow('Department', item.user.department?.name ?? 'N/A'),

            const SizedBox(height: 12),
            _buildSectionTitle('Current User'),
            _buildDetailRow('Name', '${item.currentUser.name} ${item.currentUser.surname}'),
            _buildDetailRow('Department', item.currentUser.department?.name ?? 'N/A'),

            const SizedBox(height: 12),
            _buildSectionTitle('Location'),
            _buildDetailRow('Room', '${item.location.room.number}'),
            _buildDetailRow('Department', item.location.room.department?.name ?? 'N/A'),
            _buildDetailRow('QR Code', item.location.qrCode ?? 'N/A'),

            const SizedBox(height: 12),
            _buildSectionTitle('Safety Codes'),
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

  Widget _buildLabelImage(BlobFile blob) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        Text(AppLocalizations.of(context)!.translate('item_label'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        const SizedBox(height: 12),
        Center(
          child: Image.network(
            blob.fileUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return Text(AppLocalizations.of(context)!.translate('error_loading_image'));
            },
          ),
        ),
      ],
    );
  }
}
