import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:validator/domain/entities/event.dart';
import 'package:validator/domain/services/event_service_interface.dart';
import 'package:validator/presentation/styles/logger.dart';

class EventService implements IEventService {
  EventService({required this.client});

  static String get API_BASE_URL => 'http://192.168.1.73:8000/events';
  final http.Client client;

  @override
  Future<List<Event>> getEvents() async {
    try {
      Logger.debug('Requesting all events from the database...');
      final response = await client.get(Uri.parse(API_BASE_URL));
      if (response.statusCode == 200) {
        Logger.info('Events have been retrieved successfully!');
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((e) => Event.fromJson(e)).toList();
      } else {
        throw Exception('Failed to get events. Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // @override
  // Future<Map<String, Map<String, List<Event>>>> getEventsGroupedByYearMonth() async {
  //   try {
  //     Logger.debug('Requesting all events from the database...');
  //     final response = await client.get(Uri.parse('$API_BASE_URL/yearmonth'));

  //     if (response.statusCode == 200) {
  //       Logger.info('Events have been retrieved successfully!');
  //       final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));

  //       // Create a map to store events grouped by year and month
  //       Map<String, Map<String, List<Event>>> eventsGrouped = {};

  //       // Iterate through the response and convert it to the desired format
  //       data.forEach((year, monthsData) {
  //         eventsGrouped[year] = {};
  //         monthsData.forEach((month, eventsData) {
  //           final List<Event> eventsList = eventsData.map((eventData) => Event.fromJson(eventData)).toList();
  //           eventsGrouped[year]![month] = eventsList;
  //         });
  //       });

  //       return eventsGrouped;
  //     } else {
  //       throw Exception('Failed to get events. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  @override
  Future<Event> getEventById(int eventId) async {
    try {
      Logger.debug('Requesting event with id $eventId...');
      final response = await client.get(Uri.parse('$API_BASE_URL/event/$eventId'));

      if (response.statusCode == 200) {
        Logger.info('Event with id $eventId was retrieved successfully!');
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return Event.fromJson(data);
      } else {
        throw Exception('Failed to get event by id. Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Event>> getFavouriteEventsByUserId() async {
    try {
      Logger.debug('Requesting favourite events...');
      final response = await client.get(Uri.parse('$API_BASE_URL/favourites'));

      if (response.statusCode == 200) {
        Logger.info('Favourite events have been retrieved successfully!');
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((e) => Event.fromJson(e)).toList();
      } else {
        throw Exception('Failed to get events by organization_id. Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Event>> getEventsByOrganizationId(int organizationId) async {
    try {
      Logger.debug('Requesting events by organization_id $organizationId...');
      final response = await client.get(Uri.parse('$API_BASE_URL/$organizationId'));

      if (response.statusCode == 200) {
        Logger.info('Events of organization_id $organizationId have been retrieved successfully!');
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((e) => Event.fromJson(e)).toList();
      } else {
        throw Exception('Failed to get events by organization_id. Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Event> createEvent(Event event) async {
    try {
      Logger.debug('Creating new event "${event.title}"...');
      final response = await client.post(
        Uri.parse(API_BASE_URL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(event.toJson()),
      );

      if (response.statusCode == 201) {
        Logger.info('The event "${event.title}" was created successfully!');
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return Event.fromJson(data);
      } else {
        throw Exception('Failed to create event. Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Event> updateEventById(int eventId, Event updatedEvent) async {
    try {
      Logger.debug('Updating the event with id $eventId...');
      final response = await client.put(
        Uri.parse('$API_BASE_URL/$eventId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(updatedEvent.toJson()),
      );

      if (response.statusCode == 200) {
        Logger.info('The event with id $eventId has been updated successfully!');
        final Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return Event.fromJson(data);
      } else {
        throw Exception('Failed to update event by id. Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteEventById(int eventId) async {
    try {
      Logger.debug('Deleting event with id $eventId...');
      final response = await client.delete(Uri.parse('$API_BASE_URL/event/$eventId'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete event by id. Status code: ${response.statusCode}');
      }

      Logger.info('Event with id $eventId has been deleted successfully!');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteEventsByOrganizationId(int organizationId) async {
    try {
      Logger.debug('Deleting events by organization_id $organizationId...');
      final response = await client.delete(Uri.parse('$API_BASE_URL/$organizationId'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete events by organization_id. Status code: ${response.statusCode}');
      }
      Logger.info('Events by organization_id $organizationId have been deleted successfully!');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAllEvents() async {
    try {
      Logger.debug('Deleting all events in the database...');
      final response = await client.delete(Uri.parse(API_BASE_URL));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete all events. Status code: ${response.statusCode}');
      }
      Logger.info('All events have been deleted successfully!');
    } catch (e) {
      rethrow;
    }
  }
}
