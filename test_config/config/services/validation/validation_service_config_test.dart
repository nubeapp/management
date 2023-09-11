import 'package:get_it/get_it.dart';
import 'package:validator/domain/services/validation_service_interface.dart';
import '../../config_test.dart';
import 'package:validator/domain/entities/event.dart';
import 'package:validator/domain/entities/order.dart';
import 'package:validator/domain/entities/organization.dart';
import 'package:validator/domain/entities/ticket/create_ticket.dart';
import 'package:validator/domain/services/event_service_interface.dart';
import 'package:validator/domain/services/organization_service_interface.dart';
import 'package:validator/domain/services/ticket_service_interface.dart';

class ValidationServiceConfigTest extends ConfigTest {
  late IValidationService _validationService;
  late ITicketService _ticketService;
  late IOrganizationService _organizationService;
  late IEventService _eventService;
  late final int _mockEventId;
  late final String _mockReference;

  int get mockEventId => _mockEventId;
  String get mockReference => _mockReference;

  Future<IValidationService> setUpDatabase() async {
    await super.setUpBaseDatabase();

    _validationService = GetIt.instance<IValidationService>();
    _ticketService = GetIt.instance<ITicketService>();
    _organizationService = GetIt.instance<IOrganizationService>();
    _eventService = GetIt.instance<IEventService>();

    const mockOrganization = Organization(name: 'test organization');
    Organization organization = await _organizationService.createOrganization(mockOrganization);

    final mockEvent = Event(title: 'test', date: DateTime.now().toString(), time: '23:00', venue: 'test', organizationId: organization.id);
    Event event = await _eventService.createEvent(mockEvent);
    _mockEventId = event.id!;

    final mockTicket = CreateTicket(price: 10.0, eventId: event.id!, limit: 1);
    await _ticketService.createTickets(mockTicket);

    final mockOrder = Order(eventId: event.id!, quantity: 1);
    final ticketsSummary = await _ticketService.buyTickets(mockOrder);
    _mockReference = ticketsSummary.tickets.first.reference;

    return _validationService;
  }

  Future<void> cleanUpDatabase() async {
    await super.cleanUpBaseDatabase();
    await _eventService.deleteAllEvents();
    await _organizationService.deleteOrganizations();
  }
}
