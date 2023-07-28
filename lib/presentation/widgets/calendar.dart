import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validator/extensions/extensions.dart';
import 'package:validator/presentation/styles/logger.dart';
import 'package:validator/presentation/widgets/button.dart';

class CalendarData {
  // Returns the total number of days in a month
  int getDaysInMonth(int year, int month) {
    if (month == 2) {
      if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
        return 29; // Leap year
      } else {
        return 28;
      }
    } else if ([4, 6, 9, 11].contains(month)) {
      return 30;
    } else {
      return 31;
    }
  }

  // Returns the weekday of the first day of the month (0 - Sunday, 1 - Monday, ...)
  int getFirstWeekdayOfMonth(int year, int month) {
    int weekday = DateTime(year, month, 1).weekday - 1;
    return weekday < 0 ? 6 : weekday;
  }

  // Returns a 2D list representing the calendar days for the given year and month
  List<List<int>> getCalendarDays(int year, int month) {
    int daysInMonth = getDaysInMonth(year, month);
    int firstWeekday = getFirstWeekdayOfMonth(year, month);

    int day = 1;
    List<List<int>> calendar = List.generate(6, (_) => List.filled(7, 0));

    for (int row = 0; row < 6; row++) {
      for (int col = 0; col < 7; col++) {
        if (row == 0 && col < firstWeekday) {
          // Empty cells before the first day of the month
          continue;
        } else if (day > daysInMonth) {
          // All days of the month have been added
          break;
        } else {
          calendar[row][col] = day;
          day++;
        }
      }
    }

    return calendar;
  }
}

class Calendar extends StatefulWidget {
  final int year;
  final int month;

  const Calendar({super.key, required this.year, required this.month});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late int _currentYear;
  late int _currentMonth;
  int? _selectedDay;
  int? _selectedYear;
  String? _selectedWeekday;
  late String _currentMonthName;
  Color selectedColor = const Color.fromARGB(255, 47, 123, 255);

  @override
  void initState() {
    super.initState();
    _currentYear = widget.year;
    _currentMonth = widget.month;
    _currentMonthName = getMonthName(_currentMonth);
  }

  void _nextMonth() {
    if (_currentMonth == 12) {
      setState(() {
        _currentYear++;
        _currentMonth = 1;
      });
    } else {
      setState(() {
        _currentMonth++;
      });
    }
  }

  void _previousMonth() {
    if (_currentMonth == 1) {
      setState(() {
        _currentYear--;
        _currentMonth = 12;
      });
    } else {
      setState(() {
        _currentMonth--;
      });
    }
  }

  final CalendarData _data = CalendarData();

  void _onDayPressed(int day) {
    setState(() {
      _selectedDay = day;
      _selectedYear = _currentYear;
      _currentMonthName = getMonthName(_currentMonth);
      _selectedWeekday = getWeekdayName(DateTime(_currentYear, _currentMonth, day).weekday - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<List<int>> days = _data.getCalendarDays(_currentYear, _currentMonth);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(CupertinoIcons.left_chevron),
              onPressed: _previousMonth,
            ),
            Text(
              "${getMonthName(_currentMonth)} $_currentYear",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.right_chevron),
              onPressed: _nextMonth,
            ),
          ],
        ),
        Divider(color: Colors.black26, indent: context.w * 0.01, endIndent: context.w * 0.01),
        Row(
          children: List.generate(
            7,
            (index) => Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: context.h * 0.01),
                  child: Text(
                    getWeekdayName(index),
                    style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.black54),
                  ),
                ),
              ),
            ),
          ),
        ),
        ...days.map((week) => buildWeekRow(week)).toList(),
        _selectedDay != null
            ? Button.blue(
                text: 'Select', width: context.w * 0.3, onPressed: () => Logger.debug('$_selectedWeekday, $_selectedDay of $_currentMonthName $_selectedYear'))
            : Button.blocked(text: 'Select', width: context.w * 0.3)
        // if (_selectedDay != null) // Display the selected day and month
        //   Container(
        //     padding: const EdgeInsets.symmetric(vertical: 16),
        //     child: Text(
        //       "Selected day: $_selectedWeekday, $_selectedDay of $_currentMonthName $_selectedYear",
        //       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //     ),
        //   ),
      ],
    );
  }

  String getMonthName(int month) {
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }

  String getWeekdayName(int weekday) {
    // Adjust the index to start from Monday (0 - Monday, 1 - Tuesday, ...)
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday];
  }

  Widget buildWeekRow(List<int> week) {
    return Row(
      children: week.map((day) => buildDayCell(day)).toList(),
    );
  }

  Widget buildDayCell(int? day) {
    final isSelectedDay = day == _selectedDay;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (day != null && day > 0) {
            _onDayPressed(day);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            decoration: BoxDecoration(
                color:
                    isSelectedDay && (_currentMonthName == getMonthName(_currentMonth)) && (_currentYear == _selectedYear) ? selectedColor : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Text(
              day != null && day > 0 ? day.toString() : '',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: isSelectedDay && (_currentMonthName == getMonthName(_currentMonth)) && (_currentYear == _selectedYear) ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
