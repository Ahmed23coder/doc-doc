import 'package:flutter/material.dart';
import 'package:docdoc/core/utils/colors_manager.dart';



// -----------------------------------------------------------
// 1. SOCIAL ICON (Component for a single button)
// -----------------------------------------------------------
class SocialIcon extends StatelessWidget {
  final String assetPath;
  final double size;
  final VoidCallback onTap;
  final Color backgroundColor;
  final List<BoxShadow>? shadow;

  const SocialIcon({
    super.key,
    required this.assetPath,
    this.size = 46,
    required this.onTap,
    this.backgroundColor = GrayColor.grey20,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            boxShadow: shadow ??
                const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ],
          ),
          child: Center(
            child: Image.asset(
              assetPath,
              width: size * 0.6,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------
// 2. SOCIAL ICON ROW (Container used on SignIn/SignUp Screens)
// -----------------------------------------------------------
class SocialIconRow extends StatelessWidget {
  const SocialIconRow({super.key});


  void _onGoogleTap(BuildContext context) {
  }

  void _onFacebookTap(BuildContext context) {
  }

  void _onAppleTap(BuildContext context) {
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialIcon(
          assetPath: "assets/icons/google.png",
          onTap: () => _onGoogleTap(context),
        ),
        SizedBox(width: size.width * 0.06),
        SocialIcon(
          assetPath: "assets/icons/facebook.png",
          onTap: () => _onFacebookTap(context),
        ),
        SizedBox(width: size.width * 0.06),
        SocialIcon(
          assetPath: "assets/icons/apple.png",
          onTap: () => _onAppleTap(context),
        ),
      ],
    );
  }
}