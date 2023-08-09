import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:validator/domain/entities/event.dart';
import 'package:validator/domain/services/event_service_interface.dart';
import 'package:validator/extensions/extensions.dart';
import 'package:validator/presentation/pages/pages.dart';
import 'package:validator/presentation/styles/logger.dart';
import 'package:validator/presentation/widgets/border_button.dart';
import 'package:validator/presentation/widgets/button.dart';

import '../../infrastructure/utilities/helpers.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final String currentMonth = Helpers.extractMonth(Helpers.dateTimeToString(DateTime.now()));

  final _eventService = GetIt.instance<IEventService>();

  // Callback function to update the state in the parent widget
  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget customAppBar() => AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            padding: const EdgeInsets.only(left: 16),
            icon: const Icon(
              CupertinoIcons.person,
              size: 26,
              color: Colors.black87,
            ),
            onPressed: () {
              Logger.debug('profile');
            },
          ),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Button.black(
              text: 'Add event',
              width: context.w * 0.3,
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(
                    settings: const RouteSettings(name: '/add_event_screen'),
                    builder: (context) => const AddEventScreen(),
                  ))
                  .then((_) => updateState()),
            ),
          ),
        );
    return Scaffold(
      appBar: customAppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<List<Event>>(
          future: _eventService.getEvents(),
          builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white70,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final eventsByYearAndMonth = <String, Map<String, List<Event>>>{};
              for (final event in snapshot.data!) {
                final dateParts = event.date.toString().split('-');
                final year = dateParts[2];
                final month = dateParts[1];

                eventsByYearAndMonth.putIfAbsent(year, () => {});
                eventsByYearAndMonth[year]!.putIfAbsent(month, () => []);
                eventsByYearAndMonth[year]![month]!.add(event);
              }

              return ListView.builder(
                itemCount: eventsByYearAndMonth.length,
                itemBuilder: (context, yearIndex) {
                  final year = eventsByYearAndMonth.keys.toList()[yearIndex];
                  final eventsByMonth = eventsByYearAndMonth[year]!;

                  List<Widget> yearWidgets = [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Center(
                        child: Text(
                          year,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ];

                  for (var month in eventsByMonth.keys) {
                    final events = eventsByMonth[month]!;
                    yearWidgets.add(
                      Column(
                        children: [
                          ListTile(
                            title: Text(
                              Helpers.getMonthName(month),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: events.length,
                            itemBuilder: (context, eventIndex) {
                              final event = events[eventIndex];
                              return EventCard(event: event, onDataUpdate: updateState);
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: yearWidgets,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class EventCard extends StatefulWidget {
  const EventCard({required this.event, required this.onDataUpdate, Key? key}) : super(key: key);

  final Event event;
  final Function() onDataUpdate;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  final String currentDate = Helpers.dateTimeToString(DateTime.now());
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        child: InkWell(
          onTap: () async {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          splashColor: Colors.black12,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: isExpanded ? context.h * 0.175 : context.h * 0.1,
            width: context.w - 24,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.black12, width: 2.0),
            ),
            child: ClipRRect(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: context.w * 0.2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  Helpers.dateStringToWeekday(widget.event.date.toString()),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        widget.event.date.toString() == currentDate ? const Color.fromARGB(255, 255, 107, 62) : Colors.black.withOpacity(0.6),
                                  ),
                                ),
                                Text(
                                  Helpers.dateStringToDayOfMonth(widget.event.date.toString()).toString(),
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        widget.event.date.toString() == currentDate ? const Color.fromARGB(255, 255, 107, 62) : Colors.black.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: context.h * 0.015),
                              child: Container(
                                alignment: Alignment.topCenter,
                                height: context.h * 0.065,
                                width: 2,
                                color: Colors.black12,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: context.w * 0.64,
                                child: Text(
                                  widget.event.title,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black.withOpacity(0.7)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: context.h * 0.015),
                              SizedBox(
                                width: context.w * 0.72 - 32,
                                child: Row(
                                  children: [
                                    const Icon(
                                      CupertinoIcons.clock,
                                      size: 16,
                                    ),
                                    SizedBox(
                                      width: context.w * 0.015,
                                    ),
                                    Text(
                                      widget.event.time,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
                                    ),
                                    SizedBox(width: context.w * 0.1),
                                    const Icon(
                                      CupertinoIcons.placemark,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: context.w * 0.005,
                                    ),
                                    SizedBox(
                                      width: context.w * 0.28,
                                      child: Text(
                                        widget.event.venue,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Visibility(
                      visible: isExpanded,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Button.black(
                                text: 'Validate',
                                width: context.w * 0.27,
                                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                                      settings: const RouteSettings(name: '/validator_screen'),
                                      builder: (context) => ValidationScreen(event: widget.event),
                                    ))),
                            Button.black(
                              text: 'Edit',
                              width: context.w * 0.27,
                              onPressed: () => Navigator.of(context)
                                  .push(MaterialPageRoute(
                                    settings: const RouteSettings(name: '/edit_event_screen'),
                                    builder: (context) => EditEventScreen(event: widget.event),
                                  ))
                                  .then((_) => widget.onDataUpdate()),
                            ),
                            Button.black(
                              text: 'Tickets',
                              width: context.w * 0.27,
                              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                                settings: const RouteSettings(name: '/tickets_screen'),
                                builder: (context) => TicketsScreen(event: widget.event),
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
