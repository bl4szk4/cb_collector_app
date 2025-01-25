import './sub_models/item_status.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/items_details_dto.dart';

class ItemDetails{
  int id;
  int userId;
  int? locationId;
  DateTime? expirationDay;
  int currentUser;
  ItemStatus status;
  String name;
  String casNumber;
  String pCode;

  ItemDetails({
    required this.id,
    required this.name,
    required this.casNumber,
    required this.pCode,
    required this.userId,
    required this.currentUser,
    required this.status,
    this.expirationDay,
    this.locationId
  });

  @override
  factory ItemDetails.fromDTO(ItemDetailsDTO dto){
    return ItemDetails(
      id: dto.id,
      name: dto.name,
      casNumber: dto.casNumber,
      pCode: dto.pCode,
      userId: dto.userId,
      locationId: dto.locationId,
      expirationDay: dto.expirationDay,
      currentUser: dto.currentUser,
      status: dto.status
    );
  }

}
