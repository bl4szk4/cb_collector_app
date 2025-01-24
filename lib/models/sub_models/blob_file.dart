import 'package:pbl_collector/rest/rest_service/dto/response_dto/blob_dto.dart';

class BlobFile {
  final String fileName;
  final String fileUrl;

  BlobFile({
    required this.fileName,
    required this.fileUrl,
  });

  factory BlobFile.fromJson(Map<String, dynamic> json) {
    return BlobFile(
      fileName: json['fileName'] as String,
      fileUrl: json['fileUrl'] as String,
    );
  }


  @override
  factory BlobFile.fromDTO(BlobDto dto){
    return BlobFile(
        fileName: dto.filename,
        fileUrl: dto.fileUrl
    );
  }

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'fileUrl': fileUrl,
    };
  }
}
