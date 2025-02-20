import 'package:logger/logger.dart';

class ItemsDetailsActionDto {
  static final Logger logger = Logger();

  int id;
  String name;
  int userId;
  int currentUserId;

  ItemsDetailsActionDto({
    required this.id,
    required this.name,
    required this.userId,
    required this.currentUserId,
  });

  @override
  factory ItemsDetailsActionDto.fromJson(dynamic json) {
    final id = json["id"] as int;
    final name = json["name"] as String;
    final userId = json["user_id"] as int;
    final currentUserId = json["current_user_id"] as int;

    return ItemsDetailsActionDto(
      id: id,
      name: name,
      userId: userId,
      currentUserId: currentUserId,
    );

  }
}
