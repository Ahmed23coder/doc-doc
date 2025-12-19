import 'package:docdoc/core/utils/colors_manager.dart';
import 'package:docdoc/core/utils/text_style_manager.dart';
import 'package:docdoc/features/profile/logic/profile_bloc.dart';
import 'package:docdoc/features/profile/logic/profile_event.dart';
import 'package:docdoc/features/profile/logic/profile_state.dart';
import 'package:docdoc/models/user_profile_model.dart';
import 'package:docdoc/models/validation_error_model.dart';
import 'package:docdoc/presentation/widgets/shared/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();

    final currentState = context.read<ProfileBloc>().state;
    if (currentState is ProfileLoaded) {
      _nameController.text = currentState.userData.name;
      _emailController.text = currentState.userData.email;
      _phoneController.text = currentState.userData.phone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Media Query for responsive sizing
    final size = MediaQuery.of(context).size;

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          // ---------------------------------------------------------
          // 1. ERROR DIALOG
          // ---------------------------------------------------------
          _showDialog(
            context: context,
            title: "Error",
            message: state.message,
            isSuccess: false,
            size: size,
          );
        } else if (state is ProfileLoaded) {
          // ---------------------------------------------------------
          // 2. SUCCESS DIALOG
          // ---------------------------------------------------------
          _showDialog(
            context: context,
            title: "Success",
            message: "Profile Updated Successfully",
            isSuccess: true,
            size: size,
            onOkPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        }
      },
      builder: (context, state) {
        bool isLoading = state is ProfileLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                  Icons.arrow_back_ios,
                  size: size.width * 0.05,
                  color: Colors.black
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Personal information",
              style: TextStyleManager.interMedium18.copyWith(
                color: Colors.black,
                fontSize: size.width * 0.045, // Responsive font
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.06, // 6% of screen width
                vertical: size.height * 0.02   // 2% of screen height
            ),
            child: Column(
              children: [
                // ---------------------------------------------------
                // 1. Profile Picture
                // ---------------------------------------------------
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          color: Colors.grey[200],
                        ),
                        child: CircleAvatar(
                          radius: size.width * 0.15, // Responsive Radius
                          backgroundImage: const AssetImage("assets/images/user_avatar.png"),
                        ),
                      ),
                      Container(
                        height: size.width * 0.09,
                        width: size.width * 0.09,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F4F7),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: PrimaryColor.primary100,
                          size: size.width * 0.05,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.03),

                // ---------------------------------------------------
                // 2. Fields
                // ---------------------------------------------------
                TextFieldWidget(
                  hintText: "Name",
                  controller: _nameController,
                ),

                TextFieldWidget(
                  hintText: "Email",
                  controller: _emailController,
                ),

                TextFieldWidget(
                  hintText: "Password",
                  controller: _passwordController,
                  isPassword: true,
                ),

                PhoneNumberFieldWidget(
                  hintText: "Phone Number",
                  controller: _phoneController,
                ),

                SizedBox(height: size.height * 0.03),

                // ---------------------------------------------------
                // 3. Info Text
                // ---------------------------------------------------
                Text(
                  "When you set up your personal information settings, you should take care to provide accurate information.",
                  style: TextStyleManager.interRegular12.copyWith(
                    color: Colors.grey[500],
                    height: 1.5,
                    fontSize: size.width * 0.03, // Responsive text
                  ),
                ),

                SizedBox(height: size.height * 0.05),

                // ---------------------------------------------------
                // 4. Save Button
                // ---------------------------------------------------
                ButtonWidget(
                  width: double.infinity,
                  size: ButtonSize.large,
                  text: isLoading ? "Saving..." : "Save",
                  type: isLoading ? ButtonType.disabled : ButtonType.primary,
                  onTap: () {
                    if (isLoading) return;
                    context.read<ProfileBloc>().add(
                      UpdateUserProfileEvent(
                        updatedData: UserData(
                          id: 0,
                          name: _nameController.text,
                          email: _emailController.text,
                          phone: _phoneController.text,
                          gender: "0",
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // -----------------------------------------------------------
  // HELPER FUNCTION: Shows Custom Dialog
  // -----------------------------------------------------------
  void _showDialog({
    required BuildContext context,
    required String title,
    required String message,
    required bool isSuccess,
    required Size size,
    VoidCallback? onOkPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: EdgeInsets.all(size.width * 0.05),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: isSuccess ? Colors.green : Colors.red,
                size: size.width * 0.15, // Responsive Icon
              ),
              SizedBox(height: size.height * 0.02),
              // Title
              Text(
                title,
                style: TextStyleManager.interBold18.copyWith(
                    color: Colors.black,
                    fontSize: size.width * 0.05
                ),
              ),
              SizedBox(height: size.height * 0.01),
              // Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyleManager.interRegular14.copyWith(
                    color: Colors.grey,
                    fontSize: size.width * 0.035
                ),
              ),
              SizedBox(height: size.height * 0.03),
              // OK Button
              SizedBox(
                width: double.infinity,
                height: size.height * 0.06,
                child: ElevatedButton(
                  onPressed: onOkPressed ?? () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PrimaryColor.primary100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}