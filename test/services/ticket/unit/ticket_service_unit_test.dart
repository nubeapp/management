import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:validator/config/app_config.dart';
import 'package:validator/domain/entities/ticket/ticket.dart';
import 'package:validator/domain/entities/ticket/ticket_status.dart';
import 'package:validator/domain/entities/ticket/ticket_summary.dart';
import 'package:validator/domain/services/ticket_service_interface.dart';
import 'package:validator/infrastructure/services/ticket_service.dart';

import '../../../mocks/mock_objects.dart';
import '../../../mocks/mock_responses.dart';
import 'ticket_service_unit_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ITicketService ticketService;
  const String API_BASE_URL = 'http://$LOCALHOST:8000/tickets';

  group('TicketService', () {
    group('getTicketsByUserIdEventId', () {
      test('return list of tickets for the user for the event', () async {
        final mockClient = MockClient();
        ticketService = TicketService(client: mockClient);
        int mockEventId = 1;

        when(mockClient.get(Uri.parse('$API_BASE_URL/events/$mockEventId'))).thenAnswer(
          (_) async => http.Response(json.encode(mockTicketSummaryResponse), 200),
        );

        final ticketSummary = await ticketService.getTicketsByUserIdEventId(mockEventId);
        List<Ticket> tickets = ticketSummary.tickets;

        expect(ticketSummary, isA<TicketSummary>());
        expect(tickets, isA<List<Ticket>>());
        expect(tickets.length, equals(2));
        expect(tickets[0].id, equals(1));
        expect(tickets[1].id, equals(2));
        expect(tickets[0].price, equals(10.0));
        expect(tickets[1].price, equals(10.0));
        expect(tickets[0].reference, "2IR6ZOULKL2HOARDUI19");
        expect(tickets[1].reference, "ZT1HT93LEGSVCIEEGAIJ");
        expect(tickets[0].status, TicketStatus.SOLD);
        expect(tickets[1].status, TicketStatus.SOLD);
        expect(ticketSummary.event.id, equals(1));
        expect(ticketSummary.event.title, "Bad Bunny Concert");
        expect(ticketSummary.event.date, '07-12-2023');
        expect(ticketSummary.event.time, '18:00');
        expect(ticketSummary.event.venue, 'Wizink Center');
        expect(ticketSummary.event.organization!.id, equals(1));
        expect(ticketSummary.event.organization!.name, "UNIVERSAL MUSIC SPAIN");

        verify(mockClient.get(Uri.parse('$API_BASE_URL/events/$mockEventId'))).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        ticketService = TicketService(client: mockClient);
        int mockEventId = 1;

        when(mockClient.get(Uri.parse('$API_BASE_URL/events/$mockEventId'))).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(ticketService.getTicketsByUserIdEventId(mockEventId), throwsException);

        verify(mockClient.get(Uri.parse('$API_BASE_URL/events/$mockEventId'))).called(1);
      });
    });

    group('getTicketsByUserId', () {
      test('returns list of tickets for the user', () async {
        final mockClient = MockClient();
        ticketService = TicketService(client: mockClient);
        const ticketLimitMock = 5;
        const ticketOffsetMock = 0;

        when(mockClient.get(Uri.parse('$API_BASE_URL?limit=$ticketLimitMock&offset=$ticketOffsetMock'))).thenAnswer(
          (_) async => http.Response(json.encode(mockTicketSummaryListResponse), 200),
        );

        final ticketSummary = await ticketService.getTicketsByUserId(ticketLimitMock, ticketOffsetMock);

        expect(ticketSummary, isA<List<TicketSummary>>());
        expect(ticketSummary.length, equals(2));
        expect(ticketSummary[0].tickets, isA<List<Ticket>>());
        expect(ticketSummary[0].tickets.length, equals(2));
        expect(ticketSummary[0].event.id, equals(1));
        expect(ticketSummary[0].event.title, 'Bad Bunny Concert');
        expect(ticketSummary[0].event.date, '07-12-2023');
        expect(ticketSummary[0].event.time, '18:00');
        expect(ticketSummary[0].event.venue, 'Wizink Center');
        expect(ticketSummary[0].event.organization!.id, equals(1));
        expect(ticketSummary[0].event.organization!.name, 'UNIVERSAL MUSIC SPAIN');
        expect(ticketSummary[0].tickets[0].id, equals(1));
        expect(ticketSummary[0].tickets[1].id, equals(2));
        expect(ticketSummary[0].tickets[0].price, equals(10.0));
        expect(ticketSummary[0].tickets[1].price, equals(10.0));
        expect(ticketSummary[0].tickets[0].reference, '2IR6ZOULKL2HOARDUI19');
        expect(ticketSummary[0].tickets[1].reference, 'ZT1HT93LEGSVCIEEGAIJ');
        expect(ticketSummary[0].tickets[0].status, TicketStatus.SOLD);
        expect(ticketSummary[0].tickets[1].status, TicketStatus.SOLD);
        expect(ticketSummary[1].tickets, isA<List<Ticket>>());
        expect(ticketSummary[1].tickets.length, equals(2));
        expect(ticketSummary[1].event.id, equals(2));
        expect(ticketSummary[1].event.title, 'Rosalia Concert');
        expect(ticketSummary[1].event.date, '14-12-2023');
        expect(ticketSummary[1].event.time, '18:00');
        expect(ticketSummary[1].event.venue, 'Wizink Center');
        expect(ticketSummary[1].event.organization!.id, equals(1));
        expect(ticketSummary[1].event.organization!.name, 'UNIVERSAL MUSIC SPAIN');
        expect(ticketSummary[1].tickets[0].id, equals(3));
        expect(ticketSummary[1].tickets[1].id, equals(4));
        expect(ticketSummary[1].tickets[0].price, equals(20.0));
        expect(ticketSummary[1].tickets[1].price, equals(20.0));
        expect(ticketSummary[1].tickets[0].reference, '4JUAEAWPB1S6KSSWPN80');
        expect(ticketSummary[1].tickets[1].reference, 'Y3OPY34TJ9FH78UV4BXG');
        expect(ticketSummary[1].tickets[0].status, TicketStatus.SOLD);
        expect(ticketSummary[1].tickets[1].status, TicketStatus.SOLD);

        verify(mockClient.get(Uri.parse('$API_BASE_URL?limit=$ticketLimitMock&offset=$ticketOffsetMock'))).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        ticketService = TicketService(client: mockClient);
        const ticketLimitMock = 5;
        const ticketOffsetMock = 5;

        when(mockClient.get(Uri.parse('$API_BASE_URL?limit=$ticketLimitMock&offset=$ticketOffsetMock')))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        expect(ticketService.getTicketsByUserId(ticketLimitMock, ticketOffsetMock), throwsException);

        verify(mockClient.get(Uri.parse('$API_BASE_URL?limit=$ticketLimitMock&offset=$ticketOffsetMock'))).called(1);
      });
    });

    group('getTicketsByEventId', () {
      test('return list of tickets for the event', () async {
        final mockClient = MockClient();
        ticketService = TicketService(client: mockClient);
        int mockEventId = 1;
        int limit = 2;
        int offset = 0;

        when(mockClient.get(Uri.parse('$API_BASE_URL/$mockEventId'))).thenAnswer(
          (_) async => http.Response(json.encode(mockTicketSummaryResponse), 200),
        );

        final ticketSummary = await ticketService.getTicketsByEventId(eventId: mockEventId, limit: limit, offset: offset);
        List<Ticket> tickets = ticketSummary.tickets;

        expect(ticketSummary, isA<TicketSummary>());
        expect(tickets, isA<List<Ticket>>());
        expect(tickets.length, equals(2));
        expect(tickets[0].id, equals(1));
        expect(tickets[1].id, equals(2));
        expect(tickets[0].price, equals(10.0));
        expect(tickets[1].price, equals(10.0));
        expect(tickets[0].reference, "2IR6ZOULKL2HOARDUI19");
        expect(tickets[1].reference, "ZT1HT93LEGSVCIEEGAIJ");
        expect(tickets[0].status, TicketStatus.SOLD);
        expect(tickets[1].status, TicketStatus.SOLD);
        expect(ticketSummary.event.id, equals(1));
        expect(ticketSummary.event.title, "Bad Bunny Concert");
        expect(ticketSummary.event.date, '07-12-2023');
        expect(ticketSummary.event.time, '18:00');
        expect(ticketSummary.event.venue, 'Wizink Center');
        expect(ticketSummary.event.organization!.id, equals(1));
        expect(ticketSummary.event.organization!.name, "UNIVERSAL MUSIC SPAIN");

        verify(mockClient.get(Uri.parse('$API_BASE_URL/$mockEventId'))).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        ticketService = TicketService(client: mockClient);
        int mockEventId = 1;
        int limit = 2;
        int offset = 0;

        when(mockClient.get(Uri.parse('$API_BASE_URL/$mockEventId'))).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(ticketService.getTicketsByEventId(eventId: mockEventId, limit: limit, offset: offset), throwsException);

        verify(mockClient.get(Uri.parse('$API_BASE_URL/$mockEventId'))).called(1);
      });
    });

    group('createTickets', () {
      test('create a list of tickets', () async {
        final mockClient = MockClient();
        ticketService = TicketService(client: mockClient);

        when(mockClient.post(
          Uri.parse(API_BASE_URL),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(mockCreateTicketObject.toJson()),
        )).thenAnswer(
          (_) async => http.Response(json.encode(mockTicketSummaryResponse), 201),
        );

        final ticketSummary = await ticketService.createTickets(mockCreateTicketObject);
        List<Ticket> tickets = ticketSummary.tickets;

        expect(ticketSummary, isA<TicketSummary>());
        expect(tickets, isA<List<Ticket>>());
        expect(tickets.length, equals(2));
        expect(tickets[0].id, equals(1));
        expect(tickets[1].id, equals(2));
        expect(tickets[0].price, equals(10.0));
        expect(tickets[1].price, equals(10.0));
        expect(tickets[0].reference, "2IR6ZOULKL2HOARDUI19");
        expect(tickets[1].reference, "ZT1HT93LEGSVCIEEGAIJ");
        expect(tickets[0].status, TicketStatus.SOLD);
        expect(tickets[1].status, TicketStatus.SOLD);
        expect(ticketSummary.event.id, equals(1));
        expect(ticketSummary.event.title, "Bad Bunny Concert");
        expect(ticketSummary.event.date, '07-12-2023');
        expect(ticketSummary.event.time, '18:00');
        expect(ticketSummary.event.venue, 'Wizink Center');
        expect(ticketSummary.event.organization!.id, equals(1));
        expect(ticketSummary.event.organization!.name, "UNIVERSAL MUSIC SPAIN");

        verify(mockClient.post(Uri.parse(API_BASE_URL),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(mockCreateTicketObject.toJson())))
            .called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        ticketService = TicketService(client: mockClient);

        when(mockClient.post(
          Uri.parse(API_BASE_URL),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(mockCreateTicketObject.toJson()),
        )).thenAnswer(
          (_) async => http.Response('Not Found', 404),
        );

        expect(ticketService.createTickets(mockCreateTicketObject), throwsException);

        verify(mockClient.post(Uri.parse(API_BASE_URL),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: jsonEncode(mockCreateTicketObject.toJson())))
            .called(1);
      });
    });

    group('buyTickets', () {
      test('returns the tickets bought', () async {
        final mockClient = MockClient();
        ticketService = TicketService(client: mockClient);

        when(mockClient.post(
          Uri.parse('$API_BASE_URL/buy'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(mockOrderObject.toJson()),
        )).thenAnswer((_) async => http.Response(json.encode(mockTicketSummaryResponse), 201));

        final ticketSummary = await ticketService.buyTickets(mockOrderObject);
        List<Ticket> tickets = ticketSummary.tickets;

        expect(ticketSummary, isA<TicketSummary>());
        expect(tickets, isA<List<Ticket>>());
        expect(tickets.length, equals(2));
        expect(tickets[0].id, equals(1));
        expect(tickets[1].id, equals(2));
        expect(tickets[0].price, equals(10.0));
        expect(tickets[1].price, equals(10.0));
        expect(tickets[0].reference, "2IR6ZOULKL2HOARDUI19");
        expect(tickets[1].reference, "ZT1HT93LEGSVCIEEGAIJ");
        expect(tickets[0].status, TicketStatus.SOLD);
        expect(tickets[1].status, TicketStatus.SOLD);
        expect(ticketSummary.event.id, equals(1));
        expect(ticketSummary.event.title, "Bad Bunny Concert");
        expect(ticketSummary.event.date, '07-12-2023');
        expect(ticketSummary.event.time, '18:00');
        expect(ticketSummary.event.venue, 'Wizink Center');
        expect(ticketSummary.event.organization!.id, equals(1));
        expect(ticketSummary.event.organization!.name, "UNIVERSAL MUSIC SPAIN");

        verify(mockClient.post(Uri.parse('$API_BASE_URL/buy'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: json.encode(mockOrderObject.toJson())))
            .called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        ticketService = TicketService(client: mockClient);

        when(mockClient.post(Uri.parse('$API_BASE_URL/buy'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: json.encode(mockOrderObject.toJson())))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        expect(ticketService.buyTickets(mockOrderObject), throwsException);

        verify(mockClient.post(Uri.parse('$API_BASE_URL/buy'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: json.encode(mockOrderObject.toJson())))
            .called(1);
      });
    });
  });
}
