import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:docdoc/core/utils/colors_manager.dart';
import 'package:docdoc/core/utils/text_style_manager.dart';
import 'package:docdoc/features/auth/logic/login_bloc.dart';
import 'package:docdoc/features/auth/logic/login_event.dart';
import 'package:docdoc/features/auth/logic/auth_state.dart';
import 'package:docdoc/features/auth/presentation/widgets/social_icon_row.dart';
import 'package:docdoc/presentation/widgets/shared/button_widget.dart';
import 'package:docdoc/presentation/widgets/shared/form_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _rememberMe = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<LoginBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }

            if (state is AuthSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/homeScreen',
                    (route) => false,
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.08,
                  vertical: size.height * 0.05,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TITLE
                      Text(
                        "Welcome Back",
                        style: TextStyleManager.interBold24.copyWith(
                          color: PrimaryColor.primary100,
                        ),
                      ),
                      SizedBox(height: size.height * 0.015),

                      /// SUBTITLE
                      Text(
                        "We're excited to have you back, can't wait to\n"
                            "see what you've been up to since you last\n"
                            "logged in.",
                        style: TextStyleManager.interRegular14.copyWith(
                          color: BackGround.body,
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),

                      /// EMAIL
                      TextFieldWidget(
                        hintText: "Email",
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * 0.01),

                      /// PASSWORD
                      TextFieldWidget(
                        hintText: "Password",
                        controller: passwordController,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),

                      /// REMEMBER ME
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            activeColor: PrimaryColor.primary100,
                            checkColor: GrayColor.grey40,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value ?? false;
                              });
                            },
                          ),
                          const Text(
                            "Remember me",
                            style: TextStyleManager.interRegular12,
                          ),
                          const Spacer(),
                          Text(
                            "Forget Password?",
                            style: TextStyleManager.interRegular12.copyWith(
                              color: PrimaryColor.primary100,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: size.height * 0.02),

                      /// LOGIN BUTTON
                      ButtonWidget(
                        text: state is AuthLoading
                            ? "Logging in..."
                            : "Login",
                        type: state is AuthLoading
                            ? ButtonType.disabled
                            : ButtonType.primary,
                        onTap: state is AuthLoading
                            ? null
                            : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<LoginBloc>().add(
                              LoginButtonPressed(
                                email: emailController.text.trim(),
                                password:
                                passwordController.text.trim(),
                              ),
                            );
                          }
                        },
                      ),

                      SizedBox(height: size.height * 0.06),

                      /// DIVIDER
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: GrayColor.grey40,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Or Sign In With",
                              style:
                              TextStyleManager.interRegular12.copyWith(
                                color: GrayColor.grey60,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: GrayColor.grey40,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: size.height * 0.06),

                      /// SOCIAL LOGIN
                      const SocialIconRow(),

                      SizedBox(height: size.height * 0.06),

                      /// TERMS
                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "By logging, you agree to our ",
                                style: TextStyleManager.interRegular12
                                    .copyWith(color: GrayColor.grey60),
                              ),
                              TextSpan(
                                text: "Terms & Conditions ",
                                style: TextStyleManager.interRegular12
                                    .copyWith(
                                  color: GrayColor.grey100,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: "and ",
                                style: TextStyleManager.interRegular12
                                    .copyWith(color: GrayColor.grey60),
                              ),
                              TextSpan(
                                text: "Privacy Policy.",
                                style: TextStyleManager.interRegular12
                                    .copyWith(
                                  color: GrayColor.grey100,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: size.height * 0.06),

                      /// SIGN UP
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Don't have an account? ",
                                style:
                                TextStyleManager.interRegular11.copyWith(
                                  color: GrayColor.grey100,
                                ),
                              ),
                              TextSpan(
                                text: "Sign Up",
                                style:
                                TextStyleManager.interRegular11.copyWith(
                                  color: PrimaryColor.primary100,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/signUp',
                                          (route) => false,
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
