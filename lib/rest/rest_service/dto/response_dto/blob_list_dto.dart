import '../response_dto/label_dto.dart';

class BlobListDto {
  final List<ItemLabelDto> blobList;

  BlobListDto({
    required this.blobList,
  });

  factory BlobListDto.fromJson(Map<String, dynamic> json) {
    final List<dynamic> labelList = json["label"] as List<dynamic>;

    final List<ItemLabelDto> items = labelList
        .asMap()
        .entries
        .map((entry) => ItemLabelDto.fromBase64(entry.value as String, entry.key + 1))
        .toList();

    return BlobListDto(blobList: items);
  }

  Map<String, dynamic> toJson() {
    return {
      "label": blobList.map((item) => item.toJson()).toList(),
    };
  }
}
