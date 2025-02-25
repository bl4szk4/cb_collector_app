import '../department_dto.dart';


class DepartmentListDto{
  List<DepartmentDTO> departmentsList;

  DepartmentListDto({
    required this.departmentsList
  });

  factory DepartmentListDto.fromJson(dynamic json){
    var departments = json is List? json : json["items"];

    List<DepartmentDTO> departmentsList = (departments as List<dynamic>)
        .map((department) => DepartmentDTO.fromJson(department)).toList();

    return DepartmentListDto(departmentsList: departmentsList);
  }
}