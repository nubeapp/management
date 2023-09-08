import 'package:flutter_test/flutter_test.dart';
import 'package:validator/domain/entities/organization.dart';
import 'package:validator/domain/services/organization_service_interface.dart';

import '../../../../test_config/config/services/organization/organization_service_config_test.dart';

void main() {
  OrganizationServiceConfigTest organizationConfig = OrganizationServiceConfigTest();
  late IOrganizationService organizationService;
  late int mockOrganizationId;

  setUpAll(() async {
    organizationService = await organizationConfig.setUpDatabase();
    mockOrganizationId = organizationConfig.mockOrganizationId;
  });

  tearDownAll(() async {
    await organizationConfig.cleanUpDatabase();
  });

  group('OrganizationService Integration Tests', () {
    test('Get all organizations', () async {
      final organizations = await organizationService.getOrganizations();
      expect(organizations, isA<List<Organization>>());
      expect(organizations.length, equals(1));
      expect(organizations.first.name, 'test organization');
    });

    test('Get organization by Id', () async {
      final organization = await organizationService.getOrganizationById(mockOrganizationId);
      expect(organization, isA<Organization>());
      expect(organization.name, 'test organization');
    });

    test('Create organization', () async {
      const mockOrganization = Organization(name: 'test create organization');
      final organizationsBefore = await organizationService.getOrganizations();
      Organization organization = await organizationService.createOrganization(mockOrganization);
      final organizationsAfter = await organizationService.getOrganizations();
      expect(organizationsBefore.length + 1, organizationsAfter.length);

      await organizationService.deleteOrganizationById(organization.id!);
    });

    // test('Update event by Id', () async {
    //   Event mockUpdatedEvent = Event(title: 'update test', date: DateTime.now().toString(), time: '23:00', venue: 'test', organizationId: mockOrganizationId);
    //   final eventBefore = await eventService.getEventById(mockEventId);
    //   await eventService.updateEventById(mockEventId, mockUpdatedEvent);
    //   final eventAfter = await eventService.getEventById(mockEventId);
    //   expect(eventBefore.title, isNot(eventAfter.title));
    // });

    test('Delete organization by Id', () async {
      const mockOrganization = Organization(name: 'test delete organization');
      Organization organization = await organizationService.createOrganization(mockOrganization);
      final organizationsBefore = await organizationService.getOrganizations();
      await organizationService.deleteOrganizationById(organization.id!);
      final organizationsAfter = await organizationService.getOrganizations();
      expect(organizationsBefore.length - 1, organizationsAfter.length);
    });

    test('Delete all organizations', () async {
      await organizationService.deleteOrganizations();
      final organizations = await organizationService.getOrganizations();
      expect(organizations.length, equals(0));
    });
  });
}
