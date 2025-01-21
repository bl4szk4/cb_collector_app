import '../../../interfaces/dto.dart';


class ReturnItemDto implements DTO<ReturnItemDto>{
  int itemId;

  ReturnItemDto({
    required this.itemId,
  });

  @override
  Map<String, dynamic> toJson(){
    return {
      'item_id': itemId,
    };
  }

}
