import 'blob_dto.dart';


class BlobListDto{
  List<BlobDto> blobList;

  BlobListDto({
    required this.blobList
  });

  factory BlobListDto.fromJson(dynamic json){
    var blobs = json["blobs"];

    List<BlobDto> blobList = blobs.map((blob) => BlobDto.fromJson(blob)).toList();

    return BlobListDto(blobList: blobList);
  }
}