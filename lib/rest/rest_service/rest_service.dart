import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/items_details_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/location_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/room_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/post_dto/assign_to_user_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/post_dto/change_item_location_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/post_dto/list_users_params.dart';
import 'package:pbl_collector/rest/rest_service/dto/post_dto/return_item_dto.dart';
import 'package:pbl_collector/models/logged_user.dart';
import 'package:pbl_collector/rest/rest_service/dto/response_dto/blob_list_dto.dart';
import 'dto/get_dto/list_dto/department_list_dto.dart';
import 'dto/get_dto/login_dto.dart';
import 'dto/get_dto/list_dto/faculty_list_dto.dart';
import 'dto/get_dto/list_dto/items_list_dto.dart';
import 'dto/get_dto/list_dto/locations_list.dart';
import 'dto/get_dto/list_dto/rooms_list_dto.dart';
import 'dto/get_dto/list_dto/users_list.dart';
import 'dto/post_dto/add_room_dto.dart';
import 'dto/post_dto/add_location_dto.dart';
import 'dto/response_dto/token_dto.dart';


class RestService {
  final String baseUrl;
  final Logger logger = Logger();
  final Duration timeoutDuration = const Duration(seconds: 60);

  RestService({required this.baseUrl});

  Future<T> _makeRequest<T>(
      String endpoint, {
        required String method,
        Map<String, String>? headers,
        dynamic body,
        T Function(Map<String, dynamic>)? parser,
      }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      logger.i('Request: $method $url');
      if (body != null) logger.i('Body: $body');

      final response = await (method == 'POST'
          ? http.post(url, headers: headers, body: json.encode(body))
          : http.get(url, headers: headers))
          .timeout(timeoutDuration);

      logger.i('Response: ${response.body}');
      final jsonResponse = json.decode(response.body);
      return parser != null ? parser(jsonResponse) : jsonResponse as T;
    } catch (e) {
      throw Exception("Error in $method request to $endpoint: $e");
    }
  }

  Future<T> _getWithAuth<T>(
      LoggedUser user,
      String endpoint, {
        Map<String, dynamic>? params,
        required T Function(Map<String, dynamic>) parser,
      }) async {
    final url = Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
    return _makeRequest(
      url.toString(),
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${user.token?.access}',
      },
      parser: parser,
    );
  }

  Future<TokenDTO> login(LoginDTO data) async {
    return _makeRequest(
      '/user/login/',
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: data.toJson(),
      parser: (json) => TokenDTO.fromJson(json),
    );
  }

  Future<UsersListDTO> getListOfUsers(LoggedUser user, ListUsersParamsDto data) async {
    return _getWithAuth(
      user,
      '/user/users/',
      params: data.toJson(),
      parser: (json) => UsersListDTO.fromJson(json),
    );
  }

  Future<FacultyListDTO> getListOfFaculties(LoggedUser user) async {
    return _getWithAuth(
      user,
      '/location/get-faculties/',
      parser: (json) => FacultyListDTO.fromJson(json),
    );
  }

  Future<DepartmentListDto> getListOfDepartments(LoggedUser user, int facultyId) async {
    return _getWithAuth(
      user,
      '/location/get-departments/$facultyId/',
      parser: (json) => DepartmentListDto.fromJson(json),
    );
  }

  Future<RoomsListDTO> getListOfRooms(LoggedUser user, int departmentId) async {
    return _getWithAuth(
      user,
      '/location/get-rooms/$departmentId/',
      parser: (json) => RoomsListDTO.fromJson(json),
    );
  }

  Future<LocationsListDTO> getListOfLocations(LoggedUser user, int roomId) async {
    return _getWithAuth(
      user,
      '/location/get-rooms/$roomId/',
      parser: (json) => LocationsListDTO.fromJson(json),
    );
  }

  Future<RoomDTO> addRoom(LoggedUser user, AddRoomDTO data) async {
    return _makeRequest(
      '/location/add-room/',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${user.token?.access}',
      },
      body: data.toJson(),
      parser: (json) => RoomDTO.fromJson(json),
    );
  }

  Future<LocationDTO> addLocation(LoggedUser user, AddLocationDto data) async {
    return _makeRequest(
      '/location/add-location/',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${user.token?.access}',
      },
      body: data.toJson(),
      parser: (json) => LocationDTO.fromJson(json),
    );
  }

  Future<ItemsListDTO> getItems(LoggedUser user) async {
    return _getWithAuth(
      user,
      '/item/get-items/',
      parser: (json) => ItemsListDTO.fromJson(json),
    );
  }

  Future<BlobListDto> printLabel(
      LoggedUser user,
      dynamic data,
      ) async {
    return _makeRequest(
      '/item/label/',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${user.token?.access}',
      },
      body: data.toJson(),
      parser: (json) => BlobListDto.fromJson(json),
    );
  }

  Future<ItemDetailsDTO> performItemAction(
      LoggedUser user,
      String action,
      dynamic data,
      ) async {
    return _makeRequest(
      '/item/$action/',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${user.token?.access}',
      },
      body: data.toJson(),
      parser: (json) => ItemDetailsDTO.fromJson(json),
    );
  }

  Future<ItemDetailsDTO> assignItem(LoggedUser user, AssignToUserDto data) {
    return performItemAction(user, 'assign-to-user', data);
  }

  Future<ItemDetailsDTO> returnItem(LoggedUser user, ReturnItemDto data) {
    return performItemAction(user, 'return', data);
  }

  Future<ItemDetailsDTO> changeItemLocation(LoggedUser user, ChangeItemLocationDto data) {
    return performItemAction(user, 'change-location', data);
  }

  Future<ItemDetailsDTO> markMissingItem(LoggedUser user, ReturnItemDto data) {
    return performItemAction(user, 'mark-missing', data);
  }

  Future<ItemDetailsDTO> markLowItem(LoggedUser user, ReturnItemDto data) {
    return performItemAction(user, 'mark-low', data);
  }

  Future<ItemDetailsDTO> markEmptyItem(LoggedUser user, ReturnItemDto data) {
    return performItemAction(user, 'mark-empty', data);
  }
}
