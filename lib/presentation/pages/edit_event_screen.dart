import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validator/domain/entities/event.dart';
import 'package:validator/extensions/extensions.dart';
import 'package:validator/presentation/styles/logger.dart';
import 'package:validator/presentation/widgets/button.dart';
import 'package:validator/presentation/widgets/calendar.dart';

class EditEventScreen extends StatelessWidget {
  EditEventScreen({required this.event, super.key});

  final Event event;
  final TextEditingController _titleController = TextEditingController();

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Label(label: 'Event name'),
                InputField.text(
                  hintText: 'Bad Bunny en concierto...',
                  textInputAction: TextInputAction.next,
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
                        SizedBox(
                          width: context.w * 0.45,
                          child: InputField.text(
                            hintText: 'Feb 14, 2023',
                            textInputAction: TextInputAction.next,
                            controller: TextEditingController(),
                            onChanged: (value) => Logger.debug('onChanged'),
                            suffixIcon: CupertinoIcons.calendar,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Label(label: 'Time'),
                        SizedBox(
                          width: context.w * 0.35,
                          child: InputField.text(
                            hintText: '22:00',
                            textInputAction: TextInputAction.next,
                            controller: TextEditingController(),
                            onChanged: (value) => Logger.debug('onChanged'),
                            suffixIcon: CupertinoIcons.clock,
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
                  textInputAction: TextInputAction.done,
                  controller: TextEditingController(),
                  onChanged: (value) => Logger.debug('onChanged'),
                  suffixIcon: null,
                ),
                SizedBox(height: context.h * 0.04),
                Center(child: Button.blue(text: 'Update', width: context.w * 0.5)),
                // SizedBox(
                //   width: context.w * 0.8,
                //   child: const Calendar(month: 7, year: 2023),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Label extends StatelessWidget {
  const Label({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w600,
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
  }) : super(key: key);

  const InputField.text({
    Key? key,
    required this.hintText,
    required this.textInputAction,
    required this.controller,
    required this.onChanged,
    required this.suffixIcon,
  })  : obscureText = false,
        keyboardType = TextInputType.text,
        super(key: key);

  const InputField.password({
    Key? key,
    required this.hintText,
    required this.textInputAction,
    required this.controller,
    required this.onChanged,
    required this.suffixIcon,
  })  : obscureText = true,
        keyboardType = TextInputType.text,
        super(key: key);

  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final Function(String) onChanged;
  final IconData? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
          suffixIcon: IconButton(
            icon: Icon(suffixIcon),
            onPressed: () => Logger.debug('show calendar'),
          )),
      cursorColor: Colors.black87,
      cursorHeight: 16.0,
      style: const TextStyle(color: Colors.black87, fontSize: 16.0, letterSpacing: 1.0, fontWeight: FontWeight.w500),
    );
  }
}
