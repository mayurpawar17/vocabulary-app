/// Entity representing the user credentials for login authentication request.
/// Payload specification:
/// ```json
/// {
///   "username": "string",
///   "password": "string"
/// }
/// ```
class LoginRequest {
  final String username;
  final String password;

  const LoginRequest({
    required this.username,
    required this.password,
  });

  /// Factory constructor to deserialize JSON payload into [LoginRequest] instance.
  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );
  }

  /// Converts [LoginRequest] instance into a JSON Map payload for HTTP request body.
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}