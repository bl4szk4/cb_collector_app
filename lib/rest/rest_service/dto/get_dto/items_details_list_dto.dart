import '../../../../models/sub_models/item_status.dart';
import '../../../../models/sub_models/blob_file.dart';

class ItemDetailsListDTO{
  int id;
  String name;
  int userId;
  ItemStatus status;
  int currentUser;
  int itemTypeId;
  List<String>? pCodes = [];
  List<String>? hCodes = [];
  int? locationId;
  DateTime? expirationDay;

  ItemDetailsListDTO({
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
  factory ItemDetailsListDTO.fromJson(dynamic json){
    return ItemDetailsListDTO(
        id: json["id"] as int,
        name: json["name"] as String,
        userId: json["user_id"] as int,
        currentUser: json["current_user"] as int,
        itemTypeId: json["item_type_id"],
        pCodes: (json["p_codes"] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        hCodes: (json["h_codes"] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        status: ItemStatus.values.firstWhere(
              (e) => e.toString().split('.').last == json['status'],
          orElse: () => ItemStatus.unknown,
        ),
        expirationDay: json["termin_waz"] != null
            ? DateTime.parse(json["termin_waz"])
            : null,
        locationId: json["location_id"] as int,
    );
  }

}
