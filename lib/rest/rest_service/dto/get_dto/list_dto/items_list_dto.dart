import 'package:pbl_collector/rest/rest_service/dto/get_dto/items_details_list_dto.dart';

import '../items_details_dto.dart';


class ItemsListDTO{
  List<ItemDetailsListDTO> itemsList;

  ItemsListDTO({
    required this.itemsList
  });

  @override
  factory ItemsListDTO.fromJson(dynamic json) {
    var items = json is List ? json : json["items"];

    List<ItemDetailsListDTO> itemsList = (items as List<dynamic>)
        .map((item) => ItemDetailsListDTO.fromJson(item))
        .toList();

    return ItemsListDTO(
        itemsList: itemsList
    );
  }

}