import 'dart:typed_data';
import 'dart:convert';

class ItemLabelDto {
  final int id;
  final Uint8List qrImage;

  ItemLabelDto({
    required this.id,
    required this.qrImage,
  });

  factory ItemLabelDto.fromBase64(String base64String, int id) {
    final Uint8List decoded = base64Decode(base64String);
    return ItemLabelDto(id: id, qrImage: decoded);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': base64Encode(qrImage),
    };
  }
}
