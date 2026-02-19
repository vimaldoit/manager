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

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  late TapGestureRecognizer _signInRecognizer;
  bool hidePassword = true;
  bool hideCPassword = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _signInRecognizer = TapGestureRecognizer()
      ..onTap = () {
        AppRouter.goLogin(context);
      };
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _signInRecognizer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Form(
                key: _formKey,
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is Authenticated) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Registration Success")),
                      );
                      AppRouter.goLogin(context);
                    } else if (state is AuthError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "SIGN UP",
                            style: AppTheme.bodyText2.copyWith(),
                          ),
                        ),
                        SizedBox(height: 40.h),
                        CommonTextFormField(
                          controller: emailController,
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
                          hintText: "Enter password",
                          controller: passwordController,
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
                          validator: (value) =>
                              Validator.validatePassword(value),
                        ),
                        const Vspace(25),
                        CommonTextFormField(
                          borderColor: Colors.transparent,
                          hintText: "Confirm password",
                          controller: confirmPasswordController,
                          obscureText: hideCPassword,
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
                                hideCPassword = !hideCPassword;
                              });
                            },
                            child: Icon(
                              color: AppColors.textSecondary,
                              hideCPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value == "") {
                              return "confirm password should not be empty";
                            } else if (value != passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                        const Vspace(30),
                        if (state is AuthLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                          CommonButton(
                            text: "Sign Up",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                      SignUpRequested(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      ),
                                    );
                              }
                            },
                          ),
                        const Vspace(20),
                        const Vspace(20),
                        Center(
                          child: Text.rich(
                            TextSpan(
                              text: "Already have an account? ",
                              style: AppTheme.bodyText3.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: 13.sp,
                              ),
                              children: [
                                TextSpan(
                                  text: "Sign In",
                                  recognizer: _signInRecognizer,
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
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
