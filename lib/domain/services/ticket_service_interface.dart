import 'package:validator/domain/entities/order.dart';
import 'package:validator/domain/entities/ticket/create_ticket.dart';

import '../entities/ticket/ticket_summary.dart';

abstract class ITicketService {
  Future<TicketSummary> getTicketsByUserIdEventId(int eventId);
  Future<TicketSummary> getTicketsAvailableByEventId(int eventId);
  Future<List<TicketSummary>> getTicketsByUserId(int limit, int offset);
  Future<TicketSummary> getTicketsByEventId(int eventId);
  Future<TicketSummary> createTickets(CreateTicket ticketData);
  Future<TicketSummary> buyTickets(Order order);
}
