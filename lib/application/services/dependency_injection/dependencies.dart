import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:validator/domain/services/api_service_interface.dart';
import 'package:validator/domain/services/auth_service_interface.dart';
import 'package:validator/domain/services/event_service_interface.dart';
import 'package:validator/domain/services/validation_service_interface.dart';
import 'package:validator/infrastructure/http/http_client.dart';
import 'package:validator/infrastructure/services/api_service.dart';
import 'package:validator/infrastructure/services/auth_service.dart';
import 'package:validator/infrastructure/services/event_service.dart';
import 'package:validator/infrastructure/services/validation_service.dart';

@immutable
abstract class Dependencies {
  static void injectDependencies() async {
    GetIt.instance.registerLazySingleton<http.Client>(() => HttpClientFactory.create());

    GetIt.instance.registerLazySingleton<IApiService>(
      () => ApiService(client: GetIt.instance<http.Client>()),
    );
    GetIt.instance.registerLazySingleton<IAuthService>(
      () => AuthService(client: GetIt.instance<http.Client>()),
    );
    GetIt.instance.registerLazySingleton<IEventService>(
      () => EventService(client: GetIt.instance<http.Client>()),
    );
    GetIt.instance.registerLazySingleton<IValidationService>(
      () => ValidationService(client: GetIt.instance<http.Client>()),
    );
  }
}
