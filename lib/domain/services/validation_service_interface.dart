import 'package:validator/domain/entities/validation_data.dart';

abstract class IValidationService {
  Future<void> validateTicket(ValidationData validationData, void Function(bool) onSuccess, void Function(String) onError);
}
