import 'package:pbl_collector/rest/rest_service/dto/get_dto/room_dto.dart';


class Room{
  int id;
  int number;
  int departmentId;

  Room({required this.id, required this.number, required this.departmentId});

  @override
  factory Room.fromDTO(RoomDTO dto){
    return Room(
        id: dto.id,
        number: dto.number,
        departmentId: dto.departmentId
    );
  }
}