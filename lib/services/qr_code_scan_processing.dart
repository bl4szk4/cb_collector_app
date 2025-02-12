import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:pbl_collector/enums/service_errors.dart';
import 'package:pbl_collector/models/item_details.dart';
import 'package:pbl_collector/models/sub_models/my_items_route_arguments.dart';
import 'package:pbl_collector/services/main_service.dart';
import 'package:logger/logger.dart';

import '../models/sub_models/item_details_route_arguments.dart';

class QRCodeProcessingService {
  final Service service;
  final BuildContext context;
  QRCodeProcessingService({required this.service, required this.context});
  final Logger logger = Logger();


  Future<dynamic> processQRCode(String scannedCode) async {
    try {
      final Map<String, dynamic> data = json.decode(scannedCode);
      logger.i(data);

      if (!data.containsKey('id') || !data.containsKey('type')) {
        throw FormatException('Invalid code');
      }

      final int id = data['id'] is int ? data['id'] : int.parse(data['id'].toString());
      final String type = data['type'].toString().toLowerCase();
      logger.i(type);
      switch (type) {
        case 'room':
          return Navigator.pushNamed(
            context,
            '/my-items',
            arguments: MyItemsRouteArguments(
              locationId: id,
              routeOrigin: 'room',
            ),
          );
        case 'location':
          return Navigator.pushNamed(
            context,
            '/my-items',
            arguments: MyItemsRouteArguments(
              locationId: id,
              routeOrigin: 'location',
            ),
          );

        case 'item':
          return Navigator.pushNamed(
            context,
            '/items/details',
            arguments: ItemDetailsRouteArguments(
              itemId: id,
              routeOrigin: 'itemsList',
            ),
          );
        default:
          throw Exception('Unknown type: $type');
      }
    } catch (e) {
      throw e;
    }
  }
}
