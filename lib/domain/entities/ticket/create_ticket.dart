import 'package:flutter/material.dart';

@immutable
class CreateTicket {
  final double price;
  final int eventId;
  final int limit;

  const CreateTicket({required this.price, required this.eventId, required this.limit});

  factory CreateTicket.fromJson(Map<String, dynamic> json) {
    return CreateTicket(
      price: json['price'],
      eventId: json['event_id'],
      limit: json['limit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'event_id': eventId,
      'limit': limit,
    };
  }
}
