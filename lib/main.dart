import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:docdoc/features/auth/data/repository/auth_repository.dart';
import 'package:docdoc/features/auth/logic/login_bloc.dart';
import 'package:docdoc/features/auth/logic/signup_bloc.dart';
import 'package:docdoc/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:docdoc/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:docdoc/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:docdoc/features/auth/presentation/screens/splash_screen.dart';
import 'package:docdoc/features/home/data/repository/home_repository.dart';
import 'package:docdoc/features/home/logic/home_bloc.dart';
import 'package:docdoc/features/profile/data/repository/profile_repository.dart';
import 'package:docdoc/features/profile/logic/profile_bloc.dart';

import 'core/layout/main_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();
    final homeRepository = HomeRepository();
    final profileRepository = ProfileRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(authRepository),
        ),
        BlocProvider<SignupBloc>(
          create: (_) => SignupBloc(authRepository),
        ),
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc(homeRepository),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(profileRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/splashScreen': (_) => const SplashScreen(),
          '/onboarding': (_) => const OnboardingScreen(),
          '/signUp': (_) => const SignUpScreen(),
          '/signIn': (_) => const SignInScreen(),
          '/homeScreen': (_) => const MainLayout(),
        },
        home: const SplashScreen(),
      ),
    );
  }
}
