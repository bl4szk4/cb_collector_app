import '../room_dto.dart';


class RoomsListDTO{
  List<RoomDTO> roomsList;

  RoomsListDTO({
    required this.roomsList
});

  factory RoomsListDTO.fromJson(dynamic json){
    var rooms = json["rooms"];

    List<RoomDTO> roomsList = rooms.map((room) => RoomDTO.fromJson(room)).toList();

    return RoomsListDTO(roomsList: roomsList);
  }
}