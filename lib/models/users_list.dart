import 'user.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/list_dto/users_list.dart';


class UsersList{
  List<User> usersList;

  UsersList({
    required this.usersList
  });

  factory UsersList.fromDTO(UsersListDTO dto){
    var users = dto.usersList;

    List<User> usersList = users.map((user) => User.fromDTO(user)).toList();

    return UsersList(usersList: usersList);
  }
}