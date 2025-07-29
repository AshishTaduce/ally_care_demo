import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/auth_service.dart';
import '../../data/user_model.dart';

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Auth state provider - watches Firebase auth state changes
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Current user data provider
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.getCurrentUserData();
});

// Auth state notifier for managing authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState.initial());

  // Register with email and password
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
    File? profileImage,
  }) async {
    state = const AuthState.loading();

    final result = await _authService.registerWithEmailAndPassword(
      email: email,
      password: password,
      displayName: displayName,
      profileImage: profileImage,
    );

    result.fold(
          (failure) => state = AuthState.error(failure.message),
          (user) => state = AuthState.authenticated(user),
    );
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();

    final result = await _authService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    result.fold(
          (failure) => state = AuthState.error(failure.message),
          (user) => state = AuthState.authenticated(user),
    );
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    state = const AuthState.loading();

    final result = await _authService.signInWithGoogle();

    result.fold(
          (failure) => state = AuthState.error(failure.message),
          (user) => state = AuthState.authenticated(user),
    );
  }

  // Reset password
  Future<void> resetPassword({required String email}) async {
    state = const AuthState.loading();

    final result = await _authService.resetPassword(email: email);

    result.fold(
          (failure) => state = AuthState.error(failure.message),
          (_) => state = const AuthState.passwordResetSent(),
    );
  }

  // Sign out
  Future<void> signOut() async {
    state = const AuthState.loading();

    final result = await _authService.signOut();

    result.fold(
          (failure) => state = AuthState.error(failure.message),
          (_) => state = const AuthState.unauthenticated(),
    );
  }

  // Update user profile
  Future<void> updateUserProfile({
    String? displayName,
    String? phoneNumber,
    DateTime? dateOfBirth,
    File? profileImage,
  }) async {
    state = const AuthState.loading();

    final result = await _authService.updateUserProfile(
      displayName: displayName,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      profileImage: profileImage,
    );

    result.fold(
          (failure) => state = AuthState.error(failure.message),
          (user) => state = AuthState.authenticated(user),
    );
  }

  // Clear error state
  void clearError() {
    if (state.maybeWhen(
      error: (_) => true,
      orElse: () => false,
    )) {
      state = const AuthState.initial();
    }
  }

  // Check if user is signed in
  bool get isSignedIn => _authService.isSignedIn;
}

// Auth state notifier provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

// Auth state sealed class
sealed class AuthState {
  const AuthState();

  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated(UserModel user) = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.error(String message) = AuthError;
  const factory AuthState.passwordResetSent() = AuthPasswordResetSent;

  // Helper methods for pattern matching
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(UserModel user) authenticated,
    required T Function() unauthenticated,
    required T Function(String message) error,
    required T Function() passwordResetSent,
  }) {
    return switch (this) {
      AuthInitial() => initial(),
      AuthLoading() => loading(),
      AuthAuthenticated(:final user) => authenticated(user),
      AuthUnauthenticated() => unauthenticated(),
      AuthError(:final message) => error(message),
      AuthPasswordResetSent() => passwordResetSent(),
    };
  }

  T? whenOrNull<T>({
    T Function()? initial,
    T Function()? loading,
    T Function(UserModel user)? authenticated,
    T Function()? unauthenticated,
    T Function(String message)? error,
    T Function()? passwordResetSent,
  }) {
    return switch (this) {
      AuthInitial() => initial?.call(),
      AuthLoading() => loading?.call(),
      AuthAuthenticated(:final user) => authenticated?.call(user),
      AuthUnauthenticated() => unauthenticated?.call(),
      AuthError(:final message) => error?.call(message),
      AuthPasswordResetSent() => passwordResetSent?.call(),
    };
  }

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? loading,
    T Function(UserModel user)? authenticated,
    T Function()? unauthenticated,
    T Function(String message)? error,
    T Function()? passwordResetSent,
    required T Function() orElse,
  }) {
    return whenOrNull(
      initial: initial,
      loading: loading,
      authenticated: authenticated,
      unauthenticated: unauthenticated,
      error: error,
      passwordResetSent: passwordResetSent,
    ) ?? orElse();
  }
}

// Individual state classes
class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserModel user;
  const AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class AuthPasswordResetSent extends AuthState {
  const AuthPasswordResetSent();
}