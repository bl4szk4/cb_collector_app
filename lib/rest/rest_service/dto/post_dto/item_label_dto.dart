import '../../../interfaces/dto.dart';
import 'package:pbl_collector/enums/label_type.dart';


class ItemLabelDto implements DTO<ItemLabelDto>{
  int id;
  LabelType labelType;

  ItemLabelDto({
    required this.id,
    required this.labelType
  });

  @override
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'labelType': labelType.value
    };
  }

}
