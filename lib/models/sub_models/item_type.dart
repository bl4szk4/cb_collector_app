import 'package:pbl_collector/rest/rest_service/dto/get_dto/item_type_dto.dart';

class ItemType{
  int id;
  String casNumber;

  ItemType({required this.id, required this.casNumber});

  @override
  factory ItemType.fromDTO(ItemTypeDTO dto){
    return ItemType(
        id: dto.id,
        casNumber: dto.casNumber
    );
  }
}