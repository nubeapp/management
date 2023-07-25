import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:validator/domain/entities/event.dart';
import 'package:validator/domain/services/event_service_interface.dart';
import 'package:validator/infrastructure/services/event_service.dart';
import 'package:http/http.dart' as http;

import '../../../mocks/mock_objects.dart';
import '../../../mocks/mock_responses.dart';
import 'event_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late IEventService eventService;
  const String API_BASE_URL = 'http://192.168.1.73:8000/events';

  group('EventService', () {
    group('getEvents', () {
      test('returns a list of events', () async {
        final mockClient = MockClient();
        eventService = EventService(client: mockClient);

        when(mockClient.get(Uri.parse(API_BASE_URL))).thenAnswer((_) async => http.Response(json.encode(mockEventListResponse), 200));

        final events = await eventService.getEvents();

        expect(events, isA<List<Event>>());
        expect(events.length, equals(2));
        expect(events[0].id, equals(1));
        expect(events[1].id, equals(2));
        expect(events[0].title, 'Bad Bunny Concert');
        expect(events[1].title, 'Rosalia Concert');
        expect(events[0].date, CustomDateTime(2023, 12, 07));
        expect(events[1].date, CustomDateTime(2023, 12, 14));
        expect(events[0].time, '18:00');
        expect(events[1].time, '18:00');
        expect(events[0].venue, 'Wizink Center');
        expect(events[1].venue, 'Wizink Center');
        expect(events[0].organization!.id, equals(1));
        expect(events[1].organization!.id, equals(1));
        expect(events[0].organization!.name, 'UNIVERSAL MUSIC SPAIN');
        expect(events[1].organization!.name, 'UNIVERSAL MUSIC SPAIN');

        verify(mockClient.get(Uri.parse(API_BASE_URL))).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        eventService = EventService(client: mockClient);

        when(mockClient.get(Uri.parse(API_BASE_URL))).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(eventService.getEvents(), throwsException);

        verify(mockClient.get(Uri.parse(API_BASE_URL))).called(1);
      });
    });

    group('getEventById', () {
      test('returns an event', () async {
        final mockClient = MockClient();
        eventService = EventService(client: mockClient);
        const int mockId = 1;

        when(mockClient.get(Uri.parse('$API_BASE_URL/event/$mockId'))).thenAnswer((_) async => http.Response(json.encode(mockEventResponse), 200));

        final event = await eventService.getEventById(mockId);

        expect(event, isA<Event>());
        expect(event.id, equals(1));
        expect(event.title, 'Bad Bunny Concert');
        expect(event.date, CustomDateTime(2023, 12, 07));
        expect(event.time, '18:00');
        expect(event.venue, 'Wizink Center');
        expect(event.organization!.id, equals(1));
        expect(event.organization!.name, 'UNIVERSAL MUSIC SPAIN');

        verify(mockClient.get(Uri.parse('$API_BASE_URL/event/$mockId'))).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        eventService = EventService(client: mockClient);
        const int mockId = 1;

        when(mockClient.get(Uri.parse('$API_BASE_URL/event/$mockId'))).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(eventService.getEventById(mockId), throwsException);

        verify(mockClient.get(Uri.parse('$API_BASE_URL/event/$mockId'))).called(1);
      });
    });

    group('getFavouriteEventsByUserId', () {
      test('returns an event', () async {
        final mockClient = MockClient();
        eventService = EventService(client: mockClient);

        when(mockClient.get(Uri.parse('$API_BASE_URL/favourites'))).thenAnswer(
          (_) async => http.Response(json.encode(mockEventListResponse), 200),
        );

        final events = await eventService.getFavouriteEventsByUserId();

        expect(events, isA<List<Event>>());
        expect(events.length, equals(2));
        expect(events[0].id, equals(1));
        expect(events[1].id, equals(2));
        expect(events[0].title, 'Bad Bunny Concert');
        expect(events[1].title, 'Rosalia Concert');
        expect(events[0].date, CustomDateTime(2023, 12, 07));
        expect(events[1].date, CustomDateTime(2023, 12, 14));
        expect(events[0].time, '18:00');
        expect(events[1].time, '18:00');
        expect(events[0].venue, 'Wizink Center');
        expect(events[1].venue, 'Wizink Center');
        expect(events[0].organization!.id, equals(1));
        expect(events[1].organization!.id, equals(1));
        expect(events[0].organization!.name, 'UNIVERSAL MUSIC SPAIN');
        expect(events[1].organization!.name, 'UNIVERSAL MUSIC SPAIN');

        verify(mockClient.get(Uri.parse('$API_BASE_URL/favourites'))).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        eventService = EventService(client: mockClient);

        when(mockClient.get(Uri.parse('$API_BASE_URL/favourites'))).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(eventService.getFavouriteEventsByUserId(), throwsException);

        verify(mockClient.get(Uri.parse('$API_BASE_URL/favourites'))).called(1);
      });
    });

    group('getEventsByOrganizationId', () {
      test('returns a list of events by specified organization', () async {
        final mockClient = MockClient();
        eventService = EventService(client: mockClient);
        const int mockOrganizationId = 1;

        when(mockClient.get(Uri.parse('$API_BASE_URL/$mockOrganizationId'))).thenAnswer((_) async => http.Response(json.encode(mockEventListResponse), 200));

        final events = await eventService.getEventsByOrganizationId(mockOrganizationId);

        expect(events, isA<List<Event>>());
        expect(events.length, equals(2));
        expect(events[0].id, equals(1));
        expect(events[1].id, equals(2));
        expect(events[0].title, 'Bad Bunny Concert');
        expect(events[1].title, 'Rosalia Concert');
        expect(events[0].date, CustomDateTime(2023, 12, 07));
        expect(events[1].date, CustomDateTime(2023, 12, 14));
        expect(events[0].time, '18:00');
        expect(events[1].time, '18:00');
        expect(events[0].venue, 'Wizink Center');
        expect(events[1].venue, 'Wizink Center');
        expect(events[0].organization!.id, equals(1));
        expect(events[1].organization!.id, equals(1));
        expect(events[0].organization!.name, 'UNIVERSAL MUSIC SPAIN');
        expect(events[1].organization!.name, 'UNIVERSAL MUSIC SPAIN');

        verify(mockClient.get(Uri.parse('$API_BASE_URL/$mockOrganizationId'))).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        eventService = EventService(client: mockClient);
        const int mockOrganizationId = 1;

        when(mockClient.get(Uri.parse('$API_BASE_URL/$mockOrganizationId'))).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(eventService.getEventsByOrganizationId(mockOrganizationId), throwsException);

        verify(mockClient.get(Uri.parse('$API_BASE_URL/$mockOrganizationId'))).called(1);
      });
    });

    group('createEvent', () {
      test('creates new event', () async {
        final mockClient = MockClient();
        eventService = EventService(client: mockClient);

        when(mockClient.post(Uri.parse(API_BASE_URL),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: json.encode(mockEventObject.toJson())))
            .thenAnswer((_) async => http.Response(json.encode(mockEventResponse), 201));

        final event = await eventService.createEvent(mockEventObject);

        expect(event, isA<Event>());
        expect(event.id, equals(1));
        expect(event.title, 'Bad Bunny Concert');
        expect(event.date, CustomDateTime(2023, 12, 07));
        expect(event.time, '18:00');
        expect(event.venue, 'Wizink Center');
        expect(event.organization!.id, equals(1));
        expect(event.organization!.name, 'UNIVERSAL MUSIC SPAIN');

        verify(mockClient.post(
          Uri.parse(API_BASE_URL),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(mockEventObject.toJson()),
        )).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        eventService = EventService(client: mockClient);

        when(mockClient.post(
          Uri.parse(API_BASE_URL),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(mockEventObject.toJson()),
        )).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(eventService.createEvent(mockEventObject), throwsException);

        verify(mockClient.post(
          Uri.parse(API_BASE_URL),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(mockEventObject.toJson()),
        )).called(1);
      });
    });

    group('updateEvent', () {
      test('updates an event', () async {
        final mockClient = MockClient();
        eventService = EventService(client: mockClient);
        const int mockId = 1;

        when(mockClient.put(Uri.parse('$API_BASE_URL/$mockId'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: json.encode(mockEventObject.toJson())))
            .thenAnswer((_) async => http.Response(json.encode(mockEventResponse), 200));

        final event = await eventService.updateEventById(mockId, mockEventObject);

        expect(event, isA<Event>());
        expect(event.id, equals(1));
        expect(event.title, 'Bad Bunny Concert');
        expect(event.date, CustomDateTime(2023, 12, 07));
        expect(event.time, '18:00');
        expect(event.venue, 'Wizink Center');
        expect(event.organization!.id, equals(1));
        expect(event.organization!.name, 'UNIVERSAL MUSIC SPAIN');

        verify(mockClient.put(
          Uri.parse('$API_BASE_URL/$mockId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(mockEventObject.toJson()),
        )).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        eventService = EventService(client: mockClient);
        const int mockId = 1;

        when(mockClient.put(Uri.parse('$API_BASE_URL/$mockId'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: json.encode(mockEventObject.toJson())))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        expect(eventService.updateEventById(mockId, mockEventObject), throwsException);

        verify(mockClient.put(
          Uri.parse('$API_BASE_URL/$mockId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(mockEventObject.toJson()),
        )).called(1);
      });
    });

    group('deleteEventById', () {
      test('is called once', () async {
        final mockClient = MockClient();
        eventService = EventService(client: mockClient);
        const int mockId = 1;

        when(mockClient.delete(
          Uri.parse('$API_BASE_URL/event/$mockId'),
        )).thenAnswer((_) async => http.Response('[]', 204));

        await eventService.deleteEventById(mockId);

        verify(mockClient.delete(
          Uri.parse('$API_BASE_URL/event/$mockId'),
        )).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        eventService = EventService(client: mockClient);
        const int mockId = 1;

        when(mockClient.delete(
          Uri.parse('$API_BASE_URL/event/$mockId'),
        )).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(eventService.deleteEventById(mockId), throwsException);

        verify(mockClient.delete(
          Uri.parse('$API_BASE_URL/event/$mockId'),
        )).called(1);
      });
    });

    group('deleteEventByOrganizationId', () {
      test('is called once', () async {
        final mockClient = MockClient();
        eventService = EventService(client: mockClient);
        const int mockOrganizationId = 1;

        when(mockClient.delete(
          Uri.parse('$API_BASE_URL/$mockOrganizationId'),
        )).thenAnswer((_) async => http.Response('[]', 204));

        await eventService.deleteEventsByOrganizationId(mockOrganizationId);

        verify(mockClient.delete(
          Uri.parse('$API_BASE_URL/$mockOrganizationId'),
        )).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        eventService = EventService(client: mockClient);
        const int mockOrganizationId = 1;

        when(mockClient.delete(
          Uri.parse('$API_BASE_URL/$mockOrganizationId'),
        )).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(eventService.deleteEventsByOrganizationId(mockOrganizationId), throwsException);

        verify(mockClient.delete(
          Uri.parse('$API_BASE_URL/$mockOrganizationId'),
        )).called(1);
      });
    });

    group('deleteAllEvents', () {
      test('is called once', () async {
        final mockClient = MockClient();
        eventService = EventService(client: mockClient);

        when(mockClient.delete(
          Uri.parse(API_BASE_URL),
        )).thenAnswer((_) async => http.Response('[]', 204));

        await eventService.deleteAllEvents();

        verify(mockClient.delete(
          Uri.parse(API_BASE_URL),
        )).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        eventService = EventService(client: mockClient);

        when(mockClient.delete(
          Uri.parse(API_BASE_URL),
        )).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(eventService.deleteAllEvents(), throwsException);

        verify(mockClient.delete(
          Uri.parse(API_BASE_URL),
        )).called(1);
      });
    });
  });
}
