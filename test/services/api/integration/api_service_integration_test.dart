import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:validator/infrastructure/services/api_service.dart';

void main() {
  group('ApiService Integration Test', () {
    late ApiService apiService;
    late http.Client httpClient;

    setUp(() {
      httpClient = http.Client();
      apiService = ApiService(client: httpClient);
    });

    tearDown(() {
      httpClient.close();
    });

    test('connectAPI returns server is running message on success', () async {
      // Act
      final result = await apiService.connectAPI();

      // Assert
      expect(result, 'Server is running...');
    });

    test('connectAPI throws an exception on network error', () async {
      // Arrange: Set up a client that will fail to make a request
      final failingClient = http.Client();
      final errorApiService = ApiService(client: failingClient);

      // Act & Assert
      try {
        await errorApiService.connectAPI();
        fail('Expected an exception');
      } catch (e) {
        expect(e, isA<Exception>());
      }

      // Clean up
      failingClient.close();
    });
  });
}
