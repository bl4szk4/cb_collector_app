class ItemTypeDTO {
  int id;
  String casNumber;

  ItemTypeDTO({
    required this.id,
    required this.casNumber,
  });

  @override
  factory ItemTypeDTO.fromJson(dynamic json) {
    return ItemTypeDTO(
      id: json["id"] as int,
      casNumber: json["cas_number"] as String
    );
  }
}