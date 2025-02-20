import 'package:pbl_collector/models/sub_models/item_type.dart';
import 'package:pbl_collector/models/user.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/items_details_action_dto.dart';

import 'location.dart';

class ItemDetailsAction{
  int id;
  String name;
  int userId;
  int currentUserId;

  ItemDetailsAction({
    required this.id,
    required this.name,
    required this.userId,
    required this.currentUserId,
  });

  @override
  factory ItemDetailsAction.fromDTO(ItemsDetailsActionDto dto){
    return ItemDetailsAction(
        id: dto.id,
        name: dto.name,
        userId: dto.userId,
        currentUserId: dto.currentUserId,
    );
  }

}
