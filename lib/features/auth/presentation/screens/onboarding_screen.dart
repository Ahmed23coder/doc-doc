import 'package:docdoc/core/utils/text_style_manager.dart';
import 'package:docdoc/presentation/widgets/shared/button_widget.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/colors_manager.dart';


class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: BackGround.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.3,
                vertical: size.height * 0.07,
              ),
              child: Image.asset("assets/images/logo.png"),
            ),
          ),
          Positioned(
            top: size.height * 0.16,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/images/back2x.png",
              height: size.height * 0.6,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: size.height * 0.2,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/images/doc.png",
              height: size.height * 0.66,
              fit: BoxFit.contain,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size.height * 0.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,

                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.0),
                  ],
                  // OPTIONAL: Adjust stops for a non-linear, smoother fall-off
                  stops: const [0.25,0.9],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              size.width * 0.06,
              size.height * 0.2,
              size.width * 0.06,
              size.height * 0.06,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    "Best Doctor\nAppointment App",
                    style: TextStyleManager.interBold32.copyWith(
                      color: PrimaryColor.primary100,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.017),
                Center(
                  child: Text(
                    "Manage and schedule all of your medical appointments easily\n"
                    " with Docdoc to get a new experience.",
                    style: TextStyleManager.interRegular10.copyWith(
                      color: BackGround.body,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.07),

                ButtonWidget(
                  text: "Get Started",
                  size: ButtonSize.large,
                  type: ButtonType.primary,
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/signIn', (route)=> false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
