class SignUpEvent {}

class SignUpWithEmail extends SignUpEvent {
  final String username, email, password;

  SignUpWithEmail({
    required this.username,
    required this.email,
    required this.password,
  });
}
