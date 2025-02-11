import 'dart:convert';
import 'dart:typed_data';

import '../../../interfaces/dto.dart';

class ItemQRCodeDto implements DTO<ItemQRCodeDto> {
  final int id;
  final Uint8List qrImage;

  ItemQRCodeDto({
    required this.id,
    required this.qrImage,
  });

  factory ItemQRCodeDto.fromJson(Map<String, dynamic> json) {
    final String base64String = json['qr_code'] as String;
    final Uint8List decodedImage = base64Decode(base64String);
    return ItemQRCodeDto(
      id: json['id'] as int,
      qrImage: decodedImage,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'qr_code': base64Encode(qrImage),
    };
  }
}
