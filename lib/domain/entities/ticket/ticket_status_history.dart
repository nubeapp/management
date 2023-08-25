import 'package:flutter/material.dart';
import 'package:validator/domain/entities/ticket/ticket_status.dart';
import 'package:validator/infrastructure/utilities/helpers.dart';

@immutable
class TicketStatusHistory {
  final int id;
  final int ticketId;
  final TicketStatus status;
  final String statusAt;

  const TicketStatusHistory({
    required this.id,
    required this.ticketId,
    required this.status,
    required this.statusAt,
  });

  factory TicketStatusHistory.fromJson(Map<String, dynamic> json) {
    return TicketStatusHistory(
      id: json['id'],
      ticketId: json['ticket_id'],
      status: TicketStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TicketStatus.AVAILABLE,
      ),
      statusAt: Helpers.convertDbDateTimeToDateTime(json['status_at']),
    );
  }
}
