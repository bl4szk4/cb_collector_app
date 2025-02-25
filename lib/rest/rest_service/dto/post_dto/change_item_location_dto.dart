import '../../../interfaces/dto.dart';


class ChangeItemLocationDto implements DTO<ChangeItemLocationDto>{
  int itemId;
  int locationId;

  ChangeItemLocationDto({
    required this.locationId,
    required this.itemId
  });

  @override
  Map<String, dynamic> toJson(){
    return {
      'id_item': itemId,
      'id_location': locationId
    };
  }

}
