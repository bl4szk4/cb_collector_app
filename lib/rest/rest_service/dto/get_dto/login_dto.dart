import '../../../interfaces/dto.dart';


class LoginDTO implements DTO<LoginDTO>{
  String qrCode;

  LoginDTO({required this.qrCode});

  @override
  Map<String, dynamic> toJson(){
    return {
      'qr_code': qrCode
    };
  }

}
