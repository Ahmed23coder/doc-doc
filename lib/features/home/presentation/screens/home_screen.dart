import 'package:docdoc/core/utils/colors_manager.dart';
import 'package:docdoc/core/utils/text_style_manager.dart';
import 'package:docdoc/features/home/logic/home_bloc.dart';
import 'package:docdoc/features/home/logic/home_event.dart';
import 'package:docdoc/features/home/logic/home_state.dart';
import 'package:docdoc/features/home/presentation/screens/recommendation_doctor_screen.dart';
import 'package:docdoc/features/home/presentation/widgets/specializations_list_widget.dart';
import 'package:docdoc/features/home/presentation/widgets/doctors_list_widget.dart';
import 'package:docdoc/presentation/widgets/shared/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data when screen initializes
    context.read<HomeBloc>().add(const FetchHomeDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: PrimaryColor.primary100,
                ),
              );
            } else if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.error,
                      style: TextStyleManager.interMedium16.copyWith(
                        color: Secondary.fillRed,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: size.height * 0.02),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PrimaryColor.primary100,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => context.read<HomeBloc>().add(
                        const FetchHomeDataEvent(),
                      ),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            } else if (state is HomeSuccess) {
              final specializations = state.homeData;
              final userName = state.userName;
              // Extract all doctors from specializations
              final allDoctors = specializations
                  .expand((element) => element.doctors)
                  .toList();

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.05,
                    horizontal: size.width * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      _buildHomeHeader(size, userName),

                      SizedBox(height: size.height * 0.065),

                      // Banner
                      _buildBanner(size),
                      SizedBox(height: size.height * 0.02),

                      // Specializations Section
                      _buildSectionHeader("Doctor Speciality", () {
                        // Navigate to Speciality screen if needed
                      }),
                      SizedBox(height: size.height * 0.02),
                      SpecializationsListWidget(
                        specializations: specializations,
                      ),

                      SizedBox(height: size.height * 0.02),

                      // Doctors Section
                      _buildSectionHeader("Recommendation Doctor", () {
                        // Pass the navigation logic here where 'allDoctors' is visible
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecommendationDoctorScreen(
                              doctorsList: allDoctors,
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: size.height * 0.02),
                      DoctorsListWidget(doctorsList: allDoctors),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildHomeHeader(Size size, String userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, $userName!",
              style: TextStyleManager.interBold18.copyWith(
                color: GrayColor.grey100,
              ),
            ),
            SizedBox(height: size.height * 0.002),
            Text(
              "How are you today?",
              style: TextStyleManager.interRegular11.copyWith(
                color: GrayColor.grey80,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: size.width * 0.06,
          backgroundColor: GrayColor.grey20,
          child: Icon(
            Icons.notifications_none,
            color: GrayColor.grey100,
            size: size.width * 0.07,
          ),
        ),
      ],
    );
  }

  Widget _buildBanner(Size size) {
    return Container(
      width: double.infinity,
      height: size.height * 0.2,
      decoration: BoxDecoration(
        color: PrimaryColor.primary100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: size.width * 0.65,
            top: -110,
            child: Transform.rotate(
              angle: 0.7,
              child: Container(
                width: 81.51,
                height: 650,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0x8FFFFFFF).withOpacity(0.1),
                      const Color(0x00FFFFFF).withOpacity(0.02),
                    ],
                    stops: const [0.25, 0.9],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: size.width * 0.35,
            top: -333,
            child: Transform.rotate(
              angle: 0.7,
              child: Container(
                width: 103,
                height: 800,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0x8FFFFFFF).withOpacity(0.1),
                      const Color(0x00FFFFFF).withOpacity(0.02),
                    ],
                    stops: const [0.25, 0.9],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Book and \n"
                      "schedule with\n"
                      " nearest doctor",
                  style: TextStyleManager.interMedium18.copyWith(
                    color: GrayColor.grey20,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                ButtonWidget(
                  text: "Find Nearby",
                  type: ButtonType.white,
                  size: ButtonSize.small,
                  width: size.width * 0.3,
                  onTap: () {
                    // navigate to Find nearby doctor
                  },
                ),
              ],
            ),
          ),
          Positioned(
            right: size.width * 0.03,
            bottom: 0,
            child: Image.asset(
              "assets/images/doctor_banner.png",
              height: size.height * 0.24,
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyleManager.interSemiBold18.copyWith(
            color: GrayColor.grey100,
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            "See All",
            style: TextStyleManager.interRegular12.copyWith(
              color: PrimaryColor.primary100,
            ),
          ),
        ),
      ],
    );
  }
}