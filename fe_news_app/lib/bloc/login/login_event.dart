class LoginEvent {}
class LoginWithEmail extends LoginEvent {
  final String email, password;
  LoginWithEmail(this.email, this.password);
}
class LoginWithGoogle extends LoginEvent {}