import 'package:get_it/get_it.dart';
import 'package:validator/domain/entities/ticket/ticket_summary.dart';
import 'package:validator/domain/entities/validation_data.dart';
import 'package:validator/domain/services/ticket_status_history_service_interface.dart';
import '../../config_test.dart';
import 'package:validator/domain/entities/event.dart';
import 'package:validator/domain/entities/order.dart';
import 'package:validator/domain/entities/organization.dart';
import 'package:validator/domain/entities/ticket/create_ticket.dart';
import 'package:validator/domain/services/event_service_interface.dart';
import 'package:validator/domain/services/organization_service_interface.dart';
import 'package:validator/domain/services/ticket_service_interface.dart';

class TicketStatusHistoryServiceConfigTest extends ConfigTest {
  late ITicketStatusHistoryService _ticketStatusHistoryService;
  late ITicketService _ticketService;
  late IOrganizationService _organizationService;
  late IEventService _eventService;
  late final int _mockTicketId;

  int get mockTicketId => _mockTicketId;

  Future<ITicketStatusHistoryService> setUpDatabase() async {
    await super.setUpBaseDatabase();

    _ticketStatusHistoryService = GetIt.instance<ITicketStatusHistoryService>();
    _ticketService = GetIt.instance<ITicketService>();
    _organizationService = GetIt.instance<IOrganizationService>();
    _eventService = GetIt.instance<IEventService>();

    const mockOrganization = Organization(name: 'test organization');
    Organization organization = await _organizationService.createOrganization(mockOrganization);

    final mockEvent = Event(title: 'test', date: DateTime.now().toString(), time: '23:00', venue: 'test', organizationId: organization.id);
    Event event = await _eventService.createEvent(mockEvent);

    final mockTicket = CreateTicket(price: 10.0, eventId: event.id!, limit: 1);
    TicketSummary tickets = await _ticketService.createTickets(mockTicket);
    _mockTicketId = tickets.tickets.first.id!;

    final mockOrder = Order(eventId: event.id!, quantity: 1);
    TicketSummary buyTickets = await _ticketService.buyTickets(mockOrder);

    await _ticketService.cancelTicket(buyTickets.tickets.first.id!);

    return _ticketStatusHistoryService;
  }

  Future<void> cleanUpDatabase() async {
    await super.cleanUpBaseDatabase();
    await _eventService.deleteAllEvents();
    await _organizationService.deleteOrganizations();
  }
}
