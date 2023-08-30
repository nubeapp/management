import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:validator/config/app_config.dart';
import 'package:validator/domain/services/validation_service_interface.dart';
import 'package:http/http.dart' as http;
import 'package:validator/infrastructure/services/validation_service.dart';

import '../../../mocks/mock_objects.dart';
import 'validation_service_unit_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late IValidationService validationService;
  const String API_BASE_URL = 'http://$LOCALHOST:8000/validation';

  group('ValidationService', () {
    group('validateTicket', () {
      test('validates a ticket', () async {
        final mockClient = MockClient();
        validationService = ValidationService(client: mockClient);

        when(mockClient.put(Uri.parse(API_BASE_URL),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: json.encode(mockValidationDataObject.toJson())))
            .thenAnswer((_) async => http.Response('[]', 200));

        await validationService.validateTicket(mockValidationDataObject, (boolValue) {}, (strValue) {});

        verify(mockClient.put(Uri.parse(API_BASE_URL),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: json.encode(mockValidationDataObject.toJson())))
            .called(1);
      });
    });
  });
}
