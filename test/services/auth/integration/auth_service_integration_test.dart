import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:validator/domain/entities/credentials.dart';
import 'package:validator/domain/entities/token.dart';
import 'package:validator/domain/entities/user.dart';
import 'package:validator/infrastructure/services/auth_service.dart';
import 'package:validator/infrastructure/services/user_service.dart'; // Update with the correct import path

void main() {
  late AuthService authService;
  late UserService userService;
  late http.Client httpClient;
  const mockUser = User(email: 'test@test.com', name: 'test', surname: 'test', password: 'testpassword');

  group('AuthService Integration Test', () {
    setUpAll(() async {
      httpClient = http.Client();
      userService = UserService(client: httpClient);
      authService = AuthService(client: httpClient);

      await userService.createUser(mockUser);
    });

    tearDownAll(() async {
      await userService.deleteUsers();
      httpClient.close();
    });

    test('login returns a Token on successful login', () async {
      // Arrange
      const credentials = Credentials(username: 'test@test.com', password: 'testpassword');

      // Act
      final token = await authService.login(credentials);

      // Assert
      expect(token, isA<Token>());
    });

    test('login throws an exception on failed login', () async {
      // Arrange
      const credentials = Credentials(username: 'fail@fail.com', password: 'failpassword');

      // Act & Assert
      expect(() async => await authService.login(credentials), throwsA(isA<Exception>()));
    });
  });
}
