import 'package:fe_news_app/bloc/sign_up/sign_up_event.dart';
import 'package:fe_news_app/bloc/sign_up/sign_up_state.dart';
import 'package:fe_news_app/models/user_reponse.dart';
import 'package:fe_news_app/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpWithEmail>((event, emit) async {
      emit(SignUpLoading());
      try {
        final userMap = await AuthService.register(
          event.username,
          event.email,
          event.password,
        );
        final user = UserResponse.fromJson(userMap);
        emit(SignUpSuccess(user));
      } catch (e) {
        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        if (errorMessage.contains('Email already registered')) {
          emit(SignUpFailure('Người dùng đã tồn tại'));
        } else {
          emit(SignUpFailure(errorMessage));
        }
      }
    });
  }
}
