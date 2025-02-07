import 'package:pbl_collector/rest/rest_service/dto/get_dto/room_dto.dart';

class LocationDTO{
  int id;
  String name;
  int roomId;
  RoomDTO room;
  String? qrCode;
  String? description;


  LocationDTO({
    required this.id,
    required this.name,
    required this.roomId,
    required this.room,
    this.qrCode,
    this.description
  });

  @override
  factory LocationDTO.fromJson(dynamic json){
    return LocationDTO(
        id: json["id"],
        name: json["name"],
        roomId: json["room_id"],
        description: json["description"],
        room: RoomDTO.fromJson(json["room"]),
        qrCode: json["qr_code"]
    );
  }
}