import 'package:flutter/material.dart';
import 'package:pbl_collector/controllers/main_controller.dart';
import 'package:pbl_collector/models/item_details.dart';
import '../enums/label_type.dart';
import '../models/blobs_list.dart';
import '../models/service_response.dart';
import '../services/app_localizations.dart';
import '../enums/service_errors.dart';
import '../models/sub_models/blob_file.dart';
import '../widgets/buttons/small_button.dart';

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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('item_details')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }

  Widget _buildItemDetails(ItemDetails item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Name: ${item.name}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text('CAS Number: ${item.casNumber}', style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text('P-Code: ${item.pCode}', style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text('Status: ${item.status.name}', style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            if (item.expirationDay != null)
              Text('Expiration Date: ${item.expirationDay!.toLocal()}'.split(' ')[0], style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
          ],
        ),
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
