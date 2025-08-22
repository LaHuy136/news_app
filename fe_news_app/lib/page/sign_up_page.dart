// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:fe_news_app/bloc/sign_up/sign_up_bloc.dart';
import 'package:fe_news_app/bloc/sign_up/sign_up_event.dart';
import 'package:fe_news_app/bloc/sign_up/sign_up_state.dart';
import 'package:fe_news_app/components/custom_snackbar.dart';
import 'package:fe_news_app/components/elevated_button.dart';
import 'package:fe_news_app/components/text_formfield.dart';
import 'package:fe_news_app/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final confirmPwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(),
      child: Scaffold(
        backgroundColor: ColorTheme.bgPrimaryColor,
        appBar: AppBar(
          leadingWidth: 55,
          leading: Container(
            margin: EdgeInsets.only(left: 8, top: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: ColorTheme.bgPrimaryColor,
            ),
            alignment: Alignment.center,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_rounded, size: 22),
            ),
          ),
          backgroundColor: ColorTheme.bgPrimaryColor,
          foregroundColor: ColorTheme.bgPrimaryColor,
        ),
        body: BlocConsumer<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              showCustomSnackBar(
                context: context,
                message: 'Đăng ký thành công',
              );
              Navigator.pushReplacementNamed(context, '/login');
            } else if (state is SignUpFailure) {
              showCustomSnackBar(
                context: context,
                message: state.toString().replaceFirst('Exception: ', ''),
                type: SnackBarType.error,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is SignUpLoading;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // App Name
                        Text(
                          'Xin chào,',
                          style: TextStyle(
                            color: ColorTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // App Subname
                        Text(
                          'Chào mừng bạn quay trở lại',
                          style: TextStyle(
                            color: ColorTheme.bodyText,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 50),
                        Center(
                          child: const Text(
                            'Đăng ký tài khoản',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    // Username
                    MyTextFormField(
                      controller: userNameController,
                      hintText: '   Tên',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên của bạn';
                        }
                        return null;
                      },
                      icon: Icons.person_rounded,
                    ),

                    const SizedBox(height: 20),
                    // Email
                    MyTextFormField(
                      controller: emailController,
                      hintText: '  Địa chỉ email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập email';
                        }
                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return 'Email không hợp lệ';
                        }
                        return null;
                      },
                      icon: Icons.email_rounded,
                    ),

                    const SizedBox(height: 20),
                    // Password
                    MyTextFormField(
                      controller: pwController,
                      isPassword: true,
                      hintText: '  Mật khẩu',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu';
                        }
                        if (value.length < 6) {
                          return 'Mật khẩu của bạn chưa đủ độ dài';
                        }
                        return null;
                      },
                      icon: Icons.lock_rounded,
                    ),

                    const SizedBox(height: 25),
                    // Button SignUp
                    MyElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<SignUpBloc>().add(
                            SignUpWithEmail(
                              username: userNameController.text.trim(),
                              email: emailController.text.trim(),
                              password: pwController.text,
                            ),
                          );
                        }
                      },
                      isLoading: isLoading,
                      textButton: 'Đăng ký',
                    ),

                    const SizedBox(height: 35),
                    // // Or Login with
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text('—', style: TextStyle(color: ColorTheme.primaryColor)),
                    //     const SizedBox(width: 6),
                    //     Text(
                    //       'hoặc đăng nhập với',
                    //       style: TextStyles.textMedium.copyWith(
                    //         fontWeight: FontWeight.w400,
                    //       ),
                    //     ),
                    //     const SizedBox(width: 6),
                    //     Text('—', style: TextStyle(color: ColorTheme.primaryColor)),
                    //   ],
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
