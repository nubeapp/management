import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:validator/domain/entities/event.dart';
import 'package:validator/domain/entities/ticket/ticket_navigation.dart';
import 'package:validator/domain/entities/ticket/ticket_status.dart';
import 'package:validator/domain/entities/ticket/ticket_summary.dart';
import 'package:validator/domain/entities/ticket/ticket.dart';
import 'package:validator/domain/services/ticket_service_interface.dart';
import 'package:validator/extensions/extensions.dart';
import 'package:validator/presentation/pages/pages.dart';
import 'package:validator/presentation/styles/logger.dart';
import 'package:validator/presentation/widgets/input_field.dart';
import 'package:validator/presentation/widgets/label.dart';
import 'package:validator/presentation/widgets/status_label.dart';
import 'package:validator/presentation/widgets/ticket_status_dropdown.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key, required this.event});

  final Event event;

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  final _searchController = TextEditingController();
  final _ticketService = GetIt.instance<ITicketService>();
  final _searchStreamController = StreamController<String>();
  final _debounceTime = const Duration(milliseconds: 500);
  StreamSubscription<String>? _searchSubscription;

  List<Ticket> _tickets = [];
  List<Ticket> _filteredTickets = [];
  String _selectedStatus = 'ALL';

  @override
  void initState() {
    super.initState();
    _fetchTickets();
    _searchSubscription = _searchStreamController.stream.distinct().debounceTime(_debounceTime).listen((searchText) {
      _updateListView(searchText);
    });
  }

  @override
  void dispose() {
    _searchSubscription?.cancel();
    _searchStreamController.close();
    super.dispose();
  }

  Future<void> _fetchTickets() async {
    try {
      final TicketSummary ticketSummary = await _ticketService.getTicketsByEventId(eventId: widget.event.id!, limit: 100, offset: 0);
      setState(() {
        _tickets = ticketSummary.tickets;
        _updateListView(_searchController.text);
      });
    } catch (e) {
      // Handle error
      Logger.error('Error fetching tickets: $e');
    }
  }

  void _onSearchTextChanged(String text) {
    _searchStreamController.add(text);
  }

  void _updateListView(String searchText) {
    final filteredTickets = _tickets.where((ticket) {
      bool matchesSearchText = ticket.reference.startsWith(searchText.toUpperCase());
      bool matchesStatus = _selectedStatus == 'ALL' || ticket.status.name == _selectedStatus;

      return matchesSearchText && matchesStatus;
    }).toList();

    setState(() {
      _filteredTickets = filteredTickets;
    });
  }

  void _onStatusSelected(String status) {
    setState(() {
      _selectedStatus = status;
    });
    _updateListView(_searchController.text);
  }

  // Callback function to update the state in the parent widget
  void updateState({required int ticketId}) async {
    _tickets.removeWhere((ticket) => ticket.id == ticketId);
    _filteredTickets.removeWhere((ticket) => ticket.id == ticketId);
    setState(() {});
    // await _fetchTickets();
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

  PreferredSizeWidget _customAppBar() => AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Tickets',
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
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: context.w - 48,
                    child: InputField.text(
                      hintText: 'F3EWNIFHR87NY37843IN',
                      controller: _searchController,
                      suffixIcon: CupertinoIcons.search,
                      onChanged: _onSearchTextChanged,
                    ),
                  ),
                ],
              ),
            ),
            TicketStatusDropdown(onStatusSelected: _onStatusSelected),
            SizedBox(height: context.h * 0.02),
            Text(
              '${_filteredTickets.length.toString()} results have been found',
              style: const TextStyle(color: Colors.black38, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            if (_filteredTickets.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Label(label: 'Reference'),
                    SizedBox(width: context.w * 0.36),
                    const Label(label: 'Status'),
                  ],
                ),
              ),
            Expanded(
              child: ListView.separated(
                itemCount: _filteredTickets.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 8,
                  thickness: 2,
                  color: Colors.black12,
                ),
                itemBuilder: (context, index) => Material(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      final navigationResult = await Navigator.of(context).push(MaterialPageRoute(
                        settings: const RouteSettings(name: '/ticket_info_screen'),
                        builder: (context) => TicketInfoScreen(
                          ticket: _filteredTickets[index],
                        ),
                      ));

                      if (navigationResult is TicketNavigation) {
                        if (navigationResult.ticket != null) {
                          updateState(ticketId: navigationResult.ticket!.id!);
                        }
                        if (navigationResult.cancel) {
                          _fetchTickets();
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Row(
                        children: [
                          Container(
                            width: context.w * 0.5,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _filteredTickets[index].reference,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.65),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Container(
                            width: context.w * 0.33,
                            alignment: Alignment.center,
                            child: getStatusLabelFromTicketStatus(_filteredTickets[index]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
