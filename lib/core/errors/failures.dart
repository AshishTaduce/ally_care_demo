import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}

// Network failures
class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

// Server failures
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

// Cache failures
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

// Firestore failures
class FirestoreFailure extends Failure {
  const FirestoreFailure(String message) : super(message);
}

// Storage failures
class StorageFailure extends Failure {
  const StorageFailure(String message) : super(message);
}

// Permission failures
class PermissionFailure extends Failure {
  const PermissionFailure(String message) : super(message);
}

// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

// Unexpected failures
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(String message) : super(message);
}