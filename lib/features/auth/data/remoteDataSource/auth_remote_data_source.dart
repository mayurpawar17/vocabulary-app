import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocabulary_app/features/auth/domain/entity/login_request.dart';
import 'package:vocabulary_app/features/auth/domain/entity/register_request.dart';


abstract class AuthRemoteDataSource2 {
  /// Sends login credentials to the auth backend endpoint (`/auth/login`).
  Future<UserCredential> login(LoginRequest loginRequest);
  Future<UserCredential> register(RegisterRequest registerRequest);
  Future<void> logout();

  
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource2 {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl(this._firebaseAuth);

  @override
  Future<UserCredential> login(LoginRequest loginRequest) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: loginRequest.username.trim(),
        password: loginRequest.password,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserCredential> register(RegisterRequest registerRequest) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: registerRequest.email.trim(),
        password: registerRequest.password,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() {
    return _firebaseAuth.signOut(); 
  }
}



class AuthRemoteDataSource {
  AuthRemoteDataSource(this._firebaseAuth);
  final FirebaseAuth _firebaseAuth;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> register({
    required String email,
    required String password,
  }) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signOut() => _firebaseAuth.signOut();
}
