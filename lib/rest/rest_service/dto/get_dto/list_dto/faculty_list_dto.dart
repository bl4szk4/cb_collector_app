import '../faculty_dto.dart';


class FacultyListDTO{
  List<FacultyDTO> facultiesList;

  FacultyListDTO({
    required this.facultiesList
  });

  factory FacultyListDTO.fromJson(dynamic json){
    var faculties = json is List? json : json["faculties"];

    List<FacultyDTO> facultiesList = faculties.map((faculty) => FacultyDTO.fromJson(faculty)).toList();

    return FacultyListDTO(facultiesList: facultiesList);
  }
}