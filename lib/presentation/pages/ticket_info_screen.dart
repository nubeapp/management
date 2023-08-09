import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:validator/domain/entities/ticket/ticket.dart';
import 'package:validator/domain/entities/ticket/ticket_status.dart';
import 'package:validator/domain/services/ticket_service_interface.dart';
import 'package:validator/extensions/extensions.dart';
import 'package:validator/infrastructure/utilities/helpers.dart';
import 'package:validator/presentation/widgets/alert_empty_fields.dart';
import 'package:validator/presentation/widgets/border_button.dart';
import 'package:validator/presentation/widgets/button.dart';
import 'package:validator/presentation/widgets/label.dart';
import 'package:intl/intl.dart';

class TicketInfoScreen extends StatefulWidget {
  const TicketInfoScreen({Key? key, required this.ticket}) : super(key: key);

  final Ticket ticket;

  @override
  State<TicketInfoScreen> createState() => _TicketInfoScreenState();
}

class _TicketInfoScreenState extends State<TicketInfoScreen> {
  final _ticketService = GetIt.instance<ITicketService>();

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
            Navigator.of(context).pop();
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
                  await _ticketService.deleteTicketById(widget.ticket.id!);
                  Navigator.of(context).pop(widget.ticket.id);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LightLabel(label: 'Reference'),
            Label(label: widget.ticket.reference),
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
                      Label(label: widget.ticket.status.name),
                      SizedBox(height: context.h * 0.02),
                      if (widget.ticket.user != null) const LightLabel(label: 'Name'),
                      if (widget.ticket.user != null) Label(label: widget.ticket.user!.name),
                      if (widget.ticket.user != null) SizedBox(height: context.h * 0.02),
                      if (widget.ticket.status != TicketStatus.AVAILABLE) LightLabel(label: '${Helpers.capitalizeFirstLetter(widget.ticket.status.name)} date'),
                      if (widget.ticket.status != TicketStatus.AVAILABLE) SizedBox(height: context.h * 0.02),
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
                      Label(
                        label: NumberFormat.currency(
                          symbol: '€ ',
                          decimalDigits: 2, // Number of decimal places
                        ).format(widget.ticket.price),
                      ),
                      SizedBox(height: context.h * 0.02),
                      if (widget.ticket.user != null) const LightLabel(label: 'Surname'),
                      if (widget.ticket.user != null) Label(label: widget.ticket.user!.surname)
                    ],
                  ),
                ),
              ],
            ),
            Button.red(text: 'Cancel ticket', width: context.w * 0.35)
          ],
        ),
      ),
    );
  }
}

class LightLabel extends StatelessWidget {
  const LightLabel({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
