import '../../../interfaces/dto.dart';

class TokenDTO implements DTO<TokenDTO>{
  String access;

  TokenDTO({required this.access});

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  factory TokenDTO.fromJson(Map<String, dynamic> json) {
    return TokenDTO(
      access: json['jwt_token'],
    );
  }

}