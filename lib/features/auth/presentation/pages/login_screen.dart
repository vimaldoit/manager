import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskmanager/core/common%20_widgets/textfield_widget.dart';
import 'package:taskmanager/core/common%20_widgets/common_button.dart';
import 'package:taskmanager/core/common%20_widgets/vspace.dart';
import 'package:taskmanager/core/router/app_router.dart';
import 'package:taskmanager/core/theme/app_colors.dart';
import 'package:taskmanager/core/theme/app_theme.dart';
import 'package:taskmanager/core/utils/validator.dart';
import 'package:taskmanager/features/auth/presentation/bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  late TapGestureRecognizer _signupRecognizer;
  bool hidePassword = true;
  @override
  void initState() {
    super.initState();
    _signupRecognizer = TapGestureRecognizer()
      ..onTap = () {
        AppRouter.pushSignUp(context);
      };
  }

  @override
  void dispose() {
    super.dispose();
    _signupRecognizer.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Form(
              key: _formKey,
              child:
                  BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
                if (state is Authenticated) {
                  AppRouter.goProjectScreen(context);
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              }, builder: (context, state) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Vspace(30),
                      Text(
                        "Sign In to get started",
                        style: AppTheme.bodyText2.copyWith(),
                      ),
                      const Vspace(20),
                      CommonTextFormField(
                        controller: email,
                        hintText: "Enter your Email ID",
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        prefix: const Padding(
                          padding: EdgeInsets.only(
                            left: 15,
                            top: 15,
                            bottom: 15,
                          ),
                          child: Icon(Icons.person),
                        ),
                        hintColor: AppColors.textSecondary,
                        borderColor: Colors.transparent,
                        validator: (value) => Validator.validateEmail(value),
                      ),
                      const Vspace(25),
                      CommonTextFormField(
                        borderColor: Colors.transparent,
                        hintText: "Enter your password",
                        controller: password,
                        obscureText: hidePassword,
                        hintColor: AppColors.textSecondary,
                        prefix: const Padding(
                          padding: EdgeInsets.only(
                            left: 15,
                            top: 15,
                            bottom: 15,
                          ),
                          child: Icon(Icons.lock),
                        ),
                        suffix: GestureDetector(
                          onTap: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          child: Icon(
                            color: AppColors.textSecondary,
                            hidePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                        validator: (value) => Validator.validatePassword(value),
                      ),
                      const Vspace(30),
                      if (state is AuthLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        CommonButton(
                          text: "Sign In",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                    LoginRequested(
                                      email.text.trim(),
                                      password.text.trim(),
                                    ),
                                  );
                            }
                          },
                        ),
                      const Vspace(30),
                      Center(
                        child: Text.rich(
                          TextSpan(
                            text: "Don't have an account? ",
                            style: AppTheme.bodyText3.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 13.sp,
                            ),
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                recognizer: _signupRecognizer,
                                style: AppTheme.bodyText3.copyWith(
                                  color: const Color(0xff009776),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Vspace(20),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
