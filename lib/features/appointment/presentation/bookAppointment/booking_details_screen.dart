import 'package:docdoc/core/utils/colors_manager.dart';
import 'package:docdoc/core/utils/text_style_manager.dart';
import 'package:docdoc/features/appointment/presentation/bookAppointment/review_buttom_sheet.dart';
import 'package:docdoc/presentation/widgets/shared/button_widget.dart';
import 'package:docdoc/models/doctor_model.dart';
import 'package:flutter/material.dart';

class BookingDetailsScreen extends StatelessWidget {
  final DoctorModel doctor;
  final DateTime bookingDate;
  final String bookingTime;
  final String appointmentType;

  const BookingDetailsScreen({
    super.key,
    required this.doctor,
    required this.bookingDate,
    required this.bookingTime,
    required this.appointmentType,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Format: "Wednesday, 08 May 2023" (Using simple string interpolation for now)
    final dateString =
        "${bookingDate.day}/${bookingDate.month}/${bookingDate.year}";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Details"), // Matches screenshot "Details"
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        titleTextStyle: TextStyleManager.interBold18.copyWith(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(size.width * 0.05),
                child: Column(
                  children: [
                    SizedBox(height: size.height * 0.02),

                    // --- SUCCESS ICON ---
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Secondary.fillGreen, // Green color
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),

                    // --- TITLE ---
                    Text(
                      "Booking Confirmed",
                      style: TextStyleManager.interBold20.copyWith(
                        color: GrayColor.grey100,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      "Dr. ${doctor.name} is a specialist in ${doctor.specialization?.name ?? 'General'}",
                      textAlign: TextAlign.center,
                      style: TextStyleManager.interRegular12.copyWith(
                        color: GrayColor.grey60,
                      ),
                    ),

                    SizedBox(height: size.height * 0.04),

                    // --- BOOKING INFO ---
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Booking Information",
                        style: TextStyleManager.interBold16.copyWith(
                          color: GrayColor.grey100,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),

                    // Date & Time
                    _buildInfoCard(
                      icon: Icons.calendar_month,
                      iconBg: Secondary.surfaceBlue,
                      iconColor: PrimaryColor.primary100,
                      title: "Date & Time",
                      subtitle: dateString,
                      detail: bookingTime,
                    ),
                    SizedBox(height: size.height * 0.02),

                    // Appointment Type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoCard(
                          icon: Icons.assignment,
                          iconBg: Secondary.surfaceGreen,
                          iconColor: Secondary.fillGreen,
                          title: "Appointment Type",
                          subtitle: appointmentType,
                        ),
                        if (appointmentType.toLowerCase().contains("person"))
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Get Location",
                              style: TextStyleManager.interMedium12.copyWith(
                                color: PrimaryColor.primary100,
                              ),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.02),
                    Divider(color: GrayColor.grey20, thickness: 1),
                    SizedBox(height: size.height * 0.02),

                    // --- DOCTOR INFO ---
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Doctor Information",
                        style: TextStyleManager.interBold16.copyWith(
                          color: GrayColor.grey100,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    _buildDoctorCard(),
                  ],
                ),
              ),
            ),

            // --- DONE BUTTON ---
            Padding(
              padding: EdgeInsets.all(size.width * 0.05),
              child: ButtonWidget(
                text: "Done",
                size: ButtonSize.large,
                width: double.infinity,
                type: ButtonType.primary,
                onTap: () {
                  // Show Review Bottom Sheet
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const ReviewBottomSheet(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildInfoCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? detail,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyleManager.interMedium14.copyWith(
                color: GrayColor.grey100,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyleManager.interRegular12.copyWith(
                color: GrayColor.grey60,
              ),
            ),
            if (detail != null) ...[
              const SizedBox(height: 2),
              Text(
                detail,
                style: TextStyleManager.interRegular12.copyWith(
                  color: GrayColor.grey60,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildDoctorCard() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade200,
            image: DecorationImage(
              image: NetworkImage(doctor.photo),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor.name,
                style: TextStyleManager.interBold14.copyWith(
                  color: GrayColor.grey100,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${doctor.specialization?.name ?? 'General'} | ${doctor.city?.name ?? 'Hospital'}",
                style: TextStyleManager.interRegular12.copyWith(
                  color: GrayColor.grey60,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: Warning.warning100, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    "4.8 (4,279 reviews)",
                    style: TextStyleManager.interRegular11.copyWith(
                      color: GrayColor.grey60,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
