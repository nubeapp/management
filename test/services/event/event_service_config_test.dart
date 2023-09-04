import 'package:get_it/get_it.dart';
import 'package:validator/domain/entities/event.dart';
import 'package:validator/domain/entities/organization.dart';
import 'package:validator/domain/services/event_service_interface.dart';
import 'package:validator/domain/services/organization_service_interface.dart';

import '../../config/config_test.dart';

class EventServiceConfigTest extends ConfigTest {
  late IEventService _eventService;
  late IOrganizationService _organizationService;
  late final int _mockEventId;
  late final int _mockOrganizationId;

  int get mockEventId => _mockEventId;
  int get mockOrganizationId => _mockOrganizationId;

  Future<IEventService> setUpDatabase() async {
    await super.setUpBaseDatabase();
    _eventService = GetIt.instance<IEventService>();
    _organizationService = GetIt.instance<IOrganizationService>();

    const mockOrganization = Organization(name: 'test organization');

    await _organizationService.createOrganization(mockOrganization);
    _mockOrganizationId = (await _organizationService.getOrganizations()).first.id!;

    final mockEvent = Event(title: 'test', date: DateTime.now().toString(), time: '23:00', venue: 'test', organizationId: _mockOrganizationId);
    _mockEventId = (await _eventService.createEvent(mockEvent)).id!;

    return _eventService;
  }

  Future<void> cleanUpDatabase() async {
    await super.cleanUpBaseDatabase();
    await _eventService.deleteAllEvents();
    await _organizationService.deleteOrganizations();
  }
}
