import '../location_dto.dart';


class LocationsListDTO{
  List<LocationDTO> locationsList;

  LocationsListDTO({
    required this.locationsList
  });

  factory LocationsListDTO.fromJson(dynamic json){
    var locations = json["locations"];

    List<LocationDTO> locationsList = locations.map((location) => LocationDTO.fromJson(location)).toList();

    return LocationsListDTO(locationsList: locationsList);
  }
}