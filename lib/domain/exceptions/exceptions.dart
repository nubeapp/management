class EventTicketLimitException implements Exception {
  final String message;

  EventTicketLimitException(this.message);

  @override
  String toString() => message;
}

class UserTicketLimitException implements Exception {
  final String message;

  UserTicketLimitException(this.message);

  @override
  String toString() => message;
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);

  @override
  String toString() => message;
}

class BadRequestException implements Exception {
  final String message;

  BadRequestException(this.message);

  @override
  String toString() => message;
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException(this.message);

  @override
  String toString() => message;
}

class TicketAlreadyValidatedException implements Exception {
  final String message;

  TicketAlreadyValidatedException(this.message);

  @override
  String toString() => message;
}
