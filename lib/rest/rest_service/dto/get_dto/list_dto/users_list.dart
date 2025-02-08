import '../user_details_dto.dart';

class UsersListDTO {
  List<UserDetailsDTO> usersList;

  UsersListDTO({required this.usersList});

  factory UsersListDTO.fromJson(dynamic json) {
    var users = (json is List) ? json : json["items"];
    List<UserDetailsDTO> usersList =
    (users as List).map((user) => UserDetailsDTO.fromJson(user)).toList();

    return UsersListDTO(usersList: usersList);
  }
}
