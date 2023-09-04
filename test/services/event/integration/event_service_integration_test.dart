import 'package:flutter_test/flutter_test.dart';
import 'package:validator/domain/entities/event.dart';
import 'package:validator/domain/services/event_service_interface.dart';
import 'package:validator/infrastructure/utilities/helpers.dart';
import '../event_service_config_test.dart';

void main() {
  EventServiceConfigTest eventConfig = EventServiceConfigTest();
  late IEventService eventService;
  late int mockEventId;
  late int mockOrganizationId;

  setUpAll(() async {
    eventService = await eventConfig.setUpDatabase();
    mockEventId = eventConfig.mockEventId;
    mockOrganizationId = eventConfig.mockOrganizationId;
  });

  tearDownAll(() async {
    await eventConfig.cleanUpDatabase();
  });

  group('EventService Integration Tests', () {
    test('Get all events', () async {
      final events = await eventService.getEvents();
      expect(events, isA<List<Event>>());
      expect(events.length, equals(1));
      expect(events.first.title, 'test');
      expect(events.first.date, Helpers.convertToDDMMYYYY(DateTime.now().toString()));
      expect(events.first.time, '23:00');
      expect(events.first.venue, 'test');
    });

    test('Get event by Id', () async {
      final event = await eventService.getEventById(mockEventId);
      expect(event, isA<Event>());
      expect(event.title, 'test');
      expect(event.date, Helpers.convertToDDMMYYYY(DateTime.now().toString()));
      expect(event.time, '23:00');
      expect(event.venue, 'test');
    });

    test('Get favourite events by UserId', () async {
      final events = await eventService.getFavouriteEventsByUserId();
      expect(events, isA<List<Event>>());
      expect(events.length, equals(0));
    });

    test('Get events by OrganizationId', () async {
      List<Event> events = await eventService.getEventsByOrganizationId(mockOrganizationId);
      expect(events, isA<List<Event>>());
      expect(events.length, equals(1));
      expect(events.first.title, 'test');
      expect(events.first.date, Helpers.convertToDDMMYYYY(DateTime.now().toString()));
      expect(events.first.time, '23:00');
      expect(events.first.venue, 'test');
      expect(() async => await eventService.getEventsByOrganizationId(mockOrganizationId + 1), throwsException);
    });

    test('Create event', () async {
      final mockEvent = Event(title: 'test event', date: DateTime.now().toString(), time: '23:00', venue: 'test venue', organizationId: mockOrganizationId);
      final eventsBefore = await eventService.getEvents();
      Event newEvent = await eventService.createEvent(mockEvent);
      final eventsAfter = await eventService.getEvents();
      expect(eventsBefore.length + 1, eventsAfter.length);

      await eventService.deleteEventById(newEvent.id!);
    });

    test('Update event by Id', () async {
      Event mockUpdatedEvent = Event(title: 'update test', date: DateTime.now().toString(), time: '23:00', venue: 'test', organizationId: mockOrganizationId);
      final eventBefore = await eventService.getEventById(mockEventId);
      await eventService.updateEventById(mockEventId, mockUpdatedEvent);
      final eventAfter = await eventService.getEventById(mockEventId);
      expect(eventBefore.title, isNot(eventAfter.title));
    });

    test('Delete event by Id', () async {
      final mockEvent = Event(title: 'test', date: DateTime.now().toString(), time: '23:00', venue: 'test', organizationId: mockOrganizationId);
      Event event = await eventService.createEvent(mockEvent);
      final eventsBefore = await eventService.getEvents();
      await eventService.deleteEventById(event.id!);
      final eventsAfter = await eventService.getEvents();
      expect(eventsBefore.length - 1, eventsAfter.length);
    });

    test('Delete events by OrganizationId', () async {
      await eventService.deleteEventsByOrganizationId(mockOrganizationId);
      final events = await eventService.getEvents();
      expect(events.length, equals(0));
    });
  });
}
