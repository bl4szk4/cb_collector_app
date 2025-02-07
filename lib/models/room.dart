import 'package:pbl_collector/models/department.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/room_dto.dart';


class Room{
  int id;
  String number;
  int departmentId;
  Department? department;
  String? qrCode;

  Room({
    required this.id,
    required this.number,
    required this.departmentId,
    this.department,
    this.qrCode
  });

  @override
  factory Room.fromDTO(RoomDTO dto){
    return Room(
        id: dto.id,
        number: dto.number,
        departmentId: dto.departmentId,
        department: Department.fromDTO(dto.department),
        qrCode: dto.qrCode
    );
  }
}