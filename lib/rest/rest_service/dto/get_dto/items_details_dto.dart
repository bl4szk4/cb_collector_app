import '../../../../models/sub_models/item_status.dart';
import '../../../../models/sub_models/blob_file.dart';

class ItemDetailsDTO{
  int id;
  String name;
  int userId;
  ItemStatus status;
  int currentUser;
  String casNumber;
  String pCode;
  int? locationId;
  DateTime? expirationDay;

  ItemDetailsDTO({
    required this.id,
    required this.name,
    required this.userId,
    required this.currentUser,
    required this.status,
    required this.casNumber,
    required this.pCode,
    this.expirationDay,
    this.locationId,
  });

  @override
  factory ItemDetailsDTO.fromJson(dynamic json){
    return ItemDetailsDTO(
        id: json["id"] as int,
        name: json["name"] as String,
        userId: json["userId"] as int,
        currentUser: json["currentUser"] as int,
        casNumber: json["casNumber"] as String,
        pCode: json["pCode"] as String,
        status: ItemStatus.values.firstWhere(
              (e) => e.toString().split('.').last == json['status'],
        ),
        expirationDay: json["expirationDay"] != null
            ? DateTime.parse(json["expirationDay"])
            : null,
        locationId: json["locationI"] as int,
    );
  }

}