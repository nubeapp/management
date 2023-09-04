import 'package:validator/config/app_config.dart';

abstract class PublicEndpoints {
  static List<String> endpoints = [
    'http://$LOCALHOST:8000/',
    'http://$LOCALHOST:8000/login',
    'http://$LOCALHOST:8000/users',
  ];
}
