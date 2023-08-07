import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:validator/infrastructure/services/api_service.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('ApiService', () {
    // Declare variables
    late ApiService apiService;
    const String API_BASE_URL = 'http://192.168.1.73:8000/';

    group('connectAPI', () {
      test('returns "Server is running..."', () async {
        final mockClient = MockClient();
        apiService = ApiService(client: mockClient);

        when(mockClient.get(Uri.parse(API_BASE_URL))).thenAnswer((_) async => http.Response('Server is running...', 200));

        String status = await apiService.connectAPI();

        expect(status, 'Server is running...');

        verify(mockClient.get(Uri.parse(API_BASE_URL))).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        apiService = ApiService(client: mockClient);

        when(mockClient.get(Uri.parse(API_BASE_URL))).thenAnswer((_) async => http.Response('Internal Server Error', 500));

        expect(apiService.connectAPI(), throwsException);

        verify(mockClient.get(Uri.parse(API_BASE_URL))).called(1);
      });
    });
  });
}
