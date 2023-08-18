import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:validator/domain/entities/event.dart';
import 'package:validator/domain/entities/ticket/ticket.dart';
import 'package:validator/domain/entities/ticket/ticket_status.dart';
import 'package:validator/domain/entities/ticket/ticket_summary.dart';
import 'package:validator/domain/services/ticket_service_interface.dart';
import 'package:validator/extensions/extensions.dart';
import 'package:validator/presentation/pages/pages.dart';
import 'package:validator/presentation/styles/logger.dart';
import 'package:validator/presentation/widgets/input_field.dart';
import 'package:validator/presentation/widgets/label.dart';
import 'package:validator/presentation/widgets/status_label.dart';
import 'package:validator/presentation/widgets/ticket_status_dropdown.dart';

class TicketsPaginationScreen extends StatefulWidget {
  const TicketsPaginationScreen({super.key, required this.event});

  final Event event;

  @override
  State<TicketsPaginationScreen> createState() => _TicketsPaginationScreenState();
}

class _TicketsPaginationScreenState extends State<TicketsPaginationScreen> {
  final ITicketService _ticketService = GetIt.instance<ITicketService>();
  late Future<TicketSummary> _tickets;
  int _limit = 10;
  int _offset = 0;
  bool _isLoading = false;
  bool _ticketsRemaining = true;
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final _searchStreamController = StreamController<String>();
  String _selectedStatus = 'ALL';
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _tickets = _fetchInitialTickets();
    _scrollController.addListener(_scrollListener);
    _searchStreamController.stream.debounceTime(const Duration(milliseconds: 500)).listen((searchText) {
      _onSearchDebounced(searchText);
    });
  }

  @override
  void dispose() {
    // Dispose the scroll controller when the widget is disposed
    _scrollController.dispose();
    super.dispose();
  }

  Future<TicketSummary> _fetchInitialTickets() async {
    final tickets = await _ticketService.getTicketsByEventId(eventId: widget.event.id!, limit: _limit, offset: _offset);
    setState(() {
      _count = tickets.count;
    });
    return tickets;
  }

  Future<void> _fetchMoreTickets() async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      _offset += _limit;
      final TicketSummary nextTickets;
      if (_selectedStatus != 'ALL') {
        nextTickets = await _ticketService.getTicketsByEventId(eventId: widget.event.id!, limit: _limit, offset: _offset, status: _selectedStatus);
      } else {
        nextTickets = await _ticketService.getTicketsByEventId(eventId: widget.event.id!, limit: _limit, offset: _offset);
      }

      if (nextTickets.tickets.length < _limit) {
        _ticketsRemaining = false;
      }
      final allTickets = await _tickets;

      // Append the new tickets to the existing list
      allTickets.tickets.addAll(nextTickets.tickets);

      setState(() {
        _tickets = Future.value(allTickets);
        _isLoading = false;
      });
    } catch (e) {
      // Handle the error
      Logger.error('Error loading next tickets: ${e.toString()}');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scrollListener() {
    // Check if the user has reached the bottom of the scroll
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent - 30 && !_scrollController.position.outOfRange) {
      if (_ticketsRemaining) {
        _fetchMoreTickets();
      }
    }
  }

  void _onStatusSelected(String status) async {
    _limit = 10;
    _offset = 0;
    _ticketsRemaining = true;
    _selectedStatus = status;
    final TicketSummary tickets;
    if (status != 'ALL') {
      tickets = await _ticketService.getTicketsByEventId(
          eventId: widget.event.id!, limit: _limit, offset: _offset, status: _selectedStatus, filter: _searchController.text.toUpperCase());
    } else {
      tickets =
          await _ticketService.getTicketsByEventId(eventId: widget.event.id!, limit: _limit, offset: _offset, filter: _searchController.text.toUpperCase());
    }
    setState(() {
      _count = tickets.count;
      _tickets = Future.value(tickets);
    });
  }

  void _onSearchTextChanged(String text) {
    _searchStreamController.add(text);
  }

  void _onSearchDebounced(String searchText) async {
    final TicketSummary tickets;
    if (_selectedStatus != 'ALL') {
      tickets = await _ticketService.getTicketsByEventId(
        eventId: widget.event.id!,
        limit: _limit,
        offset: _offset,
        status: _selectedStatus,
        filter: searchText.toUpperCase(),
      );
    } else {
      tickets = await _ticketService.getTicketsByEventId(
        eventId: widget.event.id!,
        limit: _limit,
        offset: _offset,
        filter: searchText.toUpperCase(),
      );
    }

    setState(() {
      _count = tickets.count;
      _tickets = Future.value(tickets);
    });
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
              '$_count results have been found',
              style: const TextStyle(color: Colors.black38, fontSize: 16, fontWeight: FontWeight.w500),
            ),
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
            FutureBuilder<TicketSummary>(
              future: _tickets,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final ticketSummary = snapshot.data!;
                  if (ticketSummary.tickets.isNotEmpty) {
                    return Expanded(child: TicketsListView(tickets: ticketSummary.tickets, scrollController: _scrollController));
                  } else {
                    return const Center(
                      child: Text(
                        '☹️ There are no tickets...',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error fetching tickets'),
                  );
                } else {
                  return const CircularProgressIndicator(color: Colors.black87);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TicketsListView extends StatelessWidget {
  const TicketsListView({
    Key? key,
    required this.tickets,
    required this.scrollController,
  }) : super(key: key);

  final List<Ticket> tickets;
  final ScrollController scrollController;

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
    return Container(
      width: context.w,
      height: context.h * 0.7,
      child: ListView.separated(
        controller: scrollController,
        itemCount: tickets.length,
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
                  ticket: tickets[index],
                ),
              ));

              // if (navigationResult is TicketNavigation) {
              //   if (navigationResult.ticket != null) {
              //     updateState(ticketId: navigationResult.ticket!.id!);
              //   }
              //   if (navigationResult.cancel) {
              //     _fetchTickets();
              //   }
              // }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Row(
                children: [
                  Container(
                    width: context.w * 0.5,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      tickets[index].reference,
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
                    child: getStatusLabelFromTicketStatus(tickets[index]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
