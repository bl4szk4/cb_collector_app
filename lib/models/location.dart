import 'package:pbl_collector/models/room.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/location_dto.dart';


class Location{
  int id;
  String name;
  int roomId;
  Room room;
  String? qrCode;
  String? description;

  Location({
    required this.id,
    required this.name,
    required this.roomId,
    required this.room,
    this.qrCode,
    this.description
  });

  @override
  factory Location.fromDTO(LocationDTO dto){
    return Location(
        id: dto.id,
        name: dto.name,
        roomId: dto.roomId,
        room: Room.fromDTO(dto.room),
        qrCode: dto.qrCode,
        description: dto.description
    );
  }
}