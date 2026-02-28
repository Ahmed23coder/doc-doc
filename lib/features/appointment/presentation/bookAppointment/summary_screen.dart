import 'package:docdoc/core/utils/appointment_store.dart';
import 'package:docdoc/core/utils/colors_manager.dart';
import 'package:docdoc/core/utils/text_style_manager.dart';
import 'package:docdoc/features/appointment/presentation/bookAppointment/booking_details_screen.dart';
import 'package:docdoc/models/appointment_model.dart';
import 'package:docdoc/presentation/widgets/shared/button_widget.dart';
import 'package:docdoc/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:docdoc/features/appointment/data/repository/appointment_repository.dart';
import 'package:intl/intl.dart';

class SummaryScreen extends StatelessWidget {
  final DoctorModel doctor;
  final DateTime bookingDate;
  final String bookingTime;
  final String appointmentType;

  const SummaryScreen({
    super.key,
    required this.doctor,
    required this.bookingDate,
    required this.bookingTime,
    required this.appointmentType,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(bookingDate);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Book Appointment"),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepIndicator(size),
                  SizedBox(height: size.height * 0.03),
                  _sectionTitle("Booking Information"),
                  SizedBox(height: size.height * 0.02),
                  _buildInfoCard(
                    icon: Icons.calendar_month,
                    iconColor: PrimaryColor.primary100,
                    iconBg: Secondary.surfaceBlue,
                    title: "Date & Time",
                    subtitle: formattedDate,
                    detail: bookingTime,
                  ),
                  SizedBox(height: size.height * 0.02),
                  _buildInfoCard(
                    icon: Icons.assignment,
                    iconColor: Secondary.fillGreen,
                    iconBg: Secondary.surfaceGreen,
                    title: "Appointment Type",
                    subtitle: appointmentType,
                  ),
                  Divider(color: GrayColor.grey20, height: 40),
                  _sectionTitle("Doctor Information"),
                  SizedBox(height: size.height * 0.02),
                  _buildDoctorCard(),
                  Divider(color: GrayColor.grey20, height: 40),
                  _sectionTitle("Payment Information"),
                  SizedBox(height: size.height * 0.02),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: GrayColor.grey20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.payment, color: Colors.blue),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Paypal",
                              style: TextStyleManager.interMedium14.copyWith(
                                color: GrayColor.grey100,
                              ),
                            ),
                            Text(
                              "***** ***** ***** 37842",
                              style: TextStyleManager.interRegular12.copyWith(
                                color: GrayColor.grey60,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Change",
                            style: TextStyleManager.interMedium12.copyWith(
                              color: PrimaryColor.primary100,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.04),
            Container(
              padding: EdgeInsets.all(size.width * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Payment Info"),
                  SizedBox(height: size.height * 0.02),
                  _buildPriceRow("Subtotal", "\$4694"),
                  SizedBox(height: size.height * 0.01),
                  _buildPriceRow("Tax", "\$250"),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: GrayColor.grey30, thickness: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Payment Total",
                        style: TextStyleManager.interBold14.copyWith(
                          color: GrayColor.grey100,
                        ),
                      ),
                      Text(
                        "\$4944",
                        style: TextStyleManager.interBold16.copyWith(
                          color: PrimaryColor.primary100,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),
                  ButtonWidget(
                    text: "Book Now",
                    size: ButtonSize.large,
                    width: double.infinity,
                    type: ButtonType.primary,
                    onTap: () async {
                      final newAppointment = AppointmentData(
                        id: DateTime.now().millisecondsSinceEpoch,
                        doctor: doctor,
                        appointmentTime: bookingTime,
                        appointmentEndTime:
                            "11:00 AM",
                        status: 'upcoming',
                        appointmentPrice: 20,
                      );

                      AppointmentsStore.addAppointment(newAppointment);

                      try {
                        await AppointmentRepository().storeAppointment(
                          doctorId: doctor.id,
                          startTime: bookingTime,
                        );
                      } catch (e) {
                        debugPrint('Error storing appointment: $e');
                      }

                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingDetailsScreen(
                              doctor: doctor,
                              bookingDate: bookingDate,
                              bookingTime: bookingTime,
                              appointmentType: appointmentType,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
    title,
    style: TextStyleManager.interBold16.copyWith(color: GrayColor.grey100),
  );
  Widget _buildStepIndicator(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _stepItem("1", "Date & Time", StepState.completed),
        _stepLine(size, true),
        _stepItem("2", "Payment", StepState.completed),
        _stepLine(size, true),
        _stepItem("3", "Summary", StepState.active),
      ],
    );
  }

  Widget _stepItem(String number, String label, StepState state) {
    Color circleColor = state == StepState.completed
        ? Secondary.fillGreen
        : (state == StepState.active
              ? PrimaryColor.primary100
              : GrayColor.grey20);
    Color textColor = state == StepState.completed || state == StepState.active
        ? Colors.white
        : GrayColor.grey50;
    Color labelColor = state == StepState.completed
        ? Secondary.fillGreen
        : (state == StepState.active ? GrayColor.grey100 : GrayColor.grey50);
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
          child: Text(
            number,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyleManager.interMedium10.copyWith(color: labelColor),
        ),
      ],
    );
  }

  Widget _stepLine(Size size, bool isCompleted) => Container(
    width: size.width * 0.08,
    height: 1,
    color: isCompleted ? Secondary.fillGreen : GrayColor.grey40,
  );

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
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

  Widget _buildPriceRow(String label, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyleManager.interRegular14.copyWith(
            color: GrayColor.grey60,
          ),
        ),
        Text(
          price,
          style: TextStyleManager.interMedium14.copyWith(
            color: GrayColor.grey100,
          ),
        ),
      ],
    );
  }
}

enum StepState { completed, active, inactive }
