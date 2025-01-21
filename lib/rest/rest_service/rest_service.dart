import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/items_details_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/location_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/room_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/post_dto/assign_to_user_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/post_dto/change_item_location_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/post_dto/item_label_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/post_dto/list_users_params.dart';
import 'package:pbl_collector/rest/rest_service/dto/post_dto/return_item_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/response_dto/blob_list_dto.dart';
import 'dto/response_dto/response_dto.dart';
import 'package:pbl_collector/models/logged_user.dart';
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


class RestService{
  final String baseUrl;
  final String locationUrl = 'location';
  final String itemUrl = 'item';
  final String userUrl = 'user';
  final Logger logger = Logger();
  final Duration duration = const Duration(seconds: 60);

  RestService({required this.baseUrl});

  // USER

  Future<ResponseDTO<TokenDTO>> login(LoginDTO data) async{
    final endpoint = "$userUrl/login/";
    final url = Uri.parse('$baseUrl$endpoint');
    try{
      logger.i(url);
      logger.i(data.toJson());
      final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data.toJson())
      ).timeout(duration);
      logger.i(response.body);
      return ResponseDTO(0, TokenDTO.fromJson(json.decode(response.body)));
    }
    catch (e){
      throw Exception("Error in POST login: $e");
    }
  }

  Future<UsersListDTO> getListOfUsers(LoggedUser user, ListUsersParamsDto data) async{
    final endpoint = "$userUrl/users/";
    final url = Uri.parse('$baseUrl$endpoint');
    try{
      logger.i(url);
      String? accessToken = user.token?.access;
      final uriWithParams = url.replace(queryParameters: data.toJson());

      final response = await http.get(
        uriWithParams,
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
      ).timeout(duration);
      logger.i(response.body);
      return UsersListDTO.fromJson(json.decode(response.body));
    }
    catch (e){
      throw Exception("Error in GET list of users: $e");
    }
  }

  // LOCATION

  Future<FacultyListDTO> getListOfFaculties(LoggedUser user) async{
    final endpoint = "$locationUrl/get-faculties/";
    final url = Uri.parse('$baseUrl$endpoint');
    try{
      logger.i(url);
      String? accessToken = user.token?.access;

      final response = await http.get(
          url,
          headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
      ).timeout(duration);
      logger.i(response.body);
      return FacultyListDTO.fromJson(json.decode(response.body));
    }
    catch (e){
      throw Exception("Error in GET list of faculties: $e");
    }
  }

  Future<DepartmentListDto> getListOfDepartments(LoggedUser user, int facultyId) async{
    final endpoint = "$locationUrl/get-departments/$facultyId/";
    final url = Uri.parse('$baseUrl$endpoint');
    try{
      logger.i(url);
      String? accessToken = user.token?.access;

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
      ).timeout(duration);
      logger.i(response.body);
      return DepartmentListDto.fromJson(json.decode(response.body));
    }
    catch (e){
      throw Exception("Error in GET list of departments: $e");
    }
  }

  Future<RoomsListDTO> getListOfRooms(LoggedUser user, int departmentId) async{
    final endpoint = "$locationUrl/get-rooms/$departmentId/";
    final url = Uri.parse('$baseUrl$endpoint');
    try{
      logger.i(url);
      String? accessToken = user.token?.access;

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
      ).timeout(duration);
      logger.i(response.body);
      return RoomsListDTO.fromJson(json.decode(response.body));
    }
    catch (e){
      throw Exception("Error in GET list of rooms: $e");
    }
  }

  Future<LocationsListDTO> getListOfLocations(LoggedUser user, int roomId) async{
    final endpoint = "$locationUrl/get-rooms/$roomId/";
    final url = Uri.parse('$baseUrl$endpoint');
    try{
      logger.i(url);
      String? accessToken = user.token?.access;

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
      ).timeout(duration);
      logger.i(response.body);
      return LocationsListDTO.fromJson(json.decode(response.body));
    }
    catch (e){
      throw Exception("Error in GET list of locations: $e");
    }
  }
  Future<RoomDTO> addRoom(LoggedUser user, AddRoomDTO data) async{
    final endpoint = "$locationUrl/add-room/";
    final url = Uri.parse('$baseUrl$endpoint');
    try{
      logger.i(url);
      String? accessToken = user.token?.access;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
        body: json.encode(data.toJson()),
      ).timeout(duration);
      logger.i(response.body);
      return RoomDTO.fromJson(json.decode(response.body));
    }
    catch (e){
      throw Exception("Error in POST add room: $e");
    }
  }
  Future<LocationDTO> addLocation(LoggedUser user, AddLocationDto data) async{
    final endpoint = "$locationUrl/add-location/";
    final url = Uri.parse('$baseUrl$endpoint');
    try{
      logger.i(url);
      String? accessToken = user.token?.access;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
        body: json.encode(data.toJson()),
      ).timeout(duration);
      logger.i(response.body);
      return LocationDTO.fromJson(json.decode(response.body));
    }
    catch (e){
      throw Exception("Error in POST add location: $e");
    }
  }

  // ITEMS

  Future<ItemsListDTO> getItems(LoggedUser user) async{
    final endpoint = "$itemUrl/get-items/";
    final url = Uri.parse('$baseUrl$endpoint');
    try{
      logger.i(url);
      String? accessToken = user.token?.access;

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
      ).timeout(duration);
      logger.i(response.body);
      return ItemsListDTO.fromJson(json.decode(response.body));
    }
    catch (e){
      throw Exception("Error in GET list of items: $e");
    }
  }

  Future<BlobListDto> itemLabel(LoggedUser user, ItemLabelDto data) async{
    final endpoint = "$itemUrl/label/";
    final url = Uri.parse('$baseUrl$endpoint');
    try{
      logger.i(url);
      String? accessToken = user.token?.access;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
        body: json.encode(data.toJson()),
      ).timeout(duration);
      logger.i(response.body);
      return BlobListDto.fromJson(json.decode(response.body));
    }
    catch (e){
      throw Exception("Error in POST label item: $e");
    }
  }

  Future<ItemDetailsDTO> assignItem(LoggedUser user, AssignToUserDto data) async {
    final endpoint = "$itemUrl/assign-to-user/";
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      logger.i(url);
      String? accessToken = user.token?.access;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
        body: json.encode(data.toJson()),
      ).timeout(duration);
      logger.i(response.body);
      return ItemDetailsDTO.fromJson(json.decode(response.body));
    }
    catch (e) {
      throw Exception("Error in POST assign item: $e");
    }
  }

  Future<ItemDetailsDTO> returnItem(LoggedUser user, ReturnItemDto data) async {
    final endpoint = "$itemUrl/return/";
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      logger.i(url);
      String? accessToken = user.token?.access;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
        body: json.encode(data.toJson()),
      ).timeout(duration);
      logger.i(response.body);
      return ItemDetailsDTO.fromJson(json.decode(response.body));
    }
    catch (e) {
      throw Exception("Error in POST return item: $e");
    }
  }

  Future<ItemDetailsDTO> changeItemLocation(LoggedUser user, ChangeItemLocationDto data) async {
    final endpoint = "$itemUrl/change-location/";
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      logger.i(url);
      String? accessToken = user.token?.access;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
        body: json.encode(data.toJson()),
      ).timeout(duration);
      logger.i(response.body);
      return ItemDetailsDTO.fromJson(json.decode(response.body));
    }
    catch (e) {
      throw Exception("Error in POST change location item: $e");
    }
  }

  Future<ItemDetailsDTO> disposeItem(LoggedUser user, ReturnItemDto data) async {
    final endpoint = "$itemUrl/dispose/";
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      logger.i(url);
      String? accessToken = user.token?.access;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
        body: json.encode(data.toJson()),
      ).timeout(duration);
      logger.i(response.body);
      return ItemDetailsDTO.fromJson(json.decode(response.body));
    }
    catch (e) {
      throw Exception("Error in POST dispose item: $e");
    }
  }

  Future<ItemDetailsDTO> markMissingItem(LoggedUser user, ReturnItemDto data) async {
    final endpoint = "$itemUrl/mark-missing/";
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      logger.i(url);
      String? accessToken = user.token?.access;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
        body: json.encode(data.toJson()),
      ).timeout(duration);
      logger.i(response.body);
      return ItemDetailsDTO.fromJson(json.decode(response.body));
    }
    catch (e) {
      throw Exception("Error in POST mark missing item: $e");
    }
  }

  Future<ItemDetailsDTO> markLowItem(LoggedUser user, ReturnItemDto data) async {
    final endpoint = "$itemUrl/mark-low/";
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      logger.i(url);
      String? accessToken = user.token?.access;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
        body: json.encode(data.toJson()),
      ).timeout(duration);
      logger.i(response.body);
      return ItemDetailsDTO.fromJson(json.decode(response.body));
    }
    catch (e) {
      throw Exception("Error in POST mark low item: $e");
    }
  }
  Future<ItemDetailsDTO> markEmptyItem(LoggedUser user, ReturnItemDto data) async {
    final endpoint = "$itemUrl/mark-empty/";
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      logger.i(url);
      String? accessToken = user.token?.access;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',},
        body: json.encode(data.toJson()),
      ).timeout(duration);
      logger.i(response.body);
      return ItemDetailsDTO.fromJson(json.decode(response.body));
    }
    catch (e) {
      throw Exception("Error in POST mark empty item: $e");
    }
  }


}