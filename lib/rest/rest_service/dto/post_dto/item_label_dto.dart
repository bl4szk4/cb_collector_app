import '../../../interfaces/dto.dart';
import 'package:pbl_collector/enums/label_type.dart';


class ItemLabelDto implements DTO<ItemLabelDto>{
  int id;

  ItemLabelDto({
    required this.id,
  });

  @override
  Map<String, dynamic> toJson(){
    return {
      'id_item': [id]
      // 'labelType': labelType.value
    };
  }

}
