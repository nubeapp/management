import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:validator/extensions/extensions.dart';
import 'package:validator/presentation/widgets/button.dart';

class TimePicker extends StatelessWidget {
  const TimePicker({this.selectedHour, super.key});

  final String? selectedHour;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimePickerBloc(selectedHour),
      child: _TimePickerContent(),
    );
  }
}

class _TimePickerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timePickerBloc = context.watch<TimePickerBloc>();
    final selectedHour = timePickerBloc.state;

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
                        timePickerBloc.selectHour('${(row * 4 + col).toString().padLeft(2, '0')}:00');
                      },
                      child: Container(
                        width: context.w * 0.2,
                        height: context.h * 0.06,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              selectedHour == '${(row * 4 + col).toString().padLeft(2, '0')}:00' ? const Color.fromARGB(255, 47, 123, 255) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            '${(row * 4 + col).toString().padLeft(2, '0')}:00',
                            style: TextStyle(
                              color: selectedHour == '${(row * 4 + col).toString().padLeft(2, '0')}:00' ? Colors.white : Colors.black,
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
            selectedHour != null && selectedHour.isNotEmpty
                ? Button.blue(
                    text: 'Select',
                    width: context.w * 0.3,
                    onPressed: () => Navigator.pop(context, selectedHour),
                  )
                : Button.blocked(text: 'Select', width: context.w * 0.3),
          ],
        ),
      ),
    );
  }
}

class TimePickerBloc extends Cubit<String?> {
  TimePickerBloc(String? initialState) : super(initialState);

  void selectHour(String? selectedHour) {
    emit(selectedHour);
  }
}
