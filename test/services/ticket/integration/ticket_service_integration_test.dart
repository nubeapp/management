import 'package:flutter_test/flutter_test.dart';
import 'package:validator/domain/entities/order.dart';
import 'package:validator/domain/entities/ticket/create_ticket.dart';
import 'package:validator/domain/entities/ticket/ticket.dart';
import 'package:validator/domain/entities/ticket/ticket_status.dart';
import 'package:validator/domain/entities/ticket/ticket_summary.dart';
import 'package:validator/domain/services/ticket_service_interface.dart';

import '../../../../test_config/config/services/ticket/ticket_service_config_test.dart';

void main() {
  TicketServiceConfigTest ticketConfig = TicketServiceConfigTest();
  late ITicketService ticketService;
  late int mockEventId;
  const int mockLimit = 100;
  const int mockOffset = 0;

  setUpAll(() async {
    ticketService = await ticketConfig.setUpDatabase();
    mockEventId = ticketConfig.mockEventId;
  });

  tearDownAll(() async {
    await ticketConfig.cleanUpDatabase();
  });

  group('TicketService Integration Tests', () {
    test('Get tickets by UserId and EventId', () async {
      final tickets = await ticketService.getTicketsByUserIdEventId(mockEventId);
      expect(tickets, isA<TicketSummary>());
      expect(tickets.tickets, isA<List<Ticket>>());
      expect(tickets.count, equals(1));
      expect(tickets.tickets.length, equals(1));
      expect(tickets.tickets.first.status, TicketStatus.SOLD);
    });

    test('Get tickets AVAILABLE by EventId', () async {
      final tickets = await ticketService.getTicketsAvailableByEventId(mockEventId);
      expect(tickets, isA<TicketSummary>());
      expect(tickets.tickets, isA<List<Ticket>>());
      expect(tickets.count, equals(1));
      expect(tickets.tickets.length, equals(1));
      expect(tickets.tickets.first.status, TicketStatus.AVAILABLE);
    });

    test('Get tickets by UserId', () async {
      final tickets = await ticketService.getTicketsByUserId(mockLimit, mockOffset);
      expect(tickets, isA<List<TicketSummary>>());
      expect(tickets.first, isA<TicketSummary>());
      expect(tickets.first.tickets, isA<List<Ticket>>());
      expect(tickets.first.count, equals(1));
      expect(tickets.first.tickets.length, equals(1));
      expect(tickets.first.tickets.first.status, TicketStatus.SOLD);
    });

    test('Get tickets by EventId', () async {
      final tickets = await ticketService.getTicketsByEventId(eventId: mockEventId, limit: mockLimit, offset: mockOffset);
      expect(tickets, isA<TicketSummary>());
      expect(tickets.tickets, isA<List<Ticket>>());
      expect(tickets.count, equals(2));
      expect(tickets.tickets.length, equals(2));
    });

    test('Create tickets', () async {
      final mockTickets = CreateTicket(eventId: mockEventId, price: 10.0, limit: 2);
      final ticketsBefore = await ticketService.getTicketsByEventId(eventId: mockEventId, limit: mockLimit, offset: mockOffset);
      TicketSummary tickets = await ticketService.createTickets(mockTickets);
      final ticketsAfter = await ticketService.getTicketsByEventId(eventId: mockEventId, limit: mockLimit, offset: mockOffset);
      expect(ticketsBefore.tickets.length + 2, ticketsAfter.tickets.length);

      for (var element in tickets.tickets) {
        await ticketService.deleteTicketById(element.id!);
      }
    });

    test('Buy tickets', () async {
      final mockOrder = Order(eventId: mockEventId, quantity: 1);
      final availableBefore = await ticketService.getTicketsAvailableByEventId(mockEventId);
      final userTicketsBefore = await ticketService.getTicketsByUserId(mockLimit, mockOffset);
      TicketSummary tickets = await ticketService.buyTickets(mockOrder);
      final availableAfter = await ticketService.getTicketsAvailableByEventId(mockEventId);
      final userTicketsAfter = await ticketService.getTicketsByUserId(mockLimit, mockOffset);

      expect(availableBefore.tickets.length, availableAfter.tickets.length + tickets.tickets.length);
      expect(userTicketsBefore.first.tickets.length + tickets.tickets.length, userTicketsAfter.first.tickets.length);

      for (var element in tickets.tickets) {
        await ticketService.deleteTicketById(element.id!);
      }
    });

    test('Cancel ticket', () async {
      final mockTickets = CreateTicket(eventId: mockEventId, price: 10.0, limit: 1);
      TicketSummary ticketsCreate = await ticketService.createTickets(mockTickets);
      await ticketService.cancelTicket(ticketsCreate.tickets.first.id!);
      TicketSummary tickets = await ticketService.getTicketsByEventId(eventId: mockEventId, limit: mockLimit, offset: mockOffset);
      expect(tickets.tickets.where((x) => x.id == ticketsCreate.tickets.first.id).first.status, TicketStatus.CANCELED);
    });

    test('Delete ticket by Id', () async {
      final mockTickets = CreateTicket(eventId: mockEventId, price: 10.0, limit: 1);
      TicketSummary ticketsCreate = await ticketService.createTickets(mockTickets);
      TicketSummary ticketsBefore = await ticketService.getTicketsByEventId(eventId: mockEventId, limit: mockLimit, offset: mockOffset);
      await ticketService.deleteTicketById(ticketsCreate.tickets.first.id!);
      TicketSummary ticketsAfter = await ticketService.getTicketsByEventId(eventId: mockEventId, limit: mockLimit, offset: mockOffset);

      expect(ticketsBefore.tickets.length, ticketsAfter.tickets.length + 1);
    });

    test('Delete tickets by EventId', () async {
      final mockTickets = CreateTicket(eventId: mockEventId, price: 10.0, limit: 1);
      await ticketService.createTickets(mockTickets);
      await ticketService.deleteTicketsByEventId(mockEventId);
      TicketSummary tickets = await ticketService.getTicketsByEventId(eventId: mockEventId, limit: mockLimit, offset: mockOffset);

      expect(tickets.tickets.length, equals(0));
    });
  });
}
