import 'package:flutter/material.dart';
import 'package:validator/domain/entities/organization.dart';
import 'package:validator/infrastructure/utilities/helpers.dart';

@immutable
class Event {
  final int? id;
  final String title;
  final String date;
  final String time;
  final String venue;
  final int? organizationId;
  final Organization? organization;

  // Constructor
  const Event({
    this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.venue,
    this.organizationId,
    this.organization,
  });

  // Factory method to create a new instance from a Map (fromJson)
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      // date: customDateTime,
      date: Helpers.convertToDDMMYYYY(json['date']),
      time: json['time'],
      venue: json['venue'],
      organization: json['organization'] != null ? Organization.fromJson(json['organization']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      // 'date': formattedDate,
      'date': date,
      'time': time,
      'venue': venue,
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
