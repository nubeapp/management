import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:validator/domain/entities/ticket/ticket_status.dart';
import 'package:validator/domain/entities/validation_data.dart';
import 'package:validator/domain/services/ticket_service_interface.dart';
import 'package:validator/domain/services/validation_service_interface.dart';
import '../../../../test_config/config/services/validation/validation_service_config_test.dart';

void main() {
  ValidationServiceConfigTest validationConfig = ValidationServiceConfigTest();
  late IValidationService validationService;
  late ITicketService ticketService;
  late int mockEventId;
  late String mockReference;

  setUpAll(() async {
    validationService = await validationConfig.setUpDatabase();
    ticketService = GetIt.instance<ITicketService>();
    mockEventId = validationConfig.mockEventId;
    mockReference = validationConfig.mockReference;
  });

  tearDownAll(() async {
    await validationConfig.cleanUpDatabase();
  });

  group('TicketService Integration Tests', () {
    test('Validate ticket', () async {
      final mockValidationData = ValidationData(eventId: mockEventId, reference: mockReference);
      final ticketsBefore = await ticketService.getTicketsByUserId(1, 0);
      await validationService.validateTicket(mockValidationData, (bool value) => {}, (String value) => {});
      final ticketsAfter = await ticketService.getTicketsByUserId(1, 0);
      expect(ticketsBefore.first.tickets.first.status, isNot(TicketStatus.VALIDATED));
      expect(ticketsAfter.first.tickets.first.status, TicketStatus.VALIDATED);
    });
  });
}
