import 'package:flutter/material.dart';
import 'package:validator/domain/entities/event.dart';
import 'package:validator/domain/entities/order.dart';
import 'package:validator/domain/entities/ticket/ticket_status.dart';
import 'package:validator/domain/entities/user.dart';

@immutable
class Ticket {
  final int? id;
  final double price;
  final String reference;
  final TicketStatus status;
  final int? eventId;
  final int? userId;
  final int? orderId;
  final Event? event;
  final User? user;
  final Order? order;

  const Ticket(
      {this.id,
      required this.price,
      required this.reference,
      required this.status,
      this.eventId,
      this.userId,
      this.orderId,
      this.event,
      this.user,
      this.order});

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
        id: json['id'],
        price: json['price'],
        reference: json['reference'],
        status: TicketStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => TicketStatus.AVAILABLE,
        ),
        event: json['event'] != null ? Event.fromJson(json['event']) : null,
        user: json['user'] != null ? User.fromJson(json['user']) : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'event_id': eventId,
      'reference': reference,
      'status': status.name,
    };
  }
}
