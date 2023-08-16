import 'package:validator/domain/entities/ticket/ticket.dart';

class TicketNavigation {
  final bool cancel;
  final Ticket? ticket;

  TicketNavigation({required this.cancel, this.ticket});
}
