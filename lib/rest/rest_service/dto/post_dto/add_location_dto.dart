import '../../../interfaces/dto.dart';


class AddLocationDto implements DTO<AddLocationDto>{
  int roomId;
  String? description;

  AddLocationDto({
    required this.roomId,
    this.description
  });

  @override
  Map<String, dynamic> toJson(){
    return {
      'room_id': roomId,
      'description': description
    };
  }

}
