import 'package:docdoc/core/layout/main_layout.dart';
import 'package:docdoc/core/utils/colors_manager.dart';
import 'package:docdoc/core/utils/text_style_manager.dart';
import 'package:docdoc/features/home/presentation/screens/home_screen.dart';
import 'package:docdoc/presentation/widgets/shared/button_widget.dart';
import 'package:flutter/material.dart';

class ReviewBottomSheet extends StatefulWidget {
  const ReviewBottomSheet({super.key});

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(
        left: size.width * 0.05,
        right: size.width * 0.05,
        top: 20,
        // Adjust padding for keyboard
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: GrayColor.grey30,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: size.height * 0.02),

          Text(
            "Give Rate",
            style: TextStyleManager.interBold18.copyWith(color: GrayColor.grey100),
          ),
          SizedBox(height: size.height * 0.03),

          // Star Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                onPressed: () => setState(() => _rating = index + 1),
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Warning.warning100,
                  size: 32,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                constraints: const BoxConstraints(),
              );
            }),
          ),

          SizedBox(height: size.height * 0.03),

          Text(
            "Share your feedback about the doctor",
            style: TextStyleManager.interMedium14.copyWith(color: GrayColor.grey60),
          ),
          SizedBox(height: size.height * 0.02),

          // Review Text Field
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: GrayColor.grey20,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              maxLines: 4,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Your review",
                hintStyle: TextStyleManager.interRegular14.copyWith(color: GrayColor.grey50),
              ),
            ),
          ),

          SizedBox(height: size.height * 0.03),

          // Done Button
          ButtonWidget(
            text: "Done",
            size: ButtonSize.large,
            width: double.infinity,
            type: ButtonType.primary,
            onTap: () {
              // Navigate to Home
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainLayout()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}