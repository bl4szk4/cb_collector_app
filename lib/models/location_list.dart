import 'location.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/list_dto/locations_list.dart';


class LocationsList{
  List<Location> locationsList;

  LocationsList({
    required this.locationsList
});

  factory LocationsList.fromDTO(LocationsListDTO dto){
    var locations = dto.locationsList;

    List<Location> locationsList = locations.map((location) => Location.fromDTO(location)).toList();

    return LocationsList(locationsList: locationsList);
  }
}