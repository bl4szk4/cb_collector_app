import 'faculty_dto.dart';

class DepartmentDTO {
  int id;
  int facultyId;
  String name;
  String? description;
  FacultyDTO faculty;

  DepartmentDTO({
    required this.id,
    required this.facultyId,
    required this.name,
    this.description,
    required this.faculty,
  });

  @override
  factory DepartmentDTO.fromJson(dynamic json) {
    return DepartmentDTO(
      id: json["id"] as int,
      facultyId: json["id_faculty"] as int,
      name: json["name"] as String,
      description: json["description"] as String?,
      faculty: FacultyDTO.fromJson(json["faculty"]),
    );
  }
}