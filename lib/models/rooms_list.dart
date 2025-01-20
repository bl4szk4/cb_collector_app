import 'room.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/list_dto/rooms_list_dto.dart';


class RoomsList{
  List<Room> roomsList;

  RoomsList({
    required this.roomsList
  });

  factory RoomsList.fromDTO(RoomsListDTO dto){
    var rooms = dto.roomsList;

    List<Room> roomsList = rooms.map((location) => Room.fromDTO(location)).toList();

    return RoomsList(roomsList: roomsList);
  }
}