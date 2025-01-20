import 'package:pbl_collector/rest/rest_service/dto/get_dto/faculty_dto.dart';


class Faculty{
  int id;
  String name;
  String? description;

  Faculty({required this.id, required this.name, this.description});

  @override
  factory Faculty.fromDTO(FacultyDTO dto){
    return Faculty(
        id: dto.id,
        name: dto.name,
        description: dto.description
    );
  }
}