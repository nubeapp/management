import 'package:flutter/material.dart';

@immutable
class ValidationData {
  final int eventId;
  final String reference;

  // Constructor
  const ValidationData({required this.eventId, required this.reference});

  // Factory method to create a new instance from a Map (fromJson)
  factory ValidationData.fromJson(Map<String, dynamic> json) {
    return ValidationData(eventId: json['event_id'], reference: json['reference']);
  }

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'reference': reference,
    };
  }
}
