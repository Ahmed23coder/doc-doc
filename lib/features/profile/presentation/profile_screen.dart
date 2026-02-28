import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:docdoc/core/utils/colors_manager.dart';
import 'package:docdoc/core/utils/text_style_manager.dart';
import 'package:docdoc/features/profile/logic/profile_bloc.dart';
import 'package:docdoc/features/profile/logic/profile_event.dart';
import 'package:docdoc/features/profile/logic/profile_state.dart';
import 'package:docdoc/features/profile/presentation/update_profile_screen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch profile data on screen load
    context.read<ProfileBloc>().add(GetUserProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: PrimaryColor.primary100,
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          String userName = '';
          String userEmail = '';

          // Handle States
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (state is ProfileError) {
            return Center(
              child: Text("Error: ${state.message}", style: const TextStyle(color: Colors.white)),
            );
          } else if (state is ProfileLoaded) {
            userName = state.userData.name;
            userEmail = state.userData.email;
          }

          return Stack(
            children: [
              // ------------------ HEADER ------------------
              Positioned(
                top: size.height * 0.06,
                left: size.width * 0.05,
                right: size.width * 0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    Text(
                      "Profile",
                      style: TextStyleManager.interMedium18.copyWith(color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.settings_outlined, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // ------------------ WHITE BODY CONTAINER ------------------
              Positioned(
                top: size.height * 0.22,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.08),

                        // User Info
                        Text(userName, style: TextStyleManager.interBold18.copyWith(color: Colors.black)),
                        SizedBox(height: size.height * 0.005),
                        Text(userEmail, style: TextStyleManager.interRegular12.copyWith(color: Colors.grey)),

                        SizedBox(height: size.height * 0.03),

                        // Action Buttons (My Appointment / Medical Records)
                        _buildActionButtons(size),

                        SizedBox(height: size.height * 0.04),

                        // Menu List
                        _buildMenuOptionsList(size),

                        SizedBox(height: size.height * 0.02),

                        // Logout
                        _buildLogoutButton(size),

                        SizedBox(height: size.height * 0.05),
                      ],
                    ),
                  ),
                ),
              ),

              // ------------------ PROFILE IMAGE ------------------
              Positioned(
                top: size.height * 0.16,
                left: 0,
                right: 0,
                child: Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: size.width * 0.13,
                          backgroundColor: Colors.grey[200],
                          // Use a network image or asset based on your requirement
                          backgroundImage: const AssetImage("assets/images/user_avatar.png"),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                        child: Icon(
                          Icons.edit,
                          size: size.width * 0.04,
                          color: PrimaryColor.primary100,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ---------------------------------------------------
  // WIDGET HELPERS
  // ---------------------------------------------------

  Widget _buildActionButtons(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Container(
        height: size.height * 0.07,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F7),
          borderRadius: BorderRadius.circular(16),
        ),

      ),
    );
  }

  // FIXED: Accepts VoidCallback for onTap
  Widget _actionButton(Size size, String title, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Text(
            title,
            style: TextStyleManager.interMedium14.copyWith(color: color),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOptionsList(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: [
          _buildMenuItem(Icons.person_outline, const Color(0xFFE8F1FF), PrimaryColor.primary100,
              "Personal Information", size, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const UpdateProfileScreen()));
              }),
          _divider(size),
          _buildMenuItem(Icons.medical_services_outlined, const Color(0xFFE9FAEF), Colors.green,
              "My Test & Diagnostic", size, () {}),
          _divider(size),
          _buildMenuItem(Icons.account_balance_wallet_outlined, const Color(0xFFFFF2EE), Colors.orange,
              "Payment", size, () {}),
          _divider(size),
        ],
      ),
    );
  }

  Widget _divider(Size size) => Column(
    children: [
      SizedBox(height: size.height * 0.015),
      const Divider(color: Color(0xFFEDEDED), thickness: 1, height: 1),
      SizedBox(height: size.height * 0.015),
    ],
  );

  Widget _buildMenuItem(
      IconData icon, Color bgColor, Color iconColor, String title, Size size, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Container(
            width: size.width * 0.12,
            height: size.width * 0.12,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor),
          ),
          SizedBox(width: size.width * 0.04),
          Expanded(
            child: Text(title,
                style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w600, color: Colors.black87)),
          ),
          Icon(Icons.arrow_forward_ios, size: size.width * 0.04, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: TextButton(
        onPressed: () => _showLogoutDialog(context),
        style: TextButton.styleFrom(
          foregroundColor: Colors.redAccent,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout),
            SizedBox(width: size.width * 0.02),
            Text("Log Out",
                style: TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 32),
            Text("Logout", style: TextStyleManager.interBold18.copyWith(color: Colors.black, fontSize: 20)),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "You'll need to enter your username and password next time you want to login",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            Divider(color: GrayColor.grey60.withOpacity(0.5), height: 1, thickness: 1),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Center(child: Text("Cancel", style: TextStyle(color: Colors.blue))),
                    ),
                  ),
                  VerticalDivider(color: GrayColor.grey60.withOpacity(0.5), width: 1, thickness: 1),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        // Make sure /signIn route exists in your main.dart
                        Navigator.pushNamedAndRemoveUntil(context, '/signIn', (_) => false);
                      },
                      child: const Center(child: Text("Logout", style: TextStyle(color: Colors.redAccent))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}