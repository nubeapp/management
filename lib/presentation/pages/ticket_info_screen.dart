import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:validator/domain/entities/ticket/ticket.dart';
import 'package:validator/domain/entities/ticket/ticket_navigation.dart';
import 'package:validator/domain/entities/ticket/ticket_status.dart';
import 'package:validator/domain/services/ticket_service_interface.dart';
import 'package:validator/extensions/extensions.dart';
import 'package:validator/infrastructure/utilities/helpers.dart';
import 'package:validator/presentation/widgets/alert_empty_fields.dart';
import 'package:validator/presentation/widgets/border_button.dart';
import 'package:validator/presentation/widgets/button.dart';
import 'package:validator/presentation/widgets/custom_toast.dart';
import 'package:validator/presentation/widgets/label.dart';
import 'package:intl/intl.dart';
import 'package:validator/presentation/widgets/light_label.dart';
import 'package:validator/presentation/widgets/status_label.dart';

class TicketInfoScreen extends StatefulWidget {
  const TicketInfoScreen({Key? key, required this.ticket}) : super(key: key);

  final Ticket ticket;

  @override
  State<TicketInfoScreen> createState() => _TicketInfoScreenState();
}

class _TicketInfoScreenState extends State<TicketInfoScreen> {
  final _ticketService = GetIt.instance<ITicketService>();
  late Ticket _updatedTicket;
  bool _isLoading = false;
  bool _cancel = false;

  @override
  void initState() {
    super.initState();
    _updatedTicket = widget.ticket;
  }

  PreferredSizeWidget _customAppBar() => AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Ticket',
          style: TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          padding: const EdgeInsets.only(left: 16),
          icon: const Icon(
            CupertinoIcons.left_chevron,
            size: 26,
            color: Colors.black87,
          ),
          onPressed: () {
            final ticketNavigation = TicketNavigation(cancel: _cancel);
            Navigator.of(context).pop(ticketNavigation);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: BorderButton.delete(
              width: context.w * 0.1,
              onPressed: () async {
                bool delete = await _showConfirmDialog();
                if (delete) {
                  await _ticketService.deleteTicketById(_updatedTicket.id!);
                  final ticketNavigation = TicketNavigation(cancel: false, ticket: _updatedTicket);
                  Navigator.of(context).pop(ticketNavigation);
                }
              },
            ),
          ),
        ],
      );

  Future<bool> _showConfirmDialog() async {
    final bool? result = await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: context.w * 0.9,
                height: context.h * 0.24,
                child: const AlertConfirmDialog(element: 'ticket'),
              ),
            ),
          ),
        );
      },
    );
    return result ?? false;
  }

  Ticket _createCanceledTicket(Ticket originalTicket) {
    return Ticket(
      id: originalTicket.id,
      reference: originalTicket.reference,
      status: TicketStatus.CANCELED,
      price: originalTicket.price,
      event: originalTicket.event,
      eventId: originalTicket.eventId,
      order: originalTicket.order,
      orderId: originalTicket.orderId,
      user: originalTicket.user,
      userId: originalTicket.userId,
      createdAt: originalTicket.createdAt,
      soldAt: originalTicket.soldAt,
      validatedAt: originalTicket.validatedAt,
      canceledAt: Helpers.convertDbDateTimeToDateTime(DateTime.now().toIso8601String()),
    );
  }

  String getStatusDateFromTicket(Ticket ticket) {
    switch (ticket.status) {
      case TicketStatus.SOLD:
        return Helpers.formatString(Helpers.getDateFromFormattedStringDDMMYYYYHHSS(ticket.soldAt!));
      case TicketStatus.VALIDATED:
        return Helpers.formatString(Helpers.getDateFromFormattedStringDDMMYYYYHHSS(ticket.validatedAt!));
      case TicketStatus.CANCELED:
        return Helpers.formatString(Helpers.getDateFromFormattedStringDDMMYYYYHHSS(ticket.canceledAt!));
      default:
        return '';
    }
  }

  String getStatusTimeFromTicket(Ticket ticket) {
    switch (ticket.status) {
      case TicketStatus.SOLD:
        return Helpers.getTimeFromFormattedStringDDMMYYYYHHSS(ticket.soldAt!);
      case TicketStatus.VALIDATED:
        return Helpers.getTimeFromFormattedStringDDMMYYYYHHSS(ticket.validatedAt!);
      case TicketStatus.CANCELED:
        return Helpers.getTimeFromFormattedStringDDMMYYYYHHSS(ticket.canceledAt!);
      default:
        return '';
    }
  }

  StatusLabel getStatusLabelFromTicketStatus(Ticket ticket) {
    switch (ticket.status) {
      case TicketStatus.AVAILABLE:
        return StatusLabel.available();
      case TicketStatus.SOLD:
        return StatusLabel.sold();
      case TicketStatus.VALIDATED:
        return const StatusLabel.validated();
      case TicketStatus.CANCELED:
        return const StatusLabel.canceled();
      default:
        return const StatusLabel(
          status: 'Not found',
          color: Colors.orange,
          textColor: Colors.white70,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LightLabel(label: 'Reference'),
              Label(label: _updatedTicket.reference),
              SizedBox(height: context.h * 0.02),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: context.w * 0.5 - 16,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LightLabel(label: 'Status'),
                        getStatusLabelFromTicketStatus(_updatedTicket),
                        SizedBox(height: context.h * 0.02),
                        if (_updatedTicket.user != null) const LightLabel(label: 'Name'),
                        if (_updatedTicket.user != null) Label(label: _updatedTicket.user!.name),
                        if (_updatedTicket.user != null) SizedBox(height: context.h * 0.02),
                        if (_updatedTicket.status != TicketStatus.AVAILABLE)
                          LightLabel(label: '${Helpers.capitalizeFirstLetter(_updatedTicket.status.name)} date'),
                        if (_updatedTicket.status != TicketStatus.AVAILABLE) Label(label: getStatusDateFromTicket(_updatedTicket)),
                        if (_updatedTicket.status != TicketStatus.AVAILABLE) SizedBox(height: context.h * 0.02),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: context.w * 0.5 - 16,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LightLabel(label: 'Price'),
                        Label(label: NumberFormat.currency(symbol: '€ ', decimalDigits: 2).format(_updatedTicket.price)),
                        SizedBox(height: context.h * 0.02),
                        if (_updatedTicket.user != null) const LightLabel(label: 'Surname'),
                        if (_updatedTicket.user != null) Label(label: _updatedTicket.user!.surname),
                        if (_updatedTicket.user != null) SizedBox(height: context.h * 0.02),
                        if (_updatedTicket.status != TicketStatus.AVAILABLE)
                          LightLabel(label: '${Helpers.capitalizeFirstLetter(_updatedTicket.status.name)} time'),
                        if (_updatedTicket.status != TicketStatus.AVAILABLE) Label(label: getStatusTimeFromTicket(_updatedTicket)),
                        if (_updatedTicket.status != TicketStatus.AVAILABLE) SizedBox(height: context.h * 0.02),
                      ],
                    ),
                  ),
                ],
              ),
              if (_updatedTicket.status != TicketStatus.CANCELED && _updatedTicket.status != TicketStatus.VALIDATED)
                _isLoading
                    ? const CircularProgressIndicator(color: Colors.black54)
                    : Button.red(
                        text: 'Cancel ticket',
                        width: context.w * 0.35,
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            await Future.delayed(const Duration(milliseconds: 2000));
                            await _ticketService.cancelTicket(_updatedTicket.id!);
                            _updatedTicket = _createCanceledTicket(widget.ticket);
                            setState(() {
                              _isLoading = false;
                            });
                            CustomToast.showToast(
                                context: context,
                                width: context.w * 0.75,
                                message: 'Ticket has been cancelled',
                                color: Colors.green.withOpacity(0.8),
                                icon: CupertinoIcons.checkmark_alt_circle);
                            _cancel = true;
                          } catch (e) {
                            setState(() {
                              _isLoading = false;
                            });

                            CustomToast.showToast(
                                context: context,
                                width: context.w * 0.75,
                                message: 'Failed to cancelled ticket',
                                color: Colors.red.withOpacity(1),
                                icon: CupertinoIcons.clear);
                          }
                        },
                      ),
              SizedBox(height: context.h * 0.1),
              TicketStatusHistory(ticket: _updatedTicket)
            ],
          ),
        ),
      ),
    );
  }
}

class TicketStatusHistory extends StatefulWidget {
  const TicketStatusHistory({Key? key, required this.ticket}) : super(key: key);

  final Ticket ticket;

  @override
  State<TicketStatusHistory> createState() => _TicketStatusHistoryState();
}

class _TicketStatusHistoryState extends State<TicketStatusHistory> {
  int getTicketStatusCounter(Ticket ticket) {
    int counter = 1;
    if (ticket.soldAt != null) counter++;
    if (ticket.validatedAt != null) counter++;
    if (ticket.canceledAt != null) counter++;
    return counter;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Label(label: 'Status history'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const LightLabel(label: 'Status'),
            SizedBox(width: context.w * 0.275),
            const LightLabel(label: 'Date'),
            SizedBox(width: context.w * 0.185),
            const LightLabel(label: 'Time'),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: context.w * 0.36,
                alignment: Alignment.centerLeft,
                child: StatusLabel.available(),
              ),
              SizedBox(
                width: context.w * 0.35,
                child: Label(label: Helpers.formatString(Helpers.getDateFromFormattedStringDDMMYYYYHHSS(widget.ticket.createdAt!))),
              ),
              Container(
                width: context.w * 0.205,
                alignment: Alignment.centerRight,
                child: Label(label: Helpers.getTimeFromFormattedStringDDMMYYYYHHSS(widget.ticket.createdAt!)),
              ),
            ],
          ),
        ),
        if (widget.ticket.soldAt != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: context.w * 0.36,
                  alignment: Alignment.centerLeft,
                  child: StatusLabel.sold(),
                ),
                SizedBox(
                  width: context.w * 0.35,
                  child: Label(label: Helpers.formatString(Helpers.getDateFromFormattedStringDDMMYYYYHHSS(widget.ticket.soldAt!))),
                ),
                Container(
                  width: context.w * 0.205,
                  alignment: Alignment.centerRight,
                  child: Label(label: Helpers.getTimeFromFormattedStringDDMMYYYYHHSS(widget.ticket.soldAt!)),
                ),
              ],
            ),
          ),
        if (widget.ticket.validatedAt != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: context.w * 0.36,
                  alignment: Alignment.centerLeft,
                  child: const StatusLabel.validated(),
                ),
                SizedBox(
                  width: context.w * 0.35,
                  child: Label(label: Helpers.formatString(Helpers.getDateFromFormattedStringDDMMYYYYHHSS(widget.ticket.validatedAt!))),
                ),
                Container(
                  width: context.w * 0.205,
                  alignment: Alignment.centerRight,
                  child: Label(label: Helpers.getTimeFromFormattedStringDDMMYYYYHHSS(widget.ticket.validatedAt!)),
                ),
              ],
            ),
          ),
        if (widget.ticket.canceledAt != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  width: context.w * 0.36,
                  alignment: Alignment.centerLeft,
                  child: const StatusLabel.canceled(),
                ),
                SizedBox(
                  width: context.w * 0.35,
                  child: Label(label: Helpers.formatString(Helpers.getDateFromFormattedStringDDMMYYYYHHSS(widget.ticket.canceledAt!))),
                ),
                Container(
                  width: context.w * 0.205,
                  alignment: Alignment.centerRight,
                  child: Label(label: Helpers.getTimeFromFormattedStringDDMMYYYYHHSS(widget.ticket.canceledAt!)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
