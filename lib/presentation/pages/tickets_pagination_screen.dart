import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:validator/domain/entities/event.dart';
import 'package:validator/domain/entities/ticket/ticket.dart';
import 'package:validator/domain/entities/ticket/ticket_summary.dart';
import 'package:validator/domain/services/ticket_service_interface.dart';
import 'package:validator/extensions/extensions.dart';
import 'package:validator/infrastructure/utilities/helpers.dart';
import 'package:validator/presentation/pages/pages.dart';
import 'package:validator/presentation/styles/logger.dart';
import 'package:validator/presentation/widgets/custom_app_bar.dart';
import 'package:validator/presentation/widgets/input_field.dart';
import 'package:validator/presentation/widgets/label.dart';
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

  void _updateStateAfterPop() {
    _searchController.text = '';
    _onStatusSelected(_selectedStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.pop(context: context, title: 'Tickets'),
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
            if (_count > 0) const HeaderTicketsListView(),
            FutureBuilder<TicketSummary>(
              future: _tickets,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final ticketSummary = snapshot.data!;
                  if (ticketSummary.tickets.isNotEmpty) {
                    return Expanded(
                      child: TicketsListView(
                        tickets: ticketSummary.tickets,
                        scrollController: _scrollController,
                        updateState: _updateStateAfterPop,
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error fetching tickets'),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.only(top: context.h * 0.2),
                    child: const CircularProgressIndicator(color: Colors.black87),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderTicketsListView extends StatelessWidget {
  const HeaderTicketsListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Label(label: 'Reference'),
          SizedBox(width: context.w * 0.36),
          const Label(label: 'Status'),
        ],
      ),
    );
  }
}

class TicketsListView extends StatelessWidget {
  const TicketsListView({
    Key? key,
    required this.tickets,
    required this.scrollController,
    required this.updateState,
  }) : super(key: key);

  final List<Ticket> tickets;
  final ScrollController scrollController;
  final VoidCallback updateState;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              final bool result = await Navigator.of(context).push(MaterialPageRoute(
                settings: const RouteSettings(name: '/ticket_info_screen'),
                builder: (context) => TicketInfoScreen(
                  ticket: tickets[index],
                ),
              ));
              if (result) {
                updateState();
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
                    child: Helpers.getStatusLabelFromTicketStatus(tickets[index].status),
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
