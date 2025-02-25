
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:pbl_collector/enums/qr_code_type.dart';
import 'package:pbl_collector/models/departments_list.dart';
import 'package:pbl_collector/models/faculties_list.dart';
import 'package:pbl_collector/models/item_details.dart';
import 'package:pbl_collector/models/item_details_action.dart';
import 'package:pbl_collector/models/items_list.dart';
import 'package:pbl_collector/models/location.dart';
import 'package:pbl_collector/models/location_list.dart';
import 'package:pbl_collector/models/qr_code.dart';
import 'package:pbl_collector/models/room.dart';
import 'package:pbl_collector/models/users_list.dart';
import 'package:pbl_collector/rest/rest_service/dto/get_dto/items_details_action_dto.dart';
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
import 'package:pbl_collector/rest/rest_service/dto/response_dto/blob_dto.dart';
import 'package:pbl_collector/rest/rest_service/dto/response_dto/token_dto.dart';
import 'settings_service.dart';


import './../models/token.dart';
import './../models/rooms_list.dart';
import './../utils/config.dart';
import './../rest/rest_repozitory.dart';
import './../models/service_response.dart';
import './../controllers/main_controller.dart';
import './../enums/service_errors.dart';

class Service{
  final Logger logger = Logger();
  Locale _locale = const Locale("en");
  late final Config config;
  late final RestRepository restRepository;
  late final MainController controller;

  Locale get locale => _locale;

  Future<void> loadLocale() async {
    _locale = await SettingsService.loadLocale();
  }

  Future<void> changeLocale(Locale locale) async{
    _locale = locale;
    await  SettingsService.saveLocale(locale);
  }

  Future<void> init(MainController controller) async {
    logger.i("Initializing Service...");
    config = await loadConfig();
    logger.i("Config loaded");
    restRepository = RestRepository(config: config);
    logger.i("Rest repo");
    this.controller = controller;
    logger.i("Service initialized successfully.");
  }

  Future<ServiceResponse> login(String username, String password) async {
    try{
      var loginDto = LoginDTO(username: username, password: password);
      TokenDTO loginResponse = await restRepository.login(loginDto);
      controller.user.token = Token(access: loginResponse.access);
      controller.user.isLogged = true;
      logger.i(controller.user.token);
      return ServiceResponse(data: null, error: ServiceErrors.ok);
    } catch (e){
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.loginError);
    }
  }

  Future<void> logout() async{
    controller.user.isLogged = false;
    controller.user.token = null;
  }

  Future<ServiceResponse<UsersList>> getUsersList(int? departmentId, int? facultyId) async{
    try{
      final params = ListUsersParamsDto(facultyId: facultyId, departmentId: departmentId);
      UsersListDTO responseDTO = await restRepository.getListOfUsers(controller.user, params);
      return ServiceResponse(data: UsersList.fromDTO(responseDTO), error: ServiceErrors.ok);
    } catch (e){
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.apiError);

    }

  }

  Future<ServiceResponse<ItemDetails>> getItemDetailsWithQRCode(String itemQR) async{
      try{
        ItemDetailsDTO responseDTO = await restRepository.getItemDetailsWithQrCode(controller.user, itemQR);
        return ServiceResponse(data: ItemDetails.fromDTO(responseDTO), error: ServiceErrors.ok);
      } catch (e){
        logger.e(e.toString());
        return ServiceResponse(data: null, error: ServiceErrors.apiError);

      }
  }

  Future<ServiceResponse<ItemDetails>> getItemDetailsById(int itemId) async{
    try{
      ItemDetailsDTO responseDTO = await restRepository.getItemDetailsById(controller.user, itemId);
      return ServiceResponse(data: ItemDetails.fromDTO(responseDTO), error: ServiceErrors.ok);
    } catch (e){
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.apiError);

    }
  }

  Future<ServiceResponse<ItemsList>> getItems() async{
    try{
      ItemsListDTO responseDTO = await restRepository.getItems(controller.user);
      return ServiceResponse(data: ItemsList.fromDTO(responseDTO), error: ServiceErrors.ok);
    } catch (e){
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.apiError);

    }

  }

  Future<ServiceResponse<ItemsList>> getItemsInRoom(int roomId) async{
    try{
      ItemsListDTO responseDTO = await restRepository.getItemsInRoom(controller.user, roomId);
      return ServiceResponse(data: ItemsList.fromDTO(responseDTO), error: ServiceErrors.ok);
    } catch (e){
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.apiError);

    }

  }

  Future<ServiceResponse<ItemsList>> getItemsInLocation(int locationId) async{
    try{
      ItemsListDTO responseDTO = await restRepository.getItemsInLocation(controller.user, locationId);
      return ServiceResponse(data: ItemsList.fromDTO(responseDTO), error: ServiceErrors.ok);
    } catch (e){
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.apiError);

    }

  }


  Future<ServiceResponse<FacultyList>> getFaculties() async{
    try{
      FacultyListDTO responseDTO = await restRepository.getListOfFaculties(
          controller.user
      );
      return ServiceResponse(
          data: FacultyList.fromDTO(responseDTO),
          error: ServiceErrors.ok
      );
    } catch (e){
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.apiError);

    }

  }

  Future<ServiceResponse<DepartmentsList>> getDepartments(int facultyId) async{
    try{
       DepartmentListDto responseDTO = await restRepository.getListOfDepartments(
          controller.user, facultyId
      );
      return ServiceResponse(
          data: DepartmentsList.fromDTO(responseDTO),
          error: ServiceErrors.ok
      );
    } catch (e){
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.apiError);

    }

  }

  Future<ServiceResponse<RoomsList>> getRooms(int? departmentId) async{
    try{
      RoomsListDTO responseDTO = await restRepository.getListOfRooms(
          controller.user, departmentId
      );
      return ServiceResponse(
          data: RoomsList.fromDTO(responseDTO),
          error: ServiceErrors.ok
      );
    } catch (e){
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.apiError);

    }

  }

  Future<ServiceResponse<LocationsList>> getLocations(int roomId) async {
    try {
      LocationsListDTO responseDTO = await restRepository.getListOfLocations(
          controller.user, roomId
      );
      return ServiceResponse(
          data: LocationsList.fromDTO(responseDTO),
          error: ServiceErrors.ok
      );
    } catch (e) {
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.apiError);
    }
  }

  Future<ServiceResponse<Room>> addRoom(int roomNumber, int departmentId) async {
    try {
      AddRoomDTO params = AddRoomDTO(roomNumber: roomNumber, departmentId: departmentId);
      RoomDTO responseDTO = await restRepository.addRoom(
          controller.user, params
      );
      return ServiceResponse(
          data: Room.fromDTO(responseDTO),
          error: ServiceErrors.ok
      );
    } catch (e) {
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.apiError);
    }
  }


  Future<ServiceResponse<Location>> addLocation(int roomNumber, String description) async {
    try {
      AddLocationDto params = AddLocationDto(roomId: roomNumber, description: description);
      LocationDTO responseDTO = await restRepository.addLocation(
          controller.user, params
      );
      return ServiceResponse(
          data: Location.fromDTO(responseDTO),
          error: ServiceErrors.ok
      );
    } catch (e) {
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.apiError);
    }
  }

  // Future<ServiceResponse<BlobsList>> getLabel(int id, LabelType labelType) async {
  //   try {
  //     ItemLabelDto params = ItemLabelDto(id: id, labelType: labelType);
  //     BlobListDto responseDTO = await restRepository.printLabels(
  //         controller.user, params
  //     );
  //     return ServiceResponse(
  //         data: BlobsList.fromDTO(responseDTO),
  //         error: ServiceErrors.ok
  //     );
  //   } catch (e) {
  //     logger.e(e.toString());
  //     return ServiceResponse(data: null, error: ServiceErrors.apiError);
  //   }
  // }

  Future<ServiceResponse<ItemLabel>> getItemQrCode(int id, QrCodeType type) async {
    try {
      ItemQRCodeDto responseDTO = await restRepository.getItemQrCode(
          controller.user, id, type.name
      );
      return ServiceResponse(
          data: ItemLabel.fromDTO(responseDTO), error: ServiceErrors.ok
      );
    } catch (e) {
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.apiError);
    }
  }

  Future<ServiceResponse<ItemDetailsAction>> assignItem(int itemId, int userId) async {
    try {
      AssignToUserDto params = AssignToUserDto(itemId: itemId, userId: userId);
      ItemsDetailsActionDto responseDTO = await restRepository.assignItem(
    controller.user, params
    );
    return ServiceResponse(
      data: ItemDetailsAction.fromDTO(responseDTO),
      error: ServiceErrors.ok
    );
    } catch (e) {
    logger.e(e.toString());
    return ServiceResponse(data: null, error: ServiceErrors.apiError);
    }
  }

  Future<ServiceResponse<ItemDetailsAction>> returnItem(int itemId) async {
    try {
      GeneralItemIDDTO params = GeneralItemIDDTO(itemId: itemId);
      ItemsDetailsActionDto responseDTO = await restRepository.returnItem(
          controller.user, params
      );
      return ServiceResponse(
          data: ItemDetailsAction.fromDTO(responseDTO),
          error: ServiceErrors.ok
      );
    } catch (e) {
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.apiError);
    }
  }

  Future<ServiceResponse<ItemDetailsAction>> changeLocation(int itemId, int locationId) async {
    try {
      ChangeItemLocationDto params = ChangeItemLocationDto(itemId: itemId, locationId: locationId);
      ItemsDetailsActionDto responseDTO = await restRepository.changeItemLocation(
          controller.user, params
      );
      return ServiceResponse(
          data: ItemDetailsAction.fromDTO(responseDTO),
          error: ServiceErrors.ok
      );
    } catch (e) {
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.apiError);
    }
  }

  Future<ServiceResponse<ItemDetailsAction>> disposeItem(int itemId) async {
    try {
      GeneralItemIDDTO params = GeneralItemIDDTO(itemId: itemId);
      ItemsDetailsActionDto responseDTO = await restRepository.disposeItem(
          controller.user, params
      );
      return ServiceResponse(
          data: ItemDetailsAction.fromDTO(responseDTO),
          error: ServiceErrors.ok
      );
    } catch (e) {
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.apiError);
    }
  }

  Future<ServiceResponse<ItemDetailsAction>> markLow(int itemId) async {
    try {
      GeneralItemIDDTO params = GeneralItemIDDTO(itemId: itemId);
      ItemsDetailsActionDto responseDTO = await restRepository.markLowItem(
          controller.user, params
      );
      return ServiceResponse(
          data: ItemDetailsAction.fromDTO(responseDTO),
          error: ServiceErrors.ok
      );
    } catch (e) {
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.apiError);
    }
  }

  Future<ServiceResponse<ItemDetailsAction>> markMissing(int itemId) async {
    try {
      GeneralItemIDDTO params = GeneralItemIDDTO(itemId: itemId);
      ItemsDetailsActionDto responseDTO = await restRepository.markMissingItem(
          controller.user, params
      );
      return ServiceResponse(
          data: ItemDetailsAction.fromDTO(responseDTO),
          error: ServiceErrors.ok
      );
    } catch (e) {
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.apiError);
    }
  }

  Future<ServiceResponse<ItemDetailsAction>> markEmpty(int itemId) async {
    try {
      GeneralItemIDDTO params = GeneralItemIDDTO(itemId: itemId);
      ItemsDetailsActionDto responseDTO = await restRepository.markEmptyItem(
          controller.user, params
      );
      return ServiceResponse(
          data: ItemDetailsAction.fromDTO(responseDTO),
          error: ServiceErrors.ok
      );
    } catch (e) {
      logger.e(e.toString());
      return ServiceResponse(data: null, error: ServiceErrors.apiError);
    }
  }

}
