import 'package:fe_news_app/models/user_reponse.dart';

class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {
  final UserResponse user;
  SignUpSuccess(this.user);
}

class SignUpFailure extends SignUpState {
  final String message;
  SignUpFailure(this.message);

  @override
  String toString() => message;
}
