import 'package:flutter/cupertino.dart';

import '../room_dto.dart';


class RoomsListDTO{
  List<RoomDTO> roomsList;

  RoomsListDTO({
    required this.roomsList
});

  factory RoomsListDTO.fromJson(dynamic json){
    var rooms = json is List? json : json["items"];

    List<RoomDTO> roomsList = (rooms as List<dynamic>).map((room) => RoomDTO.fromJson(room)).toList();

    return RoomsListDTO(roomsList: roomsList);
  }
}