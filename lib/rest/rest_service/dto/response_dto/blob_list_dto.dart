import 'blob_dto.dart';


class BlobListDto{
  List<ItemQRCodeDto> blobList;

  BlobListDto({
    required this.blobList
  });

  factory BlobListDto.fromJson(dynamic json){
    var blobs = json["blobs"];

    List<ItemQRCodeDto> blobList = blobs.map((blob) => ItemQRCodeDto.fromJson(blob)).toList();

    return BlobListDto(blobList: blobList);
  }
}