import 'package:fe_news_app/bloc/login/login_event.dart';
import 'package:fe_news_app/bloc/login/login_state.dart';
import 'package:fe_news_app/models/user_reponse.dart';
import 'package:fe_news_app/services/auth_service.dart';
import 'package:fe_news_app/services/google_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginIntial()) {
    on<LoginWithEmail>((event, emit) async {
      emit(LoginLoading());
      try {
        final userMapEmail = await AuthService.login(
          event.email,
          event.password,
        );
        final user = UserResponse.fromJson(userMapEmail);
        emit(LoginSuccess(user));
      } catch (e) {
        String errorMessage = e.toString().replaceFirst('Exception: ', '');
        if (errorMessage.contains('User not found')) {
          emit(LoginFailure('Người dùng không tồn tại'));
        }
        if (errorMessage == 'Invalid credentials') {
          emit(LoginFailure('Email hoặc mật khẩu không đúng'));
        }
        emit(LoginFailure(e.toString().replaceFirst('Exception: ', '')));
      }
    });

    on<LoginWithGoogle>((event, emit) async {
      emit(LoginLoading());
      try {
        final user = await GoogleService.signInWithGoogle();
        if (user != null) {
          emit(LoginSuccess(user));
        } else {
          emit(LoginFailure('Đăng nhập Google thất bại'));
        }
      } catch (e) {
        emit(LoginFailure('Lỗi khi đăng nhập Google: $e'));
      }
    });
  }
}
