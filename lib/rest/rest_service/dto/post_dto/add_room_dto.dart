import '../../../interfaces/dto.dart';


class AddRoomDTO implements DTO<AddRoomDTO>{
  int roomNumber;
  int departmentId;

  AddRoomDTO({
    required this.roomNumber,
    required this.departmentId
  });

  @override
  Map<String, dynamic> toJson(){
    return {
      'room_number': roomNumber,
      'department_id': departmentId
    };
  }

}
