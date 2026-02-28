import 'package:docdoc/core/utils/colors_manager.dart';
import 'package:docdoc/core/utils/text_style_manager.dart';
import 'package:docdoc/features/auth/logic/auth_state.dart';
import 'package:docdoc/features/auth/logic/signup_bloc.dart';
import 'package:docdoc/features/auth/logic/signup_event.dart';
import 'package:docdoc/features/auth/presentation/widgets/social_icon_row.dart';
import 'package:docdoc/models/validation_error_model.dart';
import 'package:docdoc/presentation/widgets/shared/button_widget.dart'
    show ButtonWidget, ButtonType;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<SignupBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Account Created Successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/signIn',
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.height * 0.05,
                      vertical: size.width * 0.08,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create Account",
                          style: TextStyleManager.interBold24.copyWith(
                            color: PrimaryColor.primary100,
                          ),
                        ),
                        SizedBox(height: size.height * 0.015),
                        Text(
                          "Sign up now and start exploring all that our\n"
                          " app has to offer. We're excited to welcome \n"
                          "you to our community!",
                          style: TextStyleManager.interRegular14.copyWith(
                            color: BackGround.body,
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        TextFieldWidget(
                          hintText: "Name",
                          controller: userNameController,
                        ),
                        SizedBox(height: size.height * 0.01),
                        TextFieldWidget(
                          hintText: "Email",
                          controller: emailController,
                        ),
                        SizedBox(height: size.height * 0.01),
                        TextFieldWidget(
                          hintText: "Password",
                          controller: passwordController,
                          isPassword: true,
                        ),
                        PhoneNumberFieldWidget(
                          hintText: "Your Phone",
                          controller: phoneController,
                        ),
                        SizedBox(height: size.height * 0.02),
                        ButtonWidget(
                          text: isLoading ? "Registering..." : "Create Account",
                          type: isLoading
                              ? ButtonType.disabled
                              : ButtonType.primary,
                          onTap: isLoading
                              ? null
                              : () {
                                  context.read<SignupBloc>().add(
                                    SignupButtonPressed(
                                      name: userNameController.text,
                                      email: emailController.text,
                                      phone: phoneController.text,
                                      gender: "0", // Default gender
                                      password: passwordController.text,
                                      passwordConfirmation:
                                          passwordController.text,
                                    ),
                                  );
                                },
                        ),
                        SizedBox(height: size.height * 0.04),
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                thickness: 1,
                                color: GrayColor.grey40,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                "Or Sign In With",
                                style: TextStyleManager.interRegular12.copyWith(
                                  color: GrayColor.grey60,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                thickness: 1,
                                color: GrayColor.grey40,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.04),
                        const SocialIconRow(),
                        SizedBox(height: size.height * 0.04),
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
                        SizedBox(height: size.height * 0.04),
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Already have an account ",
                                  style: TextStyleManager.interRegular11
                                      .copyWith(color: GrayColor.grey100),
                                ),
                                TextSpan(
                                  text: "Sign In",
                                  style: TextStyleManager.interRegular11
                                      .copyWith(
                                        color: PrimaryColor.primary100,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/signIn',
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
              ],
            );
          },
        ),
      ),
    );
  }
}
