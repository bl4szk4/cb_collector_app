import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Config {
  final String pblServiceAddress;

  Config({required this.pblServiceAddress});

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(pblServiceAddress: json['pbl_service_address']);
  }
}

Future<Config> loadConfig() async {
  final configString = await rootBundle.loadString('assets/config/config.json');
  final configJson = json.decode(configString);
  return Config.fromJson(configJson);
}