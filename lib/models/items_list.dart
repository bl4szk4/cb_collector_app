import 'package:pbl_collector/models/item_details_list.dart';

import 'package:pbl_collector/rest/rest_service/dto/get_dto/list_dto/items_list_dto.dart';


class ItemsList{
  List<ItemDetailsList> itemsList;

  ItemsList({
    required this.itemsList
  });

  factory ItemsList.fromDTO(ItemsListDTO dto){
    var items = dto.itemsList;

    List<ItemDetailsList> itemsList = items.map((item) => ItemDetailsList.fromDTO(item)).toList();

    return ItemsList(itemsList: itemsList);
  }
}