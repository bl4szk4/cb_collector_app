class DepartmentDTO{
  int id;
  int facultyId;
  String name;
  String? description;

  DepartmentDTO({
    required this.id,
    required this.facultyId,
    required this.name,
    this.description
  });

  @override
  factory DepartmentDTO.fromJson(dynamic json){
    return DepartmentDTO(
        id: json["id"],
        facultyId: json["facultyId"],
        name: json["name"],
        description: json["description"]
    );
  }
}
