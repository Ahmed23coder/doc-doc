import 'package:docdoc/core/layout/navigation_cubit.dart'; // Ensure this path is correct based on where you put the file
import 'package:docdoc/features/home/presentation/screens/home_screen.dart';
import 'package:docdoc/features/profile/presentation/profile_screen.dart';
import 'package:docdoc/features/search/presentation/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:docdoc/core/utils/colors_manager.dart';
import 'package:flutter_svg/svg.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  final List<Widget> pages = const [
    HomeScreen(),
    Center(child: Text("Message")),
    SearchScreen(),
    Center(child: Text("Appointments")),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            backgroundColor: Colors.white,
            extendBody: true,
            body: pages[currentIndex],

            // ------------------ FLOATING CENTER BUTTON ------------------
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: GestureDetector(
              onTap: () {
                context.read<NavigationCubit>().changeIndex(2); // search
              },
              child: Container(
                height: 72,
                width: 72,
                // Added a margin to lift it slightly off the bar if needed
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: PrimaryColor.primary100,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),

            // ------------------ BOTTOM NAV BAR ------------------
            bottomNavigationBar: BottomAppBar(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 15,
              shadowColor: Colors.black.withOpacity(0.1),

              child: SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // LEFT ITEMS
                    navItem(
                      iconPath: "assets/icons/home.svg",
                      index: 0,
                      currentIndex: currentIndex,
                      onTap: () => context.read<NavigationCubit>().changeIndex(0),
                    ),
                    navItem(
                      iconPath: "assets/icons/message.svg",
                      index: 1,
                      currentIndex: currentIndex,
                      onTap: () => context.read<NavigationCubit>().changeIndex(1),
                    ),

                    const SizedBox(width: 40), // Space for FAB

                    // RIGHT ITEMS
                    navItem(
                      iconPath: "assets/icons/calendar.svg",
                      index: 3,
                      currentIndex: currentIndex,
                      onTap: () => context.read<NavigationCubit>().changeIndex(3),
                    ),
                    navItem(
                      icon: Icons.person_outline,
                      index: 4,
                      currentIndex: currentIndex,
                      onTap: () => context.read<NavigationCubit>().changeIndex(4),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ------------------ NAV ITEM LOGIC ------------------
  Widget navItem({
    String? iconPath,
    IconData? icon,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
  }) {
    final bool isSelected = currentIndex == index;
    final Color color = isSelected ? PrimaryColor.primary100 : GrayColor.grey60;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: iconPath != null
            ? SvgPicture.asset(
          iconPath,
          width: 28,
          height: 28,
          colorFilter: ColorFilter.mode(
            color,
            BlendMode.srcIn,
          ),
        )
            : Icon(
          icon,
          size: 28,
          color: color,
        ),
      ),
    );
  }
}