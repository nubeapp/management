import 'dart:convert';

import 'package:validator/config/app_config.dart';
import 'package:validator/domain/entities/order.dart';
import 'package:validator/domain/entities/ticket/create_ticket.dart';
import 'package:validator/domain/entities/ticket/ticket_summary.dart';
import 'package:validator/domain/exceptions/exceptions.dart';
import 'package:validator/domain/services/ticket_service_interface.dart';
import 'package:http/http.dart' as http;
import 'package:validator/presentation/styles/logger.dart';

class TicketService implements ITicketService {
  static String get API_BASE_URL => 'http://$LOCALHOST:8000/tickets';
  final http.Client client;

  TicketService({required this.client});

  @override
  Future<TicketSummary> getTicketsByUserIdEventId(int eventId) async {
    try {
      Logger.debug('Requesting tickets for event $eventId...');
      final response = await client.get(Uri.parse('$API_BASE_URL/events/$eventId'));

      if (response.statusCode == 200) {
        Logger.info('Tickets have been retrieved successfully!');
        return TicketSummary.fromJson(json.decode(utf8.decode(response.bodyBytes)) as dynamic);
      } else {
        throw Exception('Failed to get tickets');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TicketSummary> getTicketsAvailableByEventId(int eventId) async {
    try {
      Logger.debug('Requesting tickets available for event $eventId...');
      final response = await client.get(Uri.parse('$API_BASE_URL/available/$eventId'));

      if (response.statusCode == 200) {
        Logger.info('Available tickets have been retrieved successfully!');
        return TicketSummary.fromJson(json.decode(utf8.decode(response.bodyBytes)) as dynamic);
      } else {
        throw Exception('Failed to get available tickets');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TicketSummary>> getTicketsByUserId(int limit, int offset) async {
    try {
      final response = await client.get(Uri.parse('$API_BASE_URL?limit=$limit&offset=$offset'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
        Logger.info('Tickets have been retrieved successfully!');
        return jsonList.map((json) => TicketSummary.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorize operation');
      } else {
        throw Exception('Failed to get tickets');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TicketSummary> getTicketsByEventId(int eventId) async {
    try {
      final response = await client.get(Uri.parse('$API_BASE_URL/$eventId'));

      if (response.statusCode == 200) {
        Logger.info('Tickets for event $eventId have been retrieved successfully!');
        return TicketSummary.fromJson(json.decode(utf8.decode(response.bodyBytes)) as dynamic);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorize operation');
      } else {
        throw Exception('Failed to get tickets for event $eventId');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TicketSummary> createTickets(CreateTicket ticketData) async {
    try {
      Logger.debug('Creating tickets...');
      final response = await client.post(
        Uri.parse(API_BASE_URL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(ticketData.toJson()),
      );

      if (response.statusCode == 201) {
        Logger.info('Tickets have been created successfully!');
        return TicketSummary.fromJson(json.decode(utf8.decode(response.bodyBytes)) as dynamic);
      } else {
        throw Exception('Failed to create tickets');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TicketSummary> buyTickets(Order order) async {
    try {
      Logger.debug('Buying ${order.quantity} tickets for event ${order.eventId}...');
      final response = await client.post(
        Uri.parse('$API_BASE_URL/buy'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(order.toJson()),
      );

      if (response.statusCode == 201) {
        Logger.info('Tickets have been bought successfully!');
        return TicketSummary.fromJson(json.decode(utf8.decode(response.bodyBytes)) as dynamic);
      } else if (response.statusCode == 400) {
        throw EventTicketLimitException('The event has reached its ticket limit');
      } else if (response.statusCode == 409) {
        throw UserTicketLimitException('The user has already reached the limit of tickets for this event');
      } else {
        throw Exception('Failed to buy ticket');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTicketById(int ticketId) async {
    try {
      Logger.debug('Deleting ticket with id $ticketId...');
      final response = await client.delete(Uri.parse('$API_BASE_URL/$ticketId'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete ticket by id. Status code: ${response.statusCode}');
      }

      Logger.info('Ticket with id $ticketId has been deleted successfully!');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTicketsByEventId(int eventId) async {
    try {
      Logger.debug('Deleting tickets by event_id $eventId...');
      final response = await client.delete(Uri.parse('$API_BASE_URL/event/$eventId'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete events by organization_id. Status code: ${response.statusCode}');
      }
      Logger.info('Tickets by event_id $eventId have been deleted successfully!');
    } catch (e) {
      rethrow;
    }
  }
}
