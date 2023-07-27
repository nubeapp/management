import 'package:validator/domain/entities/event.dart';

abstract class IEventService {
  Future<List<Event>> getEvents();

  Future<Event> getEventById(int eventId);

  // Future<Map<String, Map<String, List<Event>>>> getEventsGroupedByYearMonth();

  Future<List<Event>> getFavouriteEventsByUserId();

  Future<List<Event>> getEventsByOrganizationId(int organizationId);

  Future<Event> createEvent(Event event);

  Future<Event> updateEventById(int eventId, Event updatedEvent);

  Future<void> deleteEventById(int eventId);

  Future<void> deleteEventsByOrganizationId(int organizationId);

  Future<void> deleteAllEvents();
}
