class AppException implements Exception {
  final String message;
  final String? prefix;

  AppException([this.message = 'An unknown error occurred.', this.prefix]);

  @override
  String toString() {
    return '$prefix$message';
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message!, 'Error During Communication: ');
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message!, 'Invalid Request: ');
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String? message]) : super(message!, 'Unauthorized: ');
}

class NotFoundException extends AppException {
  NotFoundException([String? message]) : super(message!, 'Not Found: ');
}

class ConflictException extends AppException {
  ConflictException([String? message]) : super(message!, 'Conflict Occurred: ');
}

class InternalServerErrorException extends AppException {
  InternalServerErrorException([String? message]) : super(message!, 'Internal Server Error: ');
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message!, 'Invalid Input: ');
}

class NoInternetException extends AppException {
  NoInternetException([String? message]) : super(message!, 'No Internet Connection: ');
}

// Exception spesifik aplikasi
class InsufficientBalanceException extends AppException {
  InsufficientBalanceException([String? message = 'Insufficient balance.']) : super(message!, 'Balance Error: ');
}

class UserNotFoundException extends AppException {
  UserNotFoundException([String? message = 'User not found.']) : super(message!, 'User Error: ');
}

class AuthException extends AppException {
  AuthException([String? message = 'Authentication failed.']) : super(message!, 'Auth Error: ');
}