import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:validator/config/app_config.dart';
import 'package:validator/domain/entities/organization.dart';
import 'package:validator/domain/services/organization_service_interface.dart';
import 'package:validator/infrastructure/services/organization_service.dart';
import '../../../mocks/mock_objects.dart';
import '../../../mocks/mock_responses.dart';
import 'organization_service_unit_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late IOrganizationService organizationService;
  const String API_BASE_URL = 'http://$LOCALHOST:8000/organizations';

  group('OrganizationService', () {
    group('getOrganizations', () {
      test('returns a list of organizations', () async {
        final mockClient = MockClient();
        organizationService = OrganizationService(client: mockClient);

        when(mockClient.get(Uri.parse(API_BASE_URL))).thenAnswer((_) async => http.Response(json.encode(mockOrganizationListResponse), 200));

        final organizations = await organizationService.getOrganizations();

        expect(organizations, isA<List<Organization>>());
        expect(organizations.length, equals(3));
        expect(organizations[0].id, equals(1));
        expect(organizations[1].id, equals(2));
        expect(organizations[2].id, equals(3));
        expect(organizations[0].name, 'UNIVERSAL MUSIC SPAIN');
        expect(organizations[1].name, 'WARNER BROS MUSIC');
        expect(organizations[2].name, 'SONY MUSIC ENTERTAINMENT');

        verify(mockClient.get(Uri.parse(API_BASE_URL))).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        organizationService = OrganizationService(client: mockClient);

        when(mockClient.get(Uri.parse(API_BASE_URL))).thenAnswer((_) async => http.Response('Not found', 404));

        expect(() async => await organizationService.getOrganizations(), throwsException);

        verify(mockClient.get(Uri.parse(API_BASE_URL))).called(1);
      });
    });

    group('getOrganizationsById', () {
      test('returns the specified organization', () async {
        final mockClient = MockClient();
        organizationService = OrganizationService(client: mockClient);
        int mockOrganizationId = 1;

        when(mockClient.get(Uri.parse('$API_BASE_URL/$mockOrganizationId'))).thenAnswer((_) async => http.Response(json.encode(mockOrganizationResponse), 200));

        final organization = await organizationService.getOrganizationById(mockOrganizationId);

        expect(organization, isA<Organization>());
        expect(organization.id, equals(1));
        expect(organization.name, 'UNIVERSAL MUSIC SPAIN');

        verify(mockClient.get(Uri.parse('$API_BASE_URL/$mockOrganizationId'))).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        organizationService = OrganizationService(client: mockClient);
        int mockOrganizationId = 1;

        when(mockClient.get(Uri.parse('$API_BASE_URL/$mockOrganizationId'))).thenAnswer((_) async => http.Response('Not found', 404));

        expect(() async => await organizationService.getOrganizationById(mockOrganizationId), throwsException);

        verify(mockClient.get(Uri.parse('$API_BASE_URL/$mockOrganizationId'))).called(1);
      });
    });

    group('createOrganization', () {
      test('creates an organization', () async {
        final mockClient = MockClient();
        organizationService = OrganizationService(client: mockClient);

        when(mockClient.post(Uri.parse(API_BASE_URL),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: json.encode(mockOrganizationObject.toJson())))
            .thenAnswer((_) async => http.Response(json.encode(mockOrganizationResponse), 201));

        final organization = await organizationService.createOrganization(mockOrganizationObject);

        expect(organization, isA<Organization>());
        expect(organization.id, equals(1));
        expect(organization.name, 'UNIVERSAL MUSIC SPAIN');

        verify(mockClient.post(Uri.parse(API_BASE_URL),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: json.encode(mockOrganizationObject.toJson())))
            .called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        organizationService = OrganizationService(client: mockClient);

        when(mockClient.post(Uri.parse(API_BASE_URL),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: json.encode(mockOrganizationObject.toJson())))
            .thenAnswer((_) async => http.Response('Not found', 404));

        expect(() async => await organizationService.createOrganization(mockOrganizationObject), throwsException);

        verify(mockClient.post(Uri.parse(API_BASE_URL),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: json.encode(mockOrganizationObject.toJson())))
            .called(1);
      });
    });

    group('deleteOrganizationById', () {
      test('is called once', () async {
        final mockClient = MockClient();
        organizationService = OrganizationService(client: mockClient);
        const int mockOrganizationId = 1;

        when(mockClient.delete(
          Uri.parse('$API_BASE_URL/$mockOrganizationId'),
        )).thenAnswer((_) async => http.Response('[]', 204));

        await organizationService.deleteOrganizationById(mockOrganizationId);

        verify(mockClient.delete(
          Uri.parse('$API_BASE_URL/$mockOrganizationId'),
        )).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        organizationService = OrganizationService(client: mockClient);
        const int mockOrganizationId = 1;

        when(mockClient.delete(
          Uri.parse('$API_BASE_URL/$mockOrganizationId'),
        )).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(() async => await organizationService.deleteOrganizationById(mockOrganizationId), throwsException);

        verify(mockClient.delete(
          Uri.parse('$API_BASE_URL/$mockOrganizationId'),
        )).called(1);
      });
    });

    group('deleteAllOrganizations', () {
      test('is called once', () async {
        final mockClient = MockClient();
        organizationService = OrganizationService(client: mockClient);

        when(mockClient.delete(
          Uri.parse(API_BASE_URL),
        )).thenAnswer((_) async => http.Response('[]', 204));

        await organizationService.deleteOrganizations();

        verify(mockClient.delete(
          Uri.parse(API_BASE_URL),
        )).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        organizationService = OrganizationService(client: mockClient);

        when(mockClient.delete(
          Uri.parse(API_BASE_URL),
        )).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(() async => await organizationService.deleteOrganizations(), throwsException);

        verify(mockClient.delete(
          Uri.parse(API_BASE_URL),
        )).called(1);
      });
    });
  });
}
