import '../../../interfaces/dto.dart';


class ListUsersParamsDto implements DTO<ListUsersParamsDto>{
  int? facultyId;
  int? departmentId;

  ListUsersParamsDto({
    this.facultyId,
    this.departmentId
  });

  @override
  Map<String, dynamic> toJson(){
    return {
      'department_id': departmentId,
      'faculty_id': facultyId
    };
  }

}
