import 'package:pbl_collector/rest/rest_service/dto/get_dto/user_details_dto.dart';


class User{
  int id;
  int departmentId;
  String name;
  String surname;

  User({
    required this.id,
    required this.departmentId,
    required this.name,
    required this.surname
  });

  @override
  factory User.fromDTO(UserDetailsDTO dto){
    return User(
        id: dto.id,
        departmentId: dto.departmentId,
        name: dto.name,
        surname: dto.surname
    );
  }
}