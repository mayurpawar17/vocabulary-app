import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocabulary_app/features/auth/data/remoteDataSource/auth_remote_data_source.dart';
import 'package:vocabulary_app/features/auth/domain/entity/auth_exception.dart';
import 'package:vocabulary_app/features/auth/domain/entity/auth_user.dart';
import 'package:vocabulary_app/features/auth/domain/entity/login_request.dart';
import 'package:vocabulary_app/features/auth/domain/entity/register_request.dart';
import 'package:vocabulary_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepositoryImpl(this._authRemoteDataSource);

  @override
  Stream<AuthUser?> get authStateChanges =>
      _authRemoteDataSource.authStateChanges.map(_mapUser);

  @override
  Future<AuthUser> login(LoginRequest loginRequest) async {
    try {
      final credential = await _authRemoteDataSource.login(
        email: loginRequest.email,
        password: loginRequest.password,
      );
      return _mapCredential(credential);
    } on FirebaseAuthException catch (error) {
      throw AuthException(_mapError(error.code));
    }
  }

  @override
  Future<AuthUser> register(RegisterRequest registerRequest) async {
    try {
      final credential = await _authRemoteDataSource.register(
        email: registerRequest.email,
        password: registerRequest.password,
      );
      return _mapCredential(credential);
    } on FirebaseAuthException catch (error) {
      throw AuthException(_mapError(error.code));
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _authRemoteDataSource.logout();
    } on FirebaseAuthException catch (error) {
      throw AuthException(_mapError(error.code));
    }
  }

  AuthUser _mapCredential(UserCredential credential) {
    final user = credential.user;
    if (user == null) {
      throw const AuthException(AuthFailureReason.unknown);
    }
    return AuthUser(id: user.uid, email: user.email);
  }

  AuthUser? _mapUser(User? user) =>
      user == null ? null : AuthUser(id: user.uid, email: user.email);

  AuthFailureReason _mapError(String code) => switch (code) {
    'invalid-email' => AuthFailureReason.invalidEmail,
    'user-disabled' => AuthFailureReason.accountDisabled,
    'user-not-found' || 'wrong-password' || 'invalid-credential' =>
      AuthFailureReason.invalidCredentials,
    'email-already-in-use' => AuthFailureReason.emailAlreadyInUse,
    'weak-password' => AuthFailureReason.weakPassword,
    'network-request-failed' => AuthFailureReason.network,
    _ => AuthFailureReason.unknown,
  };
}