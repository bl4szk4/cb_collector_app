import 'package:pbl_collector/rest/rest_service/dto/get_dto/location_dto.dart';


class Location{
  int id;
  int roomId;
  String? description;

  Location({required this.id, required this.roomId, this.description});

  @override
  factory Location.fromDTO(LocationDTO dto){
    return Location(
        id: dto.id,
        roomId: dto.roomId,
        description: dto.description
    );
  }
}