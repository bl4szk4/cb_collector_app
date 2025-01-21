class BlobDto{
  int id;
  String filename;
  String fileUrl;
  String fileType;
  int fileSize;

  BlobDto({
    required this.id,
    required this.filename,
    required this.fileUrl,
    required this.fileSize,
    required this.fileType,
  });

  @override
  factory BlobDto.fromJson(Map<String, dynamic> json) {
    return BlobDto(
      id: json['id'] as int,
      filename: json['filename'] as String,
      fileUrl: json['file_url'] as String,
      fileSize: json['file_size'] as int,
      fileType: json['file_type'] as String
    );
  }

}
