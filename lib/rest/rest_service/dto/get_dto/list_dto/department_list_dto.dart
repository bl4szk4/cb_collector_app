import '../department_dto.dart';


class DepartmentListDto{
  List<DepartmentDTO> departmentsList;

  DepartmentListDto({
    required this.departmentsList
  });

  factory DepartmentListDto.fromJson(dynamic json){
    var departments = json["departments"];

    List<DepartmentDTO> departmentsList = departments.map((faculty) => DepartmentDTO.fromJson(faculty)).toList();

    return DepartmentListDto(departmentsList: departmentsList);
  }
}