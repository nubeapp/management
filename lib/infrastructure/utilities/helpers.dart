import 'package:intl/intl.dart';

abstract class Helpers {
  static String dateStringToWeekday(String dateString) {
    DateTime date = DateFormat("dd-MM-yyyy").parse(dateString);
    String abbreviatedWeekday = DateFormat('E').format(date); // E represents the abbreviated weekday name
    return abbreviatedWeekday;
  }

  static int dateStringToDayOfMonth(String dateString) {
    DateTime date = DateFormat("dd-MM-yyyy").parse(dateString);
    int dayOfMonth = date.day;
    return dayOfMonth;
  }

  static String dateTimeToString(DateTime dateTime) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    return formattedDate;
  }

  static String extractMonth(String dateString) {
    // Split the date string by the "-" delimiter
    List<String> dateParts = dateString.split("-");

    // Ensure that the date has at least three parts (day, month, year)
    if (dateParts.length < 3) {
      throw ArgumentError("Invalid date format. Expected format: dd-mm-yyyy");
    }

    // Get the month part (index 1) and return it
    String monthPart = dateParts[1];
    return monthPart;
  }

  static String getMonthName(String monthNumberString) {
    int monthNumber = int.tryParse(monthNumberString)!;
    if (monthNumber < 1 || monthNumber > 12) {
      throw ArgumentError('Invalid month number. It should be a string representing an integer between 1 and 12.');
    }

    List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    return months[monthNumber - 1];
  }
}
