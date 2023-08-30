import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:validator/domain/entities/credentials.dart';
import 'package:validator/domain/entities/token.dart';
import 'package:validator/infrastructure/services/auth_service.dart'; // Update with the correct import path

void main() {
  group('AuthService Integration Test', () {
    late AuthService authService;
    late http.Client httpClient;

    setUp(() {
      httpClient = http.Client();
      authService = AuthService(client: httpClient);
    });

    tearDown(() {
      httpClient.close();
    });

    test('login returns a Token on successful login', () async {
      // Arrange (this data should exists in database)
      const credentials = Credentials(username: 'alvarolopsi@gmail.com', password: 'alvarolopsi');

      // Act
      final token = await authService.login(credentials);

      // Assert
      expect(token, isA<Token>());
    });

    test('login throws an exception on failed login', () async {
      // Arrange
      const credentials = Credentials(username: 'invaliduser', password: 'invalidpassword');

      // Act & Assert
      expect(() async => await authService.login(credentials), throwsA(isA<Exception>()));
    });
  });
}
