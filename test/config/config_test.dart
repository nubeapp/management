import 'package:validator/domain/entities/credentials.dart';
import 'package:validator/domain/entities/organization.dart';
import 'package:validator/domain/entities/token.dart';
import 'package:validator/domain/entities/user.dart';
import 'package:validator/infrastructure/services/auth_service.dart';
import 'package:validator/infrastructure/services/user_service.dart';
import 'package:http/http.dart' as http;

import '../services/dependency_injection/dependencies_test.dart';

class ConfigTest {
  late AuthService _authService;
  late UserService _userService;
  late http.Client _httpClient;
  final _mockUser = const User(email: 'test@test.com', name: 'test', surname: 'test', password: 'testpassword');
  final _mockCredentials = const Credentials(username: 'test@test.com', password: 'testpassword');

  Future<void> setUpBaseDatabase() async {
    _httpClient = http.Client();
    _userService = UserService(client: _httpClient);
    _authService = AuthService(client: _httpClient);

    await _userService.createUser(_mockUser);

    Token token = await _authService.login(_mockCredentials);
    DependenciesTest.injectDependencies(token);
  }

  Future<void> cleanUpBaseDatabase() async {
    await _userService.deleteUsers();
    _httpClient.close();
  }
}
