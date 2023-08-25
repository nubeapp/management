import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:validator/domain/entities/ticket/ticket.dart';
import 'package:validator/domain/entities/ticket/ticket_status.dart';
import 'package:validator/domain/entities/ticket/ticket_status_history.dart';
import 'package:validator/domain/services/ticket_service_interface.dart';
import 'package:validator/domain/services/ticket_status_history_service_interface.dart';
import 'package:validator/extensions/extensions.dart';
import 'package:validator/infrastructure/utilities/helpers.dart';
import 'package:validator/presentation/styles/logger.dart';
import 'package:validator/presentation/widgets/button.dart';
import 'package:validator/presentation/widgets/custom_app_bar.dart';
import 'package:validator/presentation/widgets/custom_toast.dart';
import 'package:validator/presentation/widgets/label.dart';
import 'package:validator/presentation/widgets/light_label.dart';

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
    );
  }

  void _showTicketStatusHistory() async {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(width: context.w * 0.9, height: context.h * 0.5, child: TicketStatusHistoryResume(ticket: _updatedTicket)),
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteTicket() async {
    bool delete = await Helpers.showConfirmDialog(context: context, element: 'ticket');
    if (delete) {
      try {
        await _ticketService.deleteTicketById(_updatedTicket.id!);
        Navigator.of(context).pop(true);
      } catch (e) {
        Logger.error('Failed to delete the ticket. Exception: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.popDelete(
        context: context,
        title: 'Ticket',
        popValue: _cancel,
        actionOnPressed: () async => await _deleteTicket(),
      ),
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
                        Helpers.getStatusLabelFromTicketStatus(_updatedTicket.status),
                        SizedBox(height: context.h * 0.02),
                        if (_updatedTicket.user != null) const LightLabel(label: 'Name'),
                        if (_updatedTicket.user != null) Label(label: _updatedTicket.user!.name),
                        if (_updatedTicket.user != null) SizedBox(height: context.h * 0.02),
                        // if (_updatedTicket.status != TicketStatus.AVAILABLE)
                        //   LightLabel(label: '${Helpers.capitalizeFirstLetter(_updatedTicket.status.name)} date'),
                        // if (_updatedTicket.status != TicketStatus.AVAILABLE) Label(label: getStatusDateFromTicket(_updatedTicket)),
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
                        Label(label: Helpers.doubleToEuroFormat(_updatedTicket.price)),
                        SizedBox(height: context.h * 0.02),
                        if (_updatedTicket.user != null) const LightLabel(label: 'Surname'),
                        if (_updatedTicket.user != null) Label(label: _updatedTicket.user!.surname),
                        if (_updatedTicket.user != null) SizedBox(height: context.h * 0.02),
                        // if (_updatedTicket.status != TicketStatus.AVAILABLE)
                        //   LightLabel(label: '${Helpers.capitalizeFirstLetter(_updatedTicket.status.name)} time'),
                        // if (_updatedTicket.status != TicketStatus.AVAILABLE) Label(label: getStatusTimeFromTicket(_updatedTicket)),
                        if (_updatedTicket.status != TicketStatus.AVAILABLE) SizedBox(height: context.h * 0.02),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  Button.black(text: 'Status history', width: context.w * 0.38, onPressed: () => _showTicketStatusHistory()),
                ],
              ),
              SizedBox(height: context.h * 0.1),
              // TicketStatusHistory(ticket: _updatedTicket)
            ],
          ),
        ),
      ),
    );
  }
}

class TicketStatusHistoryResume extends StatefulWidget {
  const TicketStatusHistoryResume({Key? key, required this.ticket}) : super(key: key);

  final Ticket ticket;

  @override
  State<TicketStatusHistoryResume> createState() => _TicketStatusHistoryResumeState();
}

class _TicketStatusHistoryResumeState extends State<TicketStatusHistoryResume> {
  final _ticketStatusHistoryService = GetIt.instance<ITicketStatusHistoryService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderStatusHistory(),
            Expanded(
              child: FutureBuilder<List<TicketStatusHistory>>(
                future: _ticketStatusHistoryService.getTicketStatusHistoryByTicketId(widget.ticket.id!),
                builder: (BuildContext context, AsyncSnapshot<List<TicketStatusHistory>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.black87),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final statusHistory = snapshot.data!;
                    return ListView.builder(
                      itemCount: statusHistory.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TicketStatusRow(statusRow: statusHistory[index]),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderStatusHistory extends StatelessWidget {
  const HeaderStatusHistory({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const LightLabel(label: 'Status'),
        SizedBox(width: context.w * 0.24),
        const LightLabel(label: 'Date'),
        SizedBox(width: context.w * 0.12),
        const LightLabel(label: 'Time'),
      ],
    );
  }
}

class TicketStatusRow extends StatelessWidget {
  const TicketStatusRow({
    Key? key,
    required this.statusRow,
  }) : super(key: key);

  final TicketStatusHistory statusRow;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: context.w * 0.325,
          alignment: Alignment.centerLeft,
          child: Helpers.getStatusLabelFromTicketStatus(statusRow.status),
        ),
        SizedBox(
          width: context.w * 0.325,
          child: Label(label: Helpers.formatString(Helpers.getDateFromFormattedStringDDMMYYYYHHSS(statusRow.statusAt))),
        ),
        Container(
          width: context.w * 0.18,
          alignment: Alignment.center,
          child: Label(label: Helpers.getTimeFromFormattedStringDDMMYYYYHHSS(statusRow.statusAt)),
        ),
      ],
    );
  }
}
