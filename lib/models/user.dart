import 'package:pbl_collector/rest/rest_service/dto/get_dto/user_details_dto.dart';
import 'package:pbl_collector/models/department.dart';

class User {
  int id;
  String username;
  String email;
  String title;
  String name;
  String surname;
  Department? department;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.title,
    required this.name,
    required this.surname,
    this.department,
  });

  @override
  factory User.fromDTO(UserDetailsDTO dto) {
    return User(
      id: dto.id,
      username: dto.username,
      email: dto.email,
      title: dto.title,
      name: dto.name,
      surname: dto.surname,
      department: dto.department != null ? Department.fromDTO(dto.department!) : null,
    );
  }
}
