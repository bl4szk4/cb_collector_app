import './../enums/service_errors.dart';

class ServiceResponse <T>{
  T? data;
  ServiceErrors error;

  ServiceResponse({required this.data, required this.error});
}