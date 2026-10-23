import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import '../../data/remoteDataSource/auth_remote_data_source.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRemoteDataSource _authService;
  late final StreamSubscription<User?> _authSubscription;

  AuthBloc(this._authService) : super(const AuthLoading()) {
    on<AuthStatusChanged>(_onAuthStatusChanged);
    on<SignInRequested>(_onSignInRequested);
    on<RegistrationRequested>(_onRegistrationRequested);
    on<SignOutRequested>(_onSignOutRequested);

    _authSubscription = _authService.authStateChanges.listen(
      (user) => add(AuthStatusChanged(user)),
      onError: (Object error, StackTrace stackTrace) {
        add(const _AuthStatusCheckFailed());
      },
    );
    on<_AuthStatusCheckFailed>((event, emit) {
      emit(
        const AuthFailure(
          'Unable to check your sign-in status. Please try again.',
        ),
      );
    });
    add(AuthStatusChanged(_authService.currentUser));
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
      await _authService.signIn(email: event.email, password: event.password);
    } on FirebaseAuthException catch (error) {
      emit(AuthFailure(_messageFor(error)));
    } catch (error) {
      emit(const AuthFailure('Sign in failed. Please try again.'));
    }
  }

  Future<void> _onRegistrationRequested(
    RegistrationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthSubmitting());
    try {
      await _authService.register(email: event.email, password: event.password);
    } on FirebaseAuthException catch (error) {
      emit(AuthFailure(_messageFor(error)));
    } catch (error) {
      emit(const AuthFailure('Account creation failed. Please try again.'));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authService.signOut();
    } on FirebaseAuthException catch (error) {
      emit(AuthFailure(_messageFor(error)));
    } catch (error) {
      emit(const AuthFailure('Sign out failed. Please try again.'));
    }
  }

  String _messageFor(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'Enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'The email or password is incorrect.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'weak-password':
        return 'Choose a stronger password (at least 6 characters).';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      default:
        return error.message ?? 'Authentication failed. Please try again.';
    }
  }

  @override
  Future<void> close() async {
    await _authSubscription.cancel();
    await super.close();
  }
}

class _AuthStatusCheckFailed extends AuthEvent {
  const _AuthStatusCheckFailed();
}
