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
import 'package:validator/presentation/widgets/custom_app_bar.dart';
import 'package:validator/presentation/widgets/custom_toast.dart';
import 'package:validator/presentation/widgets/input_field.dart';
import 'package:validator/presentation/widgets/label.dart';
import 'package:validator/presentation/widgets/organization_dropdown.dart';

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
  late Organization _organizationSelected;
  final IEventService _eventService = GetIt.instance<IEventService>();
  bool _isLoading = false;

  void _showCalendarDialog() async {
    int year = Helpers.getYear(_dateController.text);
    int month = Helpers.getMonth(_dateController.text);
    int day = Helpers.getDay(_dateController.text);
    final String? result = await Helpers.showCalendar(context: context, year: year, month: month, day: day);

    if (result != null) {
      _dateController.text = result;
    }
  }

  void _showTimePicker() async {
    final String? result = await Helpers.showTimePicker(context: context, selectedHour: _timeController.text);

    if (result != null) {
      _timeController.text = result;
    }
  }

  void _onOrganizationSelected(Organization organization) {
    setState(() {
      _organizationSelected = organization;
    });
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

  Future<void> _deleteEvent() async {
    bool delete = await Helpers.showConfirmDialog(context: context, element: 'event');
    if (delete) {
      try {
        await _eventService.deleteEventById(widget.event.id!);
        Navigator.of(context).pop();
      } catch (e) {
        Logger.error('Failed to delete event and tickets. Exception: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Scaffold(
        appBar: CustomAppBar.popDelete(context: context, title: 'Edit event', actionOnPressed: () async => await _deleteEvent()),
        body: SizedBox(
          // color: Colors.redAccent,
          width: context.w,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
                            onTap: () => _showCalendarDialog(),
                            child: SizedBox(
                              width: context.w * 0.47,
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
                  SizedBox(
                      width: context.w * 0.9,
                      child: OrganizationDropdown(organizationSelected: _organizationSelected, onOrganizationSelected: _onOrganizationSelected)),
                  SizedBox(height: context.h * 0.04),
                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.black54)
                        : Button.blue(
                            text: 'Update',
                            width: context.w * 0.5,
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (_titleController.text.isEmpty ||
                                  _dateController.text.isEmpty ||
                                  _timeController.text.isEmpty ||
                                  _venueController.text.isEmpty) {
                                CustomToast.showToast(
                                    context: context, message: 'Some data is missing', color: Colors.red, icon: CupertinoIcons.clear, width: context.w * 0.7);
                              } else {
                                if (widget.event.title != _titleController.text ||
                                    Helpers.formatString(widget.event.date.toString()) != _dateController.text ||
                                    widget.event.time != _timeController.text ||
                                    widget.event.venue != _venueController.text ||
                                    widget.event.organization != _organizationSelected) {
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
                                    await _eventService.updateEventById(widget.event.id!, updatedEvent);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    CustomToast.showToast(
                                        context: context,
                                        width: context.w * 0.75,
                                        message: 'Event has been updated',
                                        color: Colors.green.withOpacity(0.8),
                                        icon: CupertinoIcons.checkmark_alt_circle);
                                  } catch (e) {
                                    setState(() {
                                      _isLoading = false;
                                    });

                                    CustomToast.showToast(
                                        context: context,
                                        width: context.w * 0.75,
                                        message: 'Failed to update event',
                                        color: Colors.red.withOpacity(1),
                                        icon: CupertinoIcons.clear);
                                  }
                                } else {
                                  CustomToast.showToast(
                                      context: context,
                                      width: context.w * 0.8,
                                      message: 'No data has been updated',
                                      color: Colors.orange.withOpacity(1),
                                      icon: CupertinoIcons.exclamationmark_triangle);
                                }
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
