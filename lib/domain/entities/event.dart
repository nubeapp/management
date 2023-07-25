import 'package:flutter/material.dart';
import 'package:validator/domain/entities/organization.dart';

@immutable
class Event {
  final int? id;
  final String title;
  final DateTime date;
  final String time;
  final String venue;
  final int? ticketLimit;
  final int? organizationId;
  final Organization? organization;

  // Constructor
  const Event({
    this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.venue,
    this.ticketLimit,
    this.organizationId,
    this.organization,
  });

  // Factory method to create a new instance from a Map (fromJson)
  factory Event.fromJson(Map<String, dynamic> json) {
    DateTime dateTime = DateTime.parse(json['date']);
    CustomDateTime customDateTime = CustomDateTime(dateTime.year, dateTime.month, dateTime.day);
    return Event(
      id: json['id'],
      title: json['title'],
      date: customDateTime,
      time: json['time'],
      venue: json['venue'],
      organization: json['organization'] != null ? Organization.fromJson(json['organization']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    String formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}T$time+01:00';

    return {
      'title': title,
      'date': formattedDate,
      'time': time,
      'venue': venue,
      'ticket_limit': ticketLimit,
      'organization_id': organizationId,
    };
  }
}

class CustomDateTime extends DateTime {
  CustomDateTime(int year, int month, int day) : super(year, month, day);

  @override
  String toString() {
    String formattedDay = day.toString().padLeft(2, '0');
    String formattedMonth = month.toString().padLeft(2, '0');
    String formattedYear = year.toString();

    return '$formattedDay-$formattedMonth-$formattedYear';
  }
}
