import 'faculty.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/list_dto/faculty_list_dto.dart';


class FacultyList{
  List<Faculty> facultiesList;

  FacultyList({
    required this.facultiesList
  });

  factory FacultyList.fromDTO(FacultyListDTO dto){
    var faculties = dto.facultiesList;

    List<Faculty> facultiesList = faculties.map((location) => Faculty.fromDTO(location)).toList();

    return FacultyList(facultiesList: facultiesList);
  }
}