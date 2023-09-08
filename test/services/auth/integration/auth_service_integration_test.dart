import 'package:flutter_test/flutter_test.dart';
import 'package:validator/domain/entities/credentials.dart';
import 'package:validator/domain/entities/token.dart';
import 'package:validator/domain/services/auth_service_interface.dart';

import '../../../../test_config/config/services/auth/auth_service_config_test.dart'; // Update with the correct import path

void main() {
  AuthServiceConfigTest authConfig = AuthServiceConfigTest();

  group('AuthService Integration Test', () {
    late IAuthService authService;

    setUpAll(() async {
      authService = await authConfig.setUpDatabase();
    });

    tearDownAll(() async {
      await authConfig.cleanUpDatabase();
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
