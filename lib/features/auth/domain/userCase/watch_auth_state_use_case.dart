import 'package:vocabulary_app/features/auth/domain/entity/auth_user.dart';
import 'package:vocabulary_app/features/auth/domain/repositories/auth_repository.dart';

class WatchAuthStateUseCase {
  const WatchAuthStateUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Stream<AuthUser?> execute() => _authRepository.authStateChanges;
}
