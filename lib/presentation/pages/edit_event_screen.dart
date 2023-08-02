import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:validator/domain/entities/event.dart';
import 'package:validator/domain/entities/organization.dart';
import 'package:validator/domain/services/event_service_interface.dart';
import 'package:validator/extensions/extensions.dart';
import 'package:validator/infrastructure/utilities/helpers.dart';
import 'package:validator/presentation/styles/logger.dart';
import 'package:validator/presentation/widgets/button.dart';
import 'package:validator/presentation/widgets/calendar.dart';
import 'package:validator/presentation/widgets/input_field.dart';
import 'package:validator/presentation/widgets/label.dart';
import 'package:validator/presentation/widgets/organization_dropdown.dart';
import 'package:validator/presentation/widgets/time_picker.dart';

class EditEventScreen extends StatefulWidget {
  const EditEventScreen({required this.event, super.key});

  final Event event;

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  late final Organization _organizationSelected;
  final IEventService _eventService = GetIt.instance<IEventService>();
  bool _isLoading = false;

  void _showCalendar() async {
    int year = Helpers.getYear(_dateController.text);
    int month = Helpers.getMonth(_dateController.text);
    int day = Helpers.getDay(_dateController.text);
    final String? result = await showDialog(
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
                height: context.h * 0.5,
                child: Calendar(year: year, month: month, day: day),
              ),
            ),
          ),
        );
      },
    );

    if (result != null) {
      Logger.debug(result);
      _dateController.text = result;
    }
  }

  void _showTimePicker() async {
    final String? result = await showDialog(
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
                height: context.h * 0.48,
                child: TimePicker(
                  selectedHour: _timeController.text,
                ),
              ),
            ),
          ),
        );
      },
    );

    if (result != null) {
      _timeController.text = result;
    }
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.event.title;
    _dateController.text = Helpers.formatString(widget.event.date.toString());
    _timeController.text = widget.event.time;
    _venueController.text = widget.event.venue;
    _organizationSelected = widget.event.organization!;
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget customAppBar() => AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Edit event',
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
    return Scaffold(
      appBar: customAppBar(),
      body: Container(
        // color: Colors.redAccent,
        width: context.w,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Container(
            // color: Colors.greenAccent,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Label(label: 'Name'),
                  InputField.text(
                    hintText: 'Bad Bunny en concierto...',
                    controller: _titleController,
                    onChanged: (value) => null,
                    suffixIcon: null,
                  ),
                  SizedBox(height: context.h * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Label(label: 'Date'),
                          GestureDetector(
                            onTap: () => _showCalendar(),
                            child: SizedBox(
                              width: context.w * 0.45,
                              child: InputField.disabled(
                                hintText: 'Feb 14, 2023',
                                controller: _dateController,
                                suffixIcon: CupertinoIcons.calendar,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Label(label: 'Time'),
                          // SizedBox(width: context.w * 0.35, child: TimeDropdown()),
                          GestureDetector(
                            onTap: () => _showTimePicker(),
                            child: SizedBox(
                              width: context.w * 0.35,
                              child: InputField.disabled(
                                hintText: '22:00',
                                controller: _timeController,
                                suffixIcon: CupertinoIcons.clock,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: context.h * 0.02),
                  const Label(label: 'Venue'),
                  InputField.text(
                    hintText: 'Wizink Center',
                    controller: _venueController,
                    onChanged: (value) => null,
                    suffixIcon: null,
                  ),
                  SizedBox(height: context.h * 0.02),
                  const Label(label: 'Organization'),
                  SizedBox(width: context.w * 0.9, child: OrganizationDropdown(organizationSelected: _organizationSelected)),
                  SizedBox(height: context.h * 0.04),
                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.black54)
                        : Button.blue(
                            text: 'Update',
                            width: context.w * 0.5,
                            onPressed: () async {
                              // Set the loading state to true
                              setState(() {
                                _isLoading = true;
                              });

                              Event updatedEvent = Event(
                                title: _titleController.text,
                                date: Helpers.convertToISO8601(_dateController.text),
                                time: _timeController.text,
                                venue: _venueController.text,
                                organizationId: _organizationSelected.id,
                              );

                              try {
                                await Future.delayed(const Duration(milliseconds: 2000));
                                await _eventService.updateEventById(widget.event.id!, updatedEvent);
                                // If the update is successful, set the loading state to false
                                setState(() {
                                  _isLoading = false;
                                });
                                CustomToast.showToast(context, 'Event has been updated!');
                                // Navigator.of(context).pop(updatedEvent);
                              } catch (e) {
                                // If there's an error during update, set the loading state to false
                                setState(() {
                                  _isLoading = false;
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to update event. Please try again.'),
                                  ),
                                );
                              }
                            },
                          ),
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

class CustomToast extends StatelessWidget {
  final String message;

  const CustomToast({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  static void showToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).size.height * 0.3,
        left: 0,
        right: 0,
        child: CustomToast(message: message),
      ),
    );

    overlay!.insert(overlayEntry);

    // Remove the toast after a certain duration
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
