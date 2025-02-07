import 'package:pbl_collector/rest/rest_service/dto/get_dto/department_dto.dart';

class RoomDTO{
  int id;
  String number;
  int departmentId;
  DepartmentDTO department;
  String? qrCode;

  RoomDTO({
    required this.id,
    required this.number,
    required this.departmentId,
    required this.department,
    this.qrCode
  });

  @override
  factory RoomDTO.fromJson(dynamic json){
    return RoomDTO(
        id: json["id"],
        number: json["number"],
        departmentId: json["department_id"],
        qrCode: json["qr_code"],
        department: DepartmentDTO.fromJson(json["department"])
    );
  }
}
