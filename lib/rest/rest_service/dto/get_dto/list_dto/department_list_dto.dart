import '../department_dto.dart';


class DepartmentListDto{
  List<DepartmentDTO> departmentsList;

  DepartmentListDto({
    required this.departmentsList
  });

  factory DepartmentListDto.fromJson(dynamic json){
    var departments = json["departments"];

    List<DepartmentDTO> departmentsList = departments.map((department) => DepartmentDTO.fromJson(department)).toList();

    return DepartmentListDto(departmentsList: departmentsList);
  }
}