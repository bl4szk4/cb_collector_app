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
      'id_item': itemId,
      'id_user': userId
    };
  }

}
