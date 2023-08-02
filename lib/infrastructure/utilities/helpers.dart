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

  // 2023-02-14T00:00:00+00:00
  static String convertToDDMMYYYY(String inputDate) {
    try {
      // Parse the input ISO8601 date string into DateTime object
      DateTime dateTime = DateTime.parse(inputDate);

      // Format the date to "dd-MM-yyyy" format
      String formattedDate = "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
      return formattedDate;
    } catch (e) {
      // Handle any exception, e.g., invalid input format
      return "Invalid date format.";
    }
  }

  // 14-02-2023 -> Feb 14, 2023
  static String formatString(String inputDate) {
    try {
      // Split the input string into day, month, and year parts
      List<String> dateParts = inputDate.split('-');
      int day = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);

      // Validate the input date
      if (day <= 0 || day > 31 || month <= 0 || month > 12) {
        throw const FormatException('Invalid date format.');
      }

      // Define a list of month names
      List<String> monthNames = [
        '', // Leave an empty string to align the index with the month number
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];

      // Format the date
      String formattedDate = "${monthNames[month]} ${day.toString().padLeft(2, '0')}, $year";

      return formattedDate;
    } catch (e) {
      // Handle any exception, e.g., invalid input format
      return "Invalid date format.";
    }
  }

  // Tue, 14 of February of 2023 -> Feb 14, 2023
  static String formatDateString(String input) {
    final months = {
      'January': 'Jan',
      'February': 'Feb',
      'March': 'Mar',
      'April': 'Apr',
      'May': 'May',
      'June': 'Jun',
      'July': 'Jul',
      'August': 'Aug',
      'September': 'Sep',
      'October': 'Oct',
      'November': 'Nov',
      'December': 'Dec',
    };

    final parts = input.split(', ');
    if (parts.length != 2) {
      return input; // Return the input string as it is if it doesn't match the expected format
    }

    final day = parts[1].split(' of ')[0];
    final month = parts[1].split(' of ')[1];
    final year = parts[1].split(' of ')[2];

    final abbreviatedMonth = months[month] ?? month;

    return '$abbreviatedMonth $day, $year';
  }

  // Feb 14, 2023 -> 2023-02-14T00:00:000Z
  static String convertToISO8601(String inputDate) {
    try {
      // Define a map to map month names to their respective numbers
      Map<String, String> monthMap = {
        'Jan': '01',
        'Feb': '02',
        'Mar': '03',
        'Apr': '04',
        'May': '05',
        'Jun': '06',
        'Jul': '07',
        'Aug': '08',
        'Sep': '09',
        'Oct': '10',
        'Nov': '11',
        'Dec': '12',
      };

      List<String> dateParts = inputDate.split(' ');
      String month = monthMap[dateParts[0]]!;
      String day = dateParts[1].replaceAll(',', '');
      String year = dateParts[2];

      // Format the date to ISO8601 format
      String isoDate = "$year-$month-${day.padLeft(2, '0')}T00:00:00.000Z";
      return isoDate;
    } catch (e) {
      // Handle any exception, e.g., invalid input format
      return "Invalid date format.";
    }
  }

  // 14-02-2023 -> 02
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

  // 02 -> February
  static String getMonthName(String monthNumberString) {
    int monthNumber = int.tryParse(monthNumberString)!;
    if (monthNumber < 1 || monthNumber > 12) {
      throw ArgumentError('Invalid month number. It should be a string representing an integer between 1 and 12.');
    }

    List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    return months[monthNumber - 1];
  }

  // Feb 14, 2023 -> 2023
  static int getYear(String inputDate) {
    try {
      List<String> dateParts = inputDate.split(' ');
      int year = int.parse(dateParts[2]);
      return year;
    } catch (e) {
      // Handle any exception, e.g., invalid input format
      return 0; // Return 0 or some other appropriate value to indicate an error
    }
  }

  // Feb 14, 2023 -> 2
  static int getMonth(String inputDate) {
    try {
      List<String> dateParts = inputDate.split(' ');
      String monthName = dateParts[0];

      // Define a map to map month names to their respective numbers
      Map<String, int> monthMap = {
        'Jan': 1,
        'Feb': 2,
        'Mar': 3,
        'Apr': 4,
        'May': 5,
        'Jun': 6,
        'Jul': 7,
        'Aug': 8,
        'Sep': 9,
        'Oct': 10,
        'Nov': 11,
        'Dec': 12,
      };

      int month = monthMap[monthName]!;
      return month;
    } catch (e) {
      // Handle any exception, e.g., invalid input format
      return 0; // Return 0 or some other appropriate value to indicate an error
    }
  }

  // Feb 14, 2023 -> 14
  static int getDay(String inputDate) {
    try {
      List<String> dateParts = inputDate.split(' ');
      int day = int.parse(dateParts[1].replaceAll(',', ''));
      return day;
    } catch (e) {
      // Handle any exception, e.g., invalid input format
      return 0; // Return 0 or some other appropriate value to indicate an error
    }
  }
}
