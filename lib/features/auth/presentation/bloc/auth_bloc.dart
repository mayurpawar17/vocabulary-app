import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vocabulary_app/features/auth/domain/entity/auth_exception.dart';
import 'package:vocabulary_app/features/auth/domain/entity/auth_user.dart';
import 'package:vocabulary_app/features/auth/domain/entity/login_request.dart';
import 'package:vocabulary_app/features/auth/domain/entity/register_request.dart';
import 'package:vocabulary_app/features/auth/domain/userCase/login_use_case.dart';
import 'package:vocabulary_app/features/auth/domain/userCase/logout_use_case.dart';
import 'package:vocabulary_app/features/auth/domain/userCase/register_use_case.dart';
import 'package:vocabulary_app/features/auth/domain/userCase/watch_auth_state_use_case.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

    final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final RegisterUseCase _registerUseCase;
  late final StreamSubscription<AuthUser?> _authSubscription;
  
  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required RegisterUseCase registerUseCase,
    required WatchAuthStateUseCase watchAuthStateUseCase,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _registerUseCase = registerUseCase,
       super(const AuthLoading()) {
    on<AuthStatusChanged>(_onAuthStatusChanged);
    on<SignInRequested>(_onSignInRequested);
    on<RegistrationRequested>(_onRegistrationRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<_AuthStatusCheckFailed>((event, emit) {
      emit(
        const AuthFailure(
          'Unable to check your sign-in status. Please try again.',
        ),
      );
    });

    _authSubscription = watchAuthStateUseCase.execute().listen(
      (user) => add(AuthStatusChanged(user)),
      onError: (_) => add(const _AuthStatusCheckFailed()),
    );
  }



  void _onAuthStatusChanged(AuthStatusChanged event, Emitter<AuthState> emit) {
    final user = event.user;
    if (user == null) {
      emit(const AuthUnauthenticated());
    } else {
      emit(AuthAuthenticated(user));
    }
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthSubmitting());
    try {
      await _loginUseCase.execute(
        LoginRequest(email: event.email, password: event.password),
      );
    } on AuthException catch (error) {
      emit(AuthFailure(_messageFor(error)));
    } on Exception {
      emit(const AuthFailure('Sign in failed. Please try again.'));
    }
  }

  Future<void> _onRegistrationRequested(
    RegistrationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthSubmitting());
    try {
      await _registerUseCase.execute(
        RegisterRequest(email: event.email, password: event.password),
      );
    } on AuthException catch (error) {
      emit(AuthFailure(_messageFor(error)));
    } on Exception {
      emit(const AuthFailure('Account creation failed. Please try again.'));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _logoutUseCase.execute();
    } on AuthException catch (error) {
      emit(AuthFailure(_messageFor(error)));
    } on Exception {
      emit(const AuthFailure('Sign out failed. Please try again.'));
    }
  }

  String _messageFor(AuthException error) => switch (error.reason) {
    AuthFailureReason.invalidEmail => 'Enter a valid email address.',
    AuthFailureReason.accountDisabled => 'This account has been disabled.',
    AuthFailureReason.invalidCredentials =>
      'The email or password is incorrect.',
    AuthFailureReason.emailAlreadyInUse =>
      'An account already exists for this email.',
    AuthFailureReason.weakPassword =>
      'Choose a stronger password (at least 6 characters).',
    AuthFailureReason.network =>
      'Network error. Check your connection and try again.',
    AuthFailureReason.unknown => 'Authentication failed. Please try again.',
  };

  @override
  Future<void> close() async {
    await _authSubscription.cancel();
    await super.close();
  }
}

class _AuthStatusCheckFailed extends AuthEvent {
  const _AuthStatusCheckFailed();
}
