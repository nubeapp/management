import 'package:flutter/material.dart';
import 'package:validator/extensions/extensions.dart';
import 'package:validator/presentation/widgets/button.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({super.key});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  int? _selectedHour;
  Color selectedColor = const Color.fromARGB(255, 47, 123, 255);

  @override
  void initState() {
    super.initState();
  }

  void _dismissWithValue(BuildContext context, dynamic value) {
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int row = 0; row < 6; row++)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int col = 0; col < 4; col++)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedHour = row * 4 + col;
                        });
                      },
                      child: Container(
                        width: context.w * 0.2,
                        height: context.h * 0.06,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _selectedHour == row * 4 + col ? selectedColor : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            '${(row * 4 + col).toString().padLeft(2, '0')}:00',
                            style: TextStyle(
                              color: _selectedHour == row * 4 + col ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            SizedBox(height: context.h * 0.02),
            _selectedHour != null
                ? Button.blue(
                    text: 'Select',
                    width: context.w * 0.3,
                    onPressed: () => _dismissWithValue(context, '${_selectedHour.toString().padLeft(2, '0')}:00'),
                  )
                : Button.blocked(text: 'Select', width: context.w * 0.3)
          ],
        ),
      ),
    );
  }
}
