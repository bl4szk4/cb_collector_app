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
import 'package:pbl_collector/rest/rest_service/dto/response_dto/blob_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/response_dto/blob_list_dto.dart';
import 'dto/get_dto/items_details_action_dto.dart';
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
  static const List<int> acceptableStatusCodes = [200, 201, 204];

  RestService({required this.baseUrl});

  Future<T> _makeRequest<T>(
      String endpoint, {
        required String method,
        Map<String, String>? headers,
        dynamic body,
        T Function(Map<String, dynamic>)? parser,
      }) async {
    final url = endpoint.startsWith('http') ? Uri.parse(endpoint) : Uri.parse('$baseUrl$endpoint');

    try {
      logger.i('Request: $method $url');
      if (body != null) logger.i('Body: ${json.encode(body)}');

      headers ??= {};
      headers['Content-Type'] = 'application/json';

      final response = await (method == 'POST'
          ? http.post(url, headers: headers, body: utf8.encode(json.encode(body)))
          : http.get(url, headers: headers))
          .timeout(timeoutDuration);

      if (response.statusCode == 307) {
        final newUrl = response.headers['location'];
        if (newUrl != null) {
          return _makeRequest<T>(
            newUrl.replaceFirst(baseUrl, ''),
            method: method,
            headers: headers,
            body: body,
            parser: parser,
          );
        }
      }

      logger.i('Status: ${response.statusCode}');
      logger.i('Response: ${response.body}');

      if (!acceptableStatusCodes.contains(response.statusCode)) {
        throw Exception("HTTP ${response.statusCode}: ${response.body}");
      }

      if (response.body.isEmpty) {
        throw Exception("Empty response from $method request to $endpoint");
      }

      final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse is List) {
        return parser != null ? parser({'items': jsonResponse}) : jsonResponse as T;
      }
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
    logger.i(url);
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
      '/user/get_users/',
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
      '/item/get_items_for_user/',
      parser: (json) => ItemsListDTO.fromJson(json),
    );
  }

  Future<ItemsListDTO> getItemsInRoom(LoggedUser user, int roomId) async {
    return _getWithAuth(
      user,
      '/item/room/$roomId',
      parser: (json) => ItemsListDTO.fromJson(json),
    );
  }

  Future<ItemsListDTO> getItemsInLocation(LoggedUser user, int locationId) async {
    return _getWithAuth(
      user,
      '/item/location/$locationId',
      parser: (json) => ItemsListDTO.fromJson(json),
    );
  }

  Future<ItemDetailsDTO> getItemDetails(LoggedUser user, String itemQR) async {
    return _getWithAuth(
      user,
      '/item/get_item_detailed/',
      params: {"item_qr_code": itemQR},
      parser: (json) => ItemDetailsDTO.fromJson(json),
    );
  }

  Future<ItemDetailsDTO> getItemDetailsById(LoggedUser user, int itemId) async {
    logger.i("sending $itemId");
    return _getWithAuth(
      user,
      '/item/get_item_detailed/$itemId',
      parser: (json) => ItemDetailsDTO.fromJson(json),
    );
  }

  Future<ItemQRCodeDto> getItemQRCode(
      LoggedUser user,
      int itemId,
      ) async {
    return _makeRequest(
      '/item/qr/$itemId',
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${user.token?.access}',
      },
      parser: (json) => ItemQRCodeDto.fromJson(json),
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

  Future<ItemsDetailsActionDto> performItemAction(
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
      parser: (json) => ItemsDetailsActionDto.fromJson(json),
    );
  }

  Future<ItemsDetailsActionDto> assignItem(LoggedUser user, AssignToUserDto data) {
    return performItemAction(user, 'assign_to_user', data);
  }

  Future<ItemsDetailsActionDto> returnItem(LoggedUser user, GeneralItemIDDTO data) {
    return performItemAction(user, 'return_to_owner', data);
  }

  Future<ItemsDetailsActionDto> changeItemLocation(LoggedUser user, ChangeItemLocationDto data) {
    return performItemAction(user, 'change_location', data);
  }

  Future<ItemsDetailsActionDto> markMissingItem(LoggedUser user, GeneralItemIDDTO data) {
    return performItemAction(user, 'mark_missing', data);
  }

  Future<ItemsDetailsActionDto> markLowItem(LoggedUser user, GeneralItemIDDTO data) {
    return performItemAction(user, 'mark_low_level', data);
  }

  Future<ItemsDetailsActionDto> markEmptyItem(LoggedUser user, GeneralItemIDDTO data) {
    return performItemAction(user, 'mark_empty', data);
  }

  Future<ItemsDetailsActionDto> disposeItem(LoggedUser user, GeneralItemIDDTO data) {
    return performItemAction(user, 'dispose_of_item', data);
  }
}
