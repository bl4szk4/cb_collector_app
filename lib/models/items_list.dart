import 'item_details.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/list_dto/items_list_dto.dart';


class ItemsList{
  List<ItemDetails> itemsList;

  ItemsList({
    required this.itemsList
  });

  factory ItemsList.fromDTO(ItemsListDTO dto){
    var items = dto.itemsList;

    List<ItemDetails> itemsList = items.map((item) => ItemDetails.fromDTO(item)).toList();

    return ItemsList(itemsList: itemsList);
  }
}