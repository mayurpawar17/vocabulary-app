import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocabulary_app/features/auth/domain/entity/register_request.dart';
import 'package:vocabulary_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<UserCredential> execute(RegisterRequest registerRequest) {
    return _authRepository.register(registerRequest);
  }
}