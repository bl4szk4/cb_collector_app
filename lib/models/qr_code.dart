import 'dart:convert';
import 'dart:typed_data';

import '../rest/rest_service/dto/response_dto/blob_dto.dart';

class ItemLabel {
  final int id;
  final Uint8List qrImage;

  ItemLabel({
    required this.id,
    required this.qrImage,
  });

  factory ItemLabel.fromJson(Map<String, dynamic> json) {
    return ItemLabel(
      id: json['id'] as int,
      qrImage: base64Decode(json['qr_code'] as String),
    );
  }

  factory ItemLabel.fromDTO(ItemQRCodeDto dto) {
    return ItemLabel(
      id: dto.id,
      qrImage: dto.qrImage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qr_code': base64Encode(qrImage),
    };
  }
}
