import 'package:pbl_collector/models/sub_models/item_type.dart';
import 'package:pbl_collector/models/user.dart';

import './sub_models/item_status.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/items_details_dto.dart';

import 'location.dart';

class ItemDetails{
  int id;
  String name;
  int userId;
  User user;
  int locationId;
  Location location;
  ItemStatus status;
  int currentUserId;
  User currentUser;
  int itemTypeId;
  ItemType itemType;
  List<String>? pCodes = [];
  List<String>? hCodes = [];
  DateTime? expirationDay;

  ItemDetails({
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
  factory ItemDetails.fromDTO(ItemDetailsDTO dto){
    return ItemDetails(
      id: dto.id,
      name: dto.name,
      userId: dto.userId,
      user: User.fromDTO(dto.user),
      currentUserId: dto.currentUserId,
      currentUser: User.fromDTO(dto.currentUser),
      pCodes: dto.pCodes,
      hCodes: dto.hCodes,
      locationId: dto.locationId,
      location: Location.fromDTO(dto.location),
      expirationDay: dto.expirationDay,
      status: dto.status,
      itemTypeId: dto.itemTypeId,
      itemType: ItemType.fromDTO(dto.itemType)
    );
  }

}
