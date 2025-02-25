import '../location_dto.dart';


class LocationsListDTO{
  List<LocationDTO> locationsList;

  LocationsListDTO({
    required this.locationsList
  });

  factory LocationsListDTO.fromJson(dynamic json){
    var locations = json is List? json : json["items"];

    List<LocationDTO> locationsList = (locations as List<dynamic>)
        .map((location) => LocationDTO.fromJson(location)).toList();

    return LocationsListDTO(locationsList: locationsList);
  }
}