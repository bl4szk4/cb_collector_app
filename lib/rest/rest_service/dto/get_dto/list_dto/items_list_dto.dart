import '../items_details_dto.dart';


class ItemsListDTO{
  List<ItemDetailsDTO> itemsList;

  ItemsListDTO({
    required this.itemsList
  });

  @override
  factory ItemsListDTO.fromJson(dynamic json){
    var items = json["items"];

    List<ItemDetailsDTO> itemsList = items.map((item) => ItemDetailsDTO.fromJson(item)).toList();

    return ItemsListDTO(
      itemsList: itemsList
    );
  }

}