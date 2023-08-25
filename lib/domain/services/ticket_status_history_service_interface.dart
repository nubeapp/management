import 'package:flutter/material.dart';
import 'package:validator/domain/entities/ticket/ticket_status_history.dart';

@immutable
abstract class ITicketStatusHistoryService {
  Future<List<TicketStatusHistory>> getTicketStatusHistoryByTicketId(int ticketId);
}
