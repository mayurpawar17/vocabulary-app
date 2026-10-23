enum AuthFailureReason {
  invalidEmail,
  accountDisabled,
  invalidCredentials,
  emailAlreadyInUse,
  weakPassword,
  network,
  unknown,
}

class AuthException implements Exception {
  const AuthException(this.reason);

  final AuthFailureReason reason;
}
