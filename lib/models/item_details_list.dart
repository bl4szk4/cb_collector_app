import 'package:pbl_collector/rest/rest_service/dto/get_dto/items_details_list_dto.dart';

class ItemDetailsList{
  int id;
  String name;
  int userId;
  String status;
  int currentUser;
  int itemTypeId;
  List<String>? pCodes = [];
  List<String>? hCodes = [];
  int? locationId;
  DateTime? expirationDay;

  ItemDetailsList({
    required this.id,
    required this.name,
    required this.userId,
    required this.currentUser,
    required this.status,
    required this.itemTypeId,
    this.expirationDay,
    this.locationId,
    this.pCodes,
    this.hCodes
  });

  @override
  factory ItemDetailsList.fromDTO(ItemDetailsListDTO dto){
    return ItemDetailsList(
      id: dto.id,
      name: dto.name,
      pCodes: dto.pCodes,
      userId: dto.userId,
      locationId: dto.locationId,
      expirationDay: dto.expirationDay,
      currentUser: dto.currentUser,
      status: dto.status,
      hCodes: dto.hCodes,
      itemTypeId: dto.itemTypeId
    );
  }

}
