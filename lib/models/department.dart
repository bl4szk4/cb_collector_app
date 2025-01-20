import 'package:pbl_collector/rest/rest_service/dto/get_dto/department_dto.dart';


class Department{
  int id;
  int facultyId;
  String name;
  String? description;

  Department({
    required this.id,
    required this.facultyId,
    required this.name,
    this.description
  });

  @override
  factory Department.fromDTO(DepartmentDTO dto){
    return Department(
        id: dto.id,
        facultyId: dto.facultyId,
        name: dto.name,
        description: dto.description
    );
  }
}