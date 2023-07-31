import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validator/domain/entities/event.dart';
import 'package:validator/extensions/extensions.dart';
import 'package:validator/presentation/styles/logger.dart';
import 'package:validator/presentation/widgets/button.dart';
import 'package:validator/presentation/widgets/calendar.dart';
import 'package:validator/presentation/widgets/label.dart';
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

  void _showCalendar() async {
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
                child: const Calendar(year: 2023, month: 7),
              ),
            ),
          ),
        );
      },
    );

    if (result != null) {
      Logger.debug('Dialog dismissed with value: $result');
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
                child: const TimePicker(),
              ),
            ),
          ),
        );
      },
    );

    if (result != null) {
      Logger.debug('Dialog dismissed with value: $result');
      _timeController.text = result;
    }
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
                  const Label(label: 'Event name'),
                  InputField.text(
                    hintText: 'Bad Bunny en concierto...',
                    controller: _titleController,
                    onChanged: (value) => Logger.debug('onChanged'),
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
                                suffixIconAction: () => _showCalendar(),
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
                                suffixIconAction: () => Logger.debug('show clock'),
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
                    controller: TextEditingController(),
                    onChanged: (value) => Logger.debug('onChanged'),
                    suffixIcon: null,
                  ),
                  SizedBox(height: context.h * 0.04),
                  Center(
                    child: Button.blue(
                      text: 'Update',
                      width: context.w * 0.5,
                      onPressed: () => Logger.debug('update'),
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

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.hintText,
    required this.keyboardType,
    required this.obscureText,
    required this.textInputAction,
    required this.controller,
    required this.onChanged,
    required this.suffixIcon,
    required this.suffixIconAction,
    required this.enabled,
  }) : super(key: key);

  const InputField.text({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    required this.suffixIcon,
  })  : obscureText = false,
        keyboardType = TextInputType.text,
        suffixIconAction = null,
        enabled = true,
        textInputAction = TextInputAction.done,
        super(key: key);

  const InputField.password({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    required this.suffixIcon,
  })  : obscureText = true,
        keyboardType = TextInputType.text,
        textInputAction = TextInputAction.done,
        suffixIconAction = null,
        enabled = true,
        super(key: key);

  const InputField.disabled({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.suffixIcon,
    required this.suffixIconAction,
  })  : keyboardType = TextInputType.none,
        obscureText = false,
        textInputAction = TextInputAction.done,
        onChanged = null,
        enabled = false,
        super(key: key);

  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function()? suffixIconAction;
  final IconData? suffixIcon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      onChanged: onChanged,
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textAlignVertical: TextAlignVertical.center,
      enableSuggestions: false,
      autocorrect: false,
      enableInteractiveSelection: false,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 15.0),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.7,
          color: Colors.black.withOpacity(0.3),
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 240, 240, 240),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 47, 123, 255),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: Icon(
          suffixIcon,
          color: Colors.black.withOpacity(0.7),
        ),
      ),
      cursorColor: Colors.black87,
      cursorHeight: 16.0,
      style: const TextStyle(color: Colors.black87, fontSize: 16.0, letterSpacing: 1.0, fontWeight: FontWeight.w500),
    );
  }
}
