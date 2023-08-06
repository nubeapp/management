import 'package:validator/domain/entities/event.dart';
import 'package:validator/domain/entities/validation_data.dart';

const mockEventObject = Event(
  title: 'Bad Bunny Concert',
  date: "07-12-2023",
  time: '18:00',
  venue: 'Wizink Center',
  organizationId: 1,
);

const mockValidationDataObject = ValidationData(eventId: 1, reference: '3N2YZYRDIGAS9DP1GJMC');
