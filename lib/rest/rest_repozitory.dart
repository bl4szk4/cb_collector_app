import 'package:pbl_collector/models/logged_user.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/items_details_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/list_dto/department_list_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/list_dto/faculty_list_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/list_dto/items_list_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/list_dto/locations_list.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/list_dto/rooms_list_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/list_dto/users_list.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/location_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/login_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/room_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/post_dto/add_location_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/post_dto/add_room_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/post_dto/assign_to_user_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/post_dto/change_item_location_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/post_dto/list_users_params.dart';
import 'package:pbl_collector/rest/rest_service/dto/post_dto/return_item_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/response_dto/token_dto.dart';
import '../utils/config.dart';
import 'package:logger/logger.dart';
import 'rest_service/rest_service.dart';

class RestRepository {
  final Config config;
  final Logger logger = Logger();
  late final RestService restService;

  RestRepository({required this.config}) {
    restService = RestService(baseUrl: config.pblServiceAddress);
  }

  // USER
  Future<TokenDTO> login(LoginDTO data) async {
    return await restService.login(data);
  }

  Future<UsersListDTO> getListOfUsers(LoggedUser user, ListUsersParamsDto data) async {
    return await restService.getListOfUsers(user, data);
  }

  // LOCATION
  Future<FacultyListDTO> getListOfFaculties(LoggedUser user) async {
    return await restService.getListOfFaculties(user);
  }

  Future<DepartmentListDto> getListOfDepartments(LoggedUser user, int facultyId) async {
    return await restService.getListOfDepartments(user, facultyId);
  }

  Future<RoomsListDTO> getListOfRooms(LoggedUser user, int departmentId) async {
    return await restService.getListOfRooms(user, departmentId);
  }

  Future<LocationsListDTO> getListOfLocations(LoggedUser user, int roomId) async {
    return await restService.getListOfLocations(user, roomId);
  }

  Future<RoomDTO> addRoom(LoggedUser user, AddRoomDTO data) async {
    return await restService.addRoom(user, data);
  }

  Future<LocationDTO> addLocation(LoggedUser user, AddLocationDto data) async {
    return await restService.addLocation(user, data);
  }

  // ITEMS
  Future<ItemsListDTO> getItems(LoggedUser user) async {
    return await restService.getItems(user);
  }

  Future<ItemDetailsDTO> assignItem(LoggedUser user, AssignToUserDto data) async {
    return await restService.assignItem(user, data);
  }

  Future<ItemDetailsDTO> returnItem(LoggedUser user, ReturnItemDto data) async {
    return await restService.returnItem(user, data);
  }

  Future<ItemDetailsDTO> changeItemLocation(LoggedUser user, ChangeItemLocationDto data) async {
    return await restService.changeItemLocation(user, data);
  }

  Future<ItemDetailsDTO> markMissingItem(LoggedUser user, ReturnItemDto data) async {
    return await restService.markMissingItem(user, data);
  }

  Future<ItemDetailsDTO> markLowItem(LoggedUser user, ReturnItemDto data) async {
    return await restService.markLowItem(user, data);
  }

  Future<ItemDetailsDTO> markEmptyItem(LoggedUser user, ReturnItemDto data) async {
    return await restService.markEmptyItem(user, data);
  }
}
