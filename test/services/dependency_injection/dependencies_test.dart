import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:validator/domain/entities/token.dart';
import 'package:validator/domain/services/api_service_interface.dart';
import 'package:validator/domain/services/auth_service_interface.dart';
import 'package:validator/domain/services/event_service_interface.dart';
import 'package:validator/domain/services/organization_service_interface.dart';
import 'package:validator/domain/services/ticket_service_interface.dart';
import 'package:validator/domain/services/ticket_status_history_service_interface.dart';
import 'package:validator/domain/services/user_service_interface.dart';
import 'package:validator/domain/services/validation_service_interface.dart';
import 'package:validator/infrastructure/services/api_service.dart';
import 'package:validator/infrastructure/services/auth_service.dart';
import 'package:validator/infrastructure/services/event_service.dart';
import 'package:validator/infrastructure/services/organization_service.dart';
import 'package:validator/infrastructure/services/ticket_service.dart';
import 'package:validator/infrastructure/services/ticket_status_history_service.dart';
import 'package:validator/infrastructure/services/user_service.dart';
import 'package:validator/infrastructure/services/validation_service.dart';

import '../../http/http_client_test.dart';

@immutable
abstract class DependenciesTest {
  static void injectDependencies(Token token) {
    GetIt.instance.registerLazySingleton<http.Client>(() => HttpClientFactoryTest.create(token));

    GetIt.instance.registerLazySingleton<IApiService>(
      () => ApiService(client: GetIt.instance<http.Client>()),
    );
    GetIt.instance.registerLazySingleton<IAuthService>(
      () => AuthService(client: GetIt.instance<http.Client>()),
    );
    GetIt.instance.registerLazySingleton<IUserService>(
      () => UserService(client: GetIt.instance<http.Client>()),
    );
    GetIt.instance.registerLazySingleton<IEventService>(
      () => EventService(client: GetIt.instance<http.Client>()),
    );
    GetIt.instance.registerLazySingleton<ITicketService>(
      () => TicketService(client: GetIt.instance<http.Client>()),
    );
    GetIt.instance.registerLazySingleton<IOrganizationService>(
      () => OrganizationService(client: GetIt.instance<http.Client>()),
    );
    GetIt.instance.registerLazySingleton<IValidationService>(
      () => ValidationService(client: GetIt.instance<http.Client>()),
    );
    GetIt.instance.registerLazySingleton<ITicketStatusHistoryService>(
      () => TicketStatusHistoryService(client: GetIt.instance<http.Client>()),
    );
  }
}
