import '../rest/rest_service/dto/response_dto/blob_list_dto.dart';
import 'item_label_blob.dart';

class BlobListBlob {
  final List<ItemLabelBlob> blobList;

  BlobListBlob({
    required this.blobList,
  });

  factory BlobListBlob.fromDTO(BlobListDto dto) {
    return BlobListBlob(
      blobList: dto.blobList.map((item) => ItemLabelBlob.fromDTO(item)).toList(),
    );
  }
}
