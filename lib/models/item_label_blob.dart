import 'dart:typed_data';
import '../rest/rest_service/dto/response_dto/label_dto.dart';

class ItemLabelBlob {
  final int id;
  final Uint8List labelImage;

  ItemLabelBlob({
    required this.id,
    required this.labelImage,
  });

  factory ItemLabelBlob.fromDTO(ItemLabelDto dto) {
    return ItemLabelBlob(
      id: dto.id,
      labelImage: dto.qrImage,
    );
  }
  
}
