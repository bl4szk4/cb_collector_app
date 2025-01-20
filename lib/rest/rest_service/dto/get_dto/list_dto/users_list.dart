import '../user_details_dto.dart';

class UsersListDTO{
  List<UserDetailsDTO> usersList;

  UsersListDTO({required this.usersList});

  factory UsersListDTO.fromJson(dynamic json){
    var users = json["users"];

    List<UserDetailsDTO> usersList = users.map((user) => UsersListDTO.fromJson(user)).toList();

    return UsersListDTO(usersList: usersList);
  }
}