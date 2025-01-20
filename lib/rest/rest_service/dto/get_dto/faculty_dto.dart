class FacultyDTO{
  int id;
  String name;
  String? description;

  FacultyDTO({
    required this.id,
    required this.name,
    this.description
  });

  @override
  factory FacultyDTO.fromJson(dynamic json){
    return FacultyDTO(
      id: json["id"] as int,
      name: json["name"] as String,
      description: json["description"]
    );
  }

}