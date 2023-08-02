import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeDropdown extends StatefulWidget {
  const TimeDropdown({super.key});

  @override
  State<TimeDropdown> createState() => _TimeDropdownState();
}

class _TimeDropdownState extends State<TimeDropdown> {
  final List<String> _options = List.generate(24, (index) => '${index.toString().padLeft(2, '0')}:00');
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedOption,
      onChanged: (newValue) {
        setState(() {
          _selectedOption = newValue;
        });
      },
      items: _options.map(
        (hour) {
          return DropdownMenuItem<String>(
            value: hour,
            child: Text(hour),
          );
        },
      ).toList(),
      isExpanded: true,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16.0,
        letterSpacing: 1.0,
        fontWeight: FontWeight.w500,
      ),
      borderRadius: BorderRadius.circular(15),
      icon: const Icon(CupertinoIcons.chevron_down),
      iconSize: 20,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 17, bottom: 17, left: 15, right: 15),
        hintText: '22:00',
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
      ),
    );
  }
}
