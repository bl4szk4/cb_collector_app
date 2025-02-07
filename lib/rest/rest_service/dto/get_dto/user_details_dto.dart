import 'department_dto.dart';

class UserDetailsDTO {
  int id;
  String username;
  String email;
  String title;
  String name;
  String surname;
  DepartmentDTO? department;

  UserDetailsDTO({
    required this.id,
    required this.username,
    required this.email,
    required this.title,
    required this.name,
    required this.surname,
    this.department,
  });

  @override
  factory UserDetailsDTO.fromJson(dynamic json) {
    return UserDetailsDTO(
      id: json["id"] as int,
      username: json["username"] as String,
      email: json["email"] as String,
      title: json["title"] as String,
      name: json["name"] as String,
      surname: json["surname"] as String,
      department: json["department"] != null
          ? DepartmentDTO.fromJson(json["department"])
          : null,
    );
  }
}