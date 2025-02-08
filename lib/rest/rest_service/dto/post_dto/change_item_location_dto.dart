import '../../../interfaces/dto.dart';


class ChangeItemLocationDto implements DTO<ChangeItemLocationDto>{
  int itemId;
  String locationQrCode;

  ChangeItemLocationDto({
    required this.locationQrCode,
    required this.itemId
  });

  @override
  Map<String, dynamic> toJson(){
    return {
      'id_item': itemId,
      'location_qr_code': locationQrCode
    };
  }

}
