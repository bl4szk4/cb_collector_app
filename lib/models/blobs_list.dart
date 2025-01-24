import 'sub_models/blob_file.dart';
import 'package:pbl_collector/rest/rest_service/dto/response_dto/blob_list_dto.dart';


class BlobsList{
  List<BlobFile> blobsList;

  BlobsList({
    required this.blobsList
  });

  factory BlobsList.fromDTO(BlobListDto dto){
    var blobs = dto.blobList;

    List<BlobFile> blobsList = blobs.map((blob) => BlobFile.fromDTO(blob)).toList();

    return BlobsList(blobsList: blobsList);
  }
}