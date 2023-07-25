import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:validator/domain/entities/validation_data.dart';
import 'package:validator/domain/services/validation_service_interface.dart';
import 'package:validator/presentation/styles/logger.dart';

class ValidationService implements IValidationService {
  ValidationService({required this.client});

  static String get API_BASE_URL => 'http://192.168.1.73:8000/validation';
  final http.Client client;

  @override
  Future<void> validateTicket(ValidationData validationData, void Function(bool) onSuccess, void Function(String) onError) async {
    try {
      Logger.debug("Validating ticket with reference '${validationData.reference}'...");
      final response = await client.put(
        Uri.parse(API_BASE_URL),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(validationData.toJson()),
      );

      if (response.statusCode == 200) {
        onSuccess(true);
        Logger.info('Ticket with reference ${validationData.reference} has been validated successfully!');
      } else if (response.statusCode == 401) {
        onError('Unathorize operation. Status code: ${response.statusCode}');
        // throw UnauthorizedException('Unathorize operation. Status code: ${response.statusCode}');
      } else if (response.statusCode == 404) {
        onError('Not found the ticket with the reference provided. Status code: ${response.statusCode}');
        // throw NotFoundException('Not found the ticket with the reference provided. Status code: ${response.statusCode}');
      } else if (response.statusCode == 409) {
        onError('Ticket has been already validated. Status code: ${response.statusCode}');
        // throw TicketAlreadyValidatedException('Ticket has been already validated. Status code: ${response.statusCode}');
      } else {
        onError('Failed to validate the ticket. Status code: ${response.statusCode}');
        // throw Exception('Failed to validate the ticket. Status code: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
