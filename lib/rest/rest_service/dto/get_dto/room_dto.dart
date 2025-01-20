class RoomDTO{
  int id;
  int number;
  int departmentId;

  RoomDTO({
    required this.id,
    required this.number,
    required this.departmentId
  });

  @override
  factory RoomDTO.fromJson(dynamic json){
    return RoomDTO(
        id: json["id"],
        number: json["number"],
        departmentId: json["departmentId"]
    );
  }
}
