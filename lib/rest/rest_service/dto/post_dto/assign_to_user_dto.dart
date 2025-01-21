import '../../../interfaces/dto.dart';


class AssignToUserDto implements DTO<AssignToUserDto>{
  int itemId;
  int userId;

  AssignToUserDto({
    required this.itemId,
    required this.userId
  });

  @override
  Map<String, dynamic> toJson(){
    return {
      'item_id': itemId,
      'user_id': userId
    };
  }

}
