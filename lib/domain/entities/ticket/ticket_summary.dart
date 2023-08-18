import 'package:flutter/material.dart';
import 'package:validator/domain/entities/event.dart';
import 'package:validator/domain/entities/ticket/ticket.dart';

@immutable
class TicketSummary {
  final Event event;
  final List<Ticket> tickets;
  final int count;

  const TicketSummary({
    required this.event,
    required this.tickets,
    required this.count,
  });

  factory TicketSummary.fromJson(Map<String, dynamic> json) {
    return TicketSummary(
      count: json['count'],
      event: Event.fromJson(json['event']),
      tickets: (json['tickets'] as List<dynamic>).map((ticketJson) => Ticket.fromJson(ticketJson)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event': event.toJson(),
      'tickets': tickets.map((ticket) => ticket.toJson()).toList(),
    };
  }
}
