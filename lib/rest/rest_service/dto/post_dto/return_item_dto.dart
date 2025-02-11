import '../../../interfaces/dto.dart';


class GeneralItemIDDTO implements DTO<GeneralItemIDDTO>{
  int itemId;

  GeneralItemIDDTO({
    required this.itemId,
  });

  @override
  Map<String, dynamic> toJson(){
    return {
      'id_item': itemId,
    };
  }

}
