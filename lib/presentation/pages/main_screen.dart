import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validator/domain/entities/credentials.dart';
import 'package:validator/domain/entities/event.dart';
import 'package:validator/domain/entities/token.dart';
import 'package:validator/domain/services/auth_service_interface.dart';
import 'package:validator/domain/services/event_service_interface.dart';
import 'package:validator/extensions/extensions.dart';
import 'package:validator/presentation/pages/validation_screen.dart';

import '../../infrastructure/utilities/helpers.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final String currentMonth = Helpers.extractMonth(Helpers.dateTimeToString(DateTime.now()));

  final _eventService = GetIt.instance<IEventService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // Organize events by year and month
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
                            // Customize the year header appearance here
                          ),
                        ),
                      ),
                    ),
                  ];

                  eventsByMonth.keys.forEach((month) {
                    final events = eventsByMonth[month]!;
                    yearWidgets.add(
                      Column(
                        children: [
                          ListTile(
                            title: Text(
                              Helpers.getMonthName(month),
                              style: currentMonth == month
                                  ? const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 107, 62))
                                  : const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                            ),
                            // You can customize the month header appearance here
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: events.length,
                            itemBuilder: (context, eventIndex) {
                              final event = events[eventIndex];
                              return EventCard(event: event);
                            },
                          ),
                        ],
                      ),
                    );
                  });

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
  const EventCard({required this.event, Key? key}) : super(key: key);

  final Event event;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  final _authService = GetIt.instance<IAuthService>();
  late SharedPreferences _sharedPreferences;
  final String currentDate = Helpers.dateTimeToString(DateTime.now());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _sharedPreferences = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        child: InkWell(
          onTap: () async {
            Token token = await _authService.login(const Credentials(username: 'alvarolopsi@gmail.com', password: 'alvarolopsi'));
            await _sharedPreferences.setString('token', json.encode(token.toJson()));
            Navigator.of(context).push(MaterialPageRoute(
              settings: const RouteSettings(name: '/validator_screen'),
              builder: (context) => ValidationScreen(event: widget.event),
            ));
          },
          splashColor: Colors.black12,
          child: Container(
            height: context.h * 0.1,
            width: context.w - 24,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.black12, width: 2.0),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: context.w * 0.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Helpers.dateStringToWeekday(widget.event.date.toString()),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: widget.event.date.toString() == currentDate ? const Color.fromARGB(255, 255, 107, 62) : Colors.black.withOpacity(0.6),
                        ),
                      ),
                      Text(
                        Helpers.dateStringToDayOfMonth(widget.event.date.toString()).toString(),
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: widget.event.date.toString() == currentDate ? const Color.fromARGB(255, 255, 107, 62) : Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: VerticalDivider(
                    width: 2,
                    thickness: 2,
                    color: Colors.black12,
                  ),
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
          ),
        ),
      ),
    );
  }
}
