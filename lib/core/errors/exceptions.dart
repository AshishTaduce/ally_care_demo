// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

// Authentication exceptions
class AuthException extends AppException {
  const AuthException(super.message, {super.code});
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException() : super('User not found');
}

class WrongPasswordException extends AuthException {
  const WrongPasswordException() : super('Incorrect password');
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException() : super('Email is already registered');
}

class WeakPasswordException extends AuthException {
  const WeakPasswordException() : super('Password is too weak');
}

class InvalidEmailException extends AuthException {
  const InvalidEmailException() : super('Invalid email address');
}

class UserDisabledException extends AuthException {
  const UserDisabledException() : super('User account has been disabled');
}

class TooManyRequestsException extends AuthException {
  const TooManyRequestsException() : super('Too many requests. Please try again later');
}

// Network exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

class NoInternetConnectionException extends NetworkException {
  const NoInternetConnectionException() : super('No internet connection');
}

class RequestTimeoutException extends NetworkException {
  const RequestTimeoutException() : super('Request timeout');
}

class ServerException extends NetworkException {
  const ServerException(super.message, {super.code});
}

// Firestore exceptions
class FirestoreException extends AppException {
  const FirestoreException(super.message, {super.code});
}

class DocumentNotFoundException extends FirestoreException {
  const DocumentNotFoundException() : super('Document not found');
}

class PermissionDeniedException extends FirestoreException {
  const PermissionDeniedException() : super('Permission denied');
}

// Storage exceptions
class StorageException extends AppException {
  const StorageException(super.message, {super.code});
}

class FileNotFoundException extends StorageException {
  const FileNotFoundException() : super('File not found');
}

class FileUploadException extends StorageException {
  const FileUploadException(String message) : super('Failed to upload file: $message');
}

class FileSizeExceededException extends StorageException {
  const FileSizeExceededException() : super('File size exceeds the limit');
}

// Cache exceptions
class CacheException extends AppException {
  const CacheException(super.message, {super.code});
}

class CacheNotFoundException extends CacheException {
  const CacheNotFoundException() : super('Data not found in cache');
}

// Validation exceptions
class ValidationException extends AppException {
  const ValidationException(super.message);
}

class InvalidInputException extends ValidationException {
  const InvalidInputException(String field) : super('Invalid input for $field');
}

// Permission exceptions
class PermissionException extends AppException {
  const PermissionException(super.message);
}

class CameraPermissionException extends PermissionException {
  const CameraPermissionException() : super('Camera permission is required');
}

class StoragePermissionException extends PermissionException {
  const StoragePermissionException() : super('Storage permission is required');
}

// Location exceptions
class LocationException extends AppException {
  const LocationException(super.message);
}

class LocationPermissionException extends LocationException {
  const LocationPermissionException() : super('Location permission is required');
}

class LocationServiceDisabledException extends LocationException {
  const LocationServiceDisabledException() : super('Location service is disabled');
}

// Generic exceptions
class UnknownException extends AppException {
  const UnknownException([String? message]) : super(message ?? 'An unknown error occurred');
}

class NotImplementedException extends AppException {
  const NotImplementedException([String? feature])
      : super(feature != null ? '$feature is not implemented yet' : 'Feature not implemented');
}