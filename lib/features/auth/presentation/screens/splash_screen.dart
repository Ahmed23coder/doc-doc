import 'package:docdoc/core/utils/colors_manager.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _goNext();
  }

  void _goNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/onboarding', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GrayColor.grey20,

      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
              "assets/images/backlogo.png",
              fit: BoxFit.contain,
            height: MediaQuery.of(context).size.height,
           width: MediaQuery.of(context).size.width,
          ),

          Center(child: Image.asset(
              "assets/images/logo.png",
              width: 270
          )
          ),
        ],
      ),
    );
  }
}
