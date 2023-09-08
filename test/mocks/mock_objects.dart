import 'package:validator/domain/entities/credentials.dart';
import 'package:validator/domain/entities/event.dart';
import 'package:validator/domain/entities/order.dart';
import 'package:validator/domain/entities/organization.dart';
import 'package:validator/domain/entities/ticket/create_ticket.dart';
import 'package:validator/domain/entities/user.dart';
import 'package:validator/domain/entities/validation_data.dart';

const mockUserObject = User(email: 'johndoe@example.com', name: 'John', surname: 'Doe');

const mockEventObject = Event(title: 'Bad Bunny Concert', date: "07-12-2023", time: '18:00', venue: 'Wizink Center', organizationId: 1);

const mockCredentialsObject = Credentials(username: 'johndoe@example.com', password: 'johndoe');

const mockOrganizationObject = Organization(name: 'UNIVERSAL MUSIC SPAIN');

const mockValidationDataObject = ValidationData(eventId: 1, reference: '3N2YZYRDIGAS9DP1GJMC');

const mockCreateTicketObject = CreateTicket(eventId: 1, price: 50.0, limit: 2);

const mockOrderObject = Order(eventId: 1, quantity: 1);
