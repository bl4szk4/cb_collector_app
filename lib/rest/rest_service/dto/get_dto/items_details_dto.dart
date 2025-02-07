import 'package:pbl_collector/rest/rest_service/dto/get_dto/department_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/faculty_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/item_type_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/location_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/room_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/user_details_dto.dart';
import 'package:logger/logger.dart';

import '../../../../models/sub_models/item_status.dart';

class ItemDetailsDTO {
  static final Logger logger = Logger(); // 🔹 Użyjemy statycznego loggera, żeby nie tworzyć nowego dla każdej instancji

  int id;
  String name;
  int userId;
  UserDetailsDTO user;
  int locationId;
  LocationDTO location;
  ItemStatus status;
  int currentUserId;
  UserDetailsDTO currentUser;
  int itemTypeId;
  ItemTypeDTO itemType;
  List<String>? pCodes = [];
  List<String>? hCodes = [];
  DateTime? expirationDay;

  ItemDetailsDTO({
    required this.id,
    required this.name,
    required this.userId,
    required this.user,
    required this.locationId,
    required this.location,
    required this.status,
    required this.currentUserId,
    required this.currentUser,
    required this.itemTypeId,
    required this.itemType,
    required this.hCodes,
    required this.pCodes,
    this.expirationDay,
  });

  @override
  factory ItemDetailsDTO.fromJson(dynamic json) {
   final id = json["id"] as int;
    final name = json["name"] as String;
    final userId = json["user_id"] as int;
    final user = UserDetailsDTO.fromJson(json["user"]);
    final currentUserId = json["current_user_id"] as int;
    final currentUser = UserDetailsDTO.fromJson(json["current_user"]);
    final locationId = json["location_id"] as int;

    final location = LocationDTO.fromJson(json["location"]);

    final itemTypeId = json["item_type_id"] as int;
    final itemType = ItemTypeDTO.fromJson(json["item_type"]);

    final pCodes = (json["p_codes"] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    final hCodes = (json["h_codes"] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

    final status = ItemStatus.values.firstWhere(
          (e) => e.toString().split('.').last == json['status'],
      orElse: () => ItemStatus.unknown,
    );

    final expirationDay = json["termin_waz"] != null
        ? DateTime.tryParse(json["termin_waz"])
        : null;

    return ItemDetailsDTO(
      id: id,
      name: name,
      userId: userId,
      user: user,
      currentUserId: currentUserId,
      currentUser: currentUser,
      pCodes: pCodes,
      hCodes: hCodes,
      status: status,
      expirationDay: expirationDay,
      locationId: locationId,
      location: location,
      itemTypeId: itemTypeId,
      itemType: itemType,
    );

  }
}
