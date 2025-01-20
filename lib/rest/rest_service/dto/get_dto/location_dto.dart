class LocationDTO{
  int id;
  int roomId;
  String? description;


  LocationDTO({
    required this.id,
    required this.roomId,
    this.description
  });

  @override
  factory LocationDTO.fromJson(dynamic json){
    return LocationDTO(
        id: json["id"],
        roomId: json["roomId"],
        description: json["description"]
    );
  }
}