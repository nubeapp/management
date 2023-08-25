import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:validator/domain/entities/event.dart';
import 'package:validator/domain/entities/organization.dart';
import 'package:validator/domain/services/event_service_interface.dart';
import 'package:validator/extensions/extensions.dart';
import 'package:validator/infrastructure/utilities/helpers.dart';
import 'package:validator/presentation/widgets/button.dart';
import 'package:validator/presentation/widgets/custom_app_bar.dart';
import 'package:validator/presentation/widgets/custom_toast.dart';
import 'package:validator/presentation/widgets/input_field.dart';
import 'package:validator/presentation/widgets/label.dart';
import 'package:validator/presentation/widgets/organization_dropdown.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  Organization? _organizationSelected;
  final IEventService _eventService = GetIt.instance<IEventService>();
  bool _isLoading = false;
  final List<List<TextEditingController>> _controllerRows = [];

  void _showCalendarDialog() async {
    DateTime today = DateTime.now();
    int year = today.year;
    int month = today.month;
    int day = today.day;
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
    _addRow();
  }

  void _addRow() {
    setState(() {
      _controllerRows.add([
        TextEditingController(),
        TextEditingController(),
      ]);
    });
  }

  void _removeRow(int rowIndex) {
    setState(() {
      for (var controller in _controllerRows[rowIndex]) {
        controller.dispose();
      }
      _controllerRows.removeAt(rowIndex);
    });
  }

  @override
  void dispose() {
    for (var row in _controllerRows) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Scaffold(
        appBar: CustomAppBar.pop(context: context, title: 'Add event'),
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
                    child: OrganizationDropdown(
                      organizationSelected: _organizationSelected,
                      onOrganizationSelected: _onOrganizationSelected,
                    ),
                  ),
                  SizedBox(height: context.h * 0.04),
                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.black54)
                        : Button.blue(
                            text: 'Add',
                            width: context.w * 0.5,
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (_titleController.text.isEmpty ||
                                  _dateController.text.isEmpty ||
                                  _timeController.text.isEmpty ||
                                  _venueController.text.isEmpty ||
                                  _organizationSelected == null) {
                                CustomToast.showToast(
                                    context: context, message: 'Some data is missing', color: Colors.red, icon: CupertinoIcons.clear, width: context.w * 0.7);
                              } else {
                                setState(() {
                                  _isLoading = true;
                                });
                                Event event = Event(
                                  title: _titleController.text,
                                  date: Helpers.convertToISO8601(_dateController.text),
                                  time: _timeController.text,
                                  venue: _venueController.text,
                                  organizationId: _organizationSelected!.id,
                                );
                                try {
                                  await _eventService.createEvent(event);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  CustomToast.showToast(
                                      context: context,
                                      width: context.w * 0.75,
                                      message: 'Event has been added',
                                      color: Colors.green.withOpacity(0.8),
                                      icon: CupertinoIcons.checkmark_alt_circle);
                                } catch (e) {
                                  setState(() {
                                    _isLoading = false;
                                  });

                                  CustomToast.showToast(
                                      context: context,
                                      width: context.w * 0.75,
                                      message: 'Failed to add event',
                                      color: Colors.red.withOpacity(1),
                                      icon: CupertinoIcons.clear);
                                }
                              }
                            },
                          ),
                  ),
                  // Container(
                  //   width: context.w * 0.9,
                  //   height: context.h * 0.8,
                  //   child: ListView.builder(
                  //     itemCount: _controllerRows.length,
                  //     itemBuilder: (context, rowIndex) {
                  //       return Row(
                  //         children: [
                  //           Expanded(
                  //             child: Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: InputField.text(
                  //                 hintText: '10',
                  //                 controller: _controllerRows[rowIndex][0],
                  //                 onChanged: null,
                  //                 suffixIcon: null,
                  //               ),
                  //             ),
                  //           ),
                  //           Expanded(
                  //             child: Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: InputField.text(
                  //                 hintText: '30€',
                  //                 controller: _controllerRows[rowIndex][1],
                  //                 onChanged: null,
                  //                 suffixIcon: null,
                  //               ),
                  //             ),
                  //           ),
                  //           if (_controllerRows.length > 1) // Only show delete button if there is more than 1 row
                  //             IconButton(
                  //               icon: const Icon(Icons.delete),
                  //               onPressed: () => _removeRow(rowIndex),
                  //             ),
                  //         ],
                  //       );
                  //     },
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
