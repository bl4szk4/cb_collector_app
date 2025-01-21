class ResponseDTO<T> {
  final int code;
  final T data;

  ResponseDTO(this.code, this.data);
}