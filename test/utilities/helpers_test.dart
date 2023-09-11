import 'package:flutter_test/flutter_test.dart';
import 'package:validator/infrastructure/utilities/helpers.dart';

void main() {
  group('Helpers', () {
    test('dateStringToWeekday should return the correct weekday', () {
      expect(Helpers.dateStringToWeekday('14-02-2023'), 'Tue');
    });

    test('dateStringToDayOfMonth should return the correct day of the month', () {
      expect(Helpers.dateStringToDayOfMonth('14-02-2023'), 14);
    });

    test('dateTimeToString should return the correct formatted date', () {
      final dateTime = DateTime(2023, 2, 14);
      expect(Helpers.dateTimeToString(dateTime), '14-02-2023');
    });

    test('convertToDDMMYYYY should return the correct formatted date', () {
      expect(Helpers.convertToDDMMYYYY('2023-02-14T00:00:00+00:00'), '14-02-2023');
    });

    test('formatString should return the correct formatted date', () {
      expect(Helpers.formatString('14-02-2023'), 'Feb 14, 2023');
    });

    test('formatDateString should return the correct formatted date', () {
      expect(Helpers.formatDateString('Tue, 14 of February of 2023'), 'Feb 14, 2023');
    });

    test('convertToISO8601 should return the correct ISO8601 formatted date', () {
      expect(Helpers.convertToISO8601('Feb 14, 2023'), '2023-02-14T00:00:00.000Z');
    });

    test('extractMonth should return the correct month', () {
      expect(Helpers.extractMonth('14-02-2023'), '02');
    });

    test('getMonthName should return the correct month name', () {
      expect(Helpers.getMonthName('02'), 'February');
    });

    test('getYear should return the correct year', () {
      expect(Helpers.getYear('Feb 14, 2023'), 2023);
    });

    test('getMonth should return the correct month number', () {
      expect(Helpers.getMonth('Feb 14, 2023'), 2);
    });

    test('getDay should return the correct day', () {
      expect(Helpers.getDay('Feb 14, 2023'), 14);
    });

    test('convertDbDateTimeToDateTime should return the correct formatted date', () {
      expect(Helpers.convertDbDateTimeToDateTime('2023-08-27T20:00:00+02:00'), '27-08-2023 20:00');
    });

    test('convertDateTimeToDbDateTime should return the correct formatted date', () {
      expect(Helpers.convertDateTimeToDbDateTime('27-08-2023 18:00'), '2023-08-27T18:00:00+02:00');
    });

    test('getDateFromFormattedStringDDMMYYYYHHSS should return the correct date', () {
      expect(Helpers.getDateFromFormattedStringDDMMYYYYHHSS('27-08-2023 18:00'), '27-08-2023');
    });

    test('getTimeFromFormattedStringDDMMYYYYHHSS should return the correct time', () {
      expect(Helpers.getTimeFromFormattedStringDDMMYYYYHHSS('27-08-2023 18:00'), '18:00');
    });

    test('capitalizeFirstLetter should capitalize the first letter', () {
      expect(Helpers.capitalizeFirstLetter('hello world'), 'Hello world');
    });

    test('doubleToEuroFormat should format double to Euro currency', () {
      expect(Helpers.doubleToEuroFormat(10.0), '€ 10.00');
    });
  });
}
