import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:validator/domain/services/api_service_interface.dart';
import 'package:validator/infrastructure/services/api_service.dart';

import '../../../../test_config/config/services/api/api_service_config_test.dart';

void main() {
  ApiServiceConfigTest apiConfig = ApiServiceConfigTest();
  group('ApiService Integration Test', () {
    late IApiService apiService;

    setUpAll(() async {
      apiService = await apiConfig.setUpDatabase();
    });

    tearDownAll(() async {
      await apiConfig.cleanUpDatabase();
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
