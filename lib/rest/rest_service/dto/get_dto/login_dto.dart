import '../../../interfaces/dto.dart';


class LoginDTO implements DTO<LoginDTO>{
  String username;
  String password;

  LoginDTO({required this.username, required this.password});

  @override
  Map<String, dynamic> toJson(){
    return {
      'username': username,
      'password': password
    };
  }

}
