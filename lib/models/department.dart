import 'package:pbl_collector/rest/rest_service/dto/get_dto/department_dto.dart';
import 'package:pbl_collector/models/faculty.dart';

class Department {
  int id;
  String name;
  String? description;
  Faculty faculty;

  Department({
    required this.id,
    required this.name,
    this.description,
    required this.faculty,
  });

  @override
  factory Department.fromDTO(DepartmentDTO dto) {
    return Department(
      id: dto.id,
      name: dto.name,
      description: dto.description,
      faculty: Faculty.fromDTO(dto.faculty),
    );
  }
}
