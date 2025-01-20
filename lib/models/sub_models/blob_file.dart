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

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'fileUrl': fileUrl,
    };
  }
}
