import '../../../interfaces/dto.dart';


class AssignToUserDto implements DTO<AssignToUserDto>{
  int itemId;

  AssignToUserDto({
    required this.itemId,
  });

  @override
  Map<String, dynamic> toJson(){
    return {
      'item_id': itemId,
    };
  }

}
