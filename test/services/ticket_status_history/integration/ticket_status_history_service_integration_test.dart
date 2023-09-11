import 'package:flutter_test/flutter_test.dart';
import 'package:validator/domain/entities/ticket/ticket_status_history.dart';
import 'package:validator/domain/services/ticket_status_history_service_interface.dart';
import '../../../../test_config/config/services/ticket_status_history/ticket_status_history_service_config_test.dart';

void main() {
  TicketStatusHistoryServiceConfigTest ticketStatusHistoryConfig = TicketStatusHistoryServiceConfigTest();
  late ITicketStatusHistoryService ticketStatusHistoryService;
  late int mockTicketId;

  setUpAll(() async {
    ticketStatusHistoryService = await ticketStatusHistoryConfig.setUpDatabase();
    mockTicketId = ticketStatusHistoryConfig.mockTicketId;
  });

  tearDownAll(() async {
    await ticketStatusHistoryConfig.cleanUpDatabase();
  });

  group('TicketStatusHistoryService Integration Tests', () {
    test('Get tickets status history by TicketId', () async {
      final ticketStatusHistory = await ticketStatusHistoryService.getTicketStatusHistoryByTicketId(mockTicketId);
      expect(ticketStatusHistory, isA<List<TicketStatusHistory>>());
      expect(ticketStatusHistory.length, equals(3));
    });
  });
}
