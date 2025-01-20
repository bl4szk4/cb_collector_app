import 'department.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/list_dto/department_list_dto.dart';


class DepartmentsList{
  List<Department> departmentsList;

  DepartmentsList({
    required this.departmentsList
  });

  factory DepartmentsList.fromDTO(DepartmentListDto dto){
    var faculties = dto.departmentsList;

    List<Department> departmentsList = faculties.map((location) => Department.fromDTO(location)).toList();

    return DepartmentsList(departmentsList: departmentsList);
  }
}