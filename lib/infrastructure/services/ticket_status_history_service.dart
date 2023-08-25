import 'dart:convert';

import 'package:validator/config/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:validator/domain/entities/ticket/ticket_status_history.dart';
import 'package:validator/domain/services/ticket_status_history_service_interface.dart';
import 'package:validator/presentation/styles/logger.dart';

class TicketStatusHistoryService implements ITicketStatusHistoryService {
  TicketStatusHistoryService({required this.client});

  static String get API_BASE_URL => 'http://$LOCALHOST:8000/ticket_status_history';
  final http.Client client;

  @override
  Future<List<TicketStatusHistory>> getTicketStatusHistoryByTicketId(int ticketId) async {
    try {
      Logger.debug('Requesting status history for ticket $ticketId...');
      final response = await client.get(Uri.parse('$API_BASE_URL/$ticketId'));
      if (response.statusCode == 200) {
        Logger.info('Status history has been retrieved successfully!!');
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((e) => TicketStatusHistory.fromJson(e)).toList();
      } else {
        throw Exception('Failed to get status history Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
