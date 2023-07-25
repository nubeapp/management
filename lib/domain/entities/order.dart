import 'package:flutter/material.dart';
import 'package:validator/domain/entities/event.dart';
import 'package:validator/domain/entities/ticket/ticket.dart';

@immutable
class Order {
  final int? id;
  final int? eventId;
  final int? quantity;
  final Event? event;
  final List<Ticket>? tickets;

  const Order({
    this.id,
    this.eventId,
    this.quantity,
    this.event,
    this.tickets,
  });

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> ticketList = [];
    if (tickets != null) {
      ticketList = tickets!.map((t) => t.toJson()).toList();
    }

    return {
      'id': id,
      'event_id': eventId,
      'quantity': quantity,
      'event': event,
      'tickets': ticketList,
    };
  }

  static Order fromJson(Map<String, dynamic> json) {
    List<Ticket>? ticketsList = [];
    if (json['tickets'] != null) {
      var ticketObjsJson = json['tickets'] as List<dynamic>;
      ticketsList = ticketObjsJson.map((t) => Ticket.fromJson(t)).toList();
    }

    return Order(
      id: json['id'],
      eventId: json['event_id'],
      quantity: json['quantity'],
      event: Event.fromJson(json['event']),
      tickets: ticketsList,
    );
  }
}
