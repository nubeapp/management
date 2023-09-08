import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:validator/config/app_config.dart';
import 'package:validator/domain/entities/ticket/ticket_status.dart';
import 'package:validator/domain/entities/ticket/ticket_status_history.dart';
import 'package:validator/domain/services/ticket_status_history_service_interface.dart';
import 'package:validator/infrastructure/services/ticket_status_history_service.dart';

import '../../../mocks/mock_responses.dart';
import 'ticket_status_history_service_unit_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ITicketStatusHistoryService ticketStatusHistoryService;
  const String API_BASE_URL = 'http://$LOCALHOST:8000/ticket_status_history';

  group('TicketStatusHistoryService', () {
    group('getTicketStatusHistoryByTicketId', () {
      test('returns a list of ticket_status_history', () async {
        final mockClient = MockClient();
        ticketStatusHistoryService = TicketStatusHistoryService(client: mockClient);
        int mockTicketId = 1;

        when(mockClient.get(Uri.parse('$API_BASE_URL/$mockTicketId')))
            .thenAnswer((_) async => http.Response(json.encode(mockTicketStatusHistoryListResponse), 200));

        final ticketStatusHistory = await ticketStatusHistoryService.getTicketStatusHistoryByTicketId(mockTicketId);

        expect(ticketStatusHistory, isA<List<TicketStatusHistory>>());
        expect(ticketStatusHistory.length, equals(3));
        expect(ticketStatusHistory.first.id, equals(1));
        expect(ticketStatusHistory.first.status, TicketStatus.AVAILABLE);

        verify(mockClient.get(Uri.parse('$API_BASE_URL/$mockTicketId'))).called(1);
      });

      test('throws an exception if the http call completes with an error', () {
        final mockClient = MockClient();
        ticketStatusHistoryService = TicketStatusHistoryService(client: mockClient);
        int mockTicketId = 1;

        when(mockClient.get(Uri.parse('$API_BASE_URL/$mockTicketId'))).thenAnswer((_) async => http.Response('Not Found', 404));

        expect(() async => await ticketStatusHistoryService.getTicketStatusHistoryByTicketId(mockTicketId), throwsException);

        verify(mockClient.get(Uri.parse('$API_BASE_URL/$mockTicketId'))).called(1);
      });
    });
  });
}
