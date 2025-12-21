import 'package:docdoc/core/utils/colors_manager.dart'; //
import 'package:docdoc/core/utils/text_style_manager.dart'; //
import 'package:docdoc/features/appointment/presentation/myAppointment/reschedule_detials_screen.dart';
import 'package:docdoc/models/appointment_model.dart'; //
import 'package:docdoc/presentation/widgets/shared/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RescheduleAppointmentScreen extends StatefulWidget {
  final AppointmentData appointment;

  const RescheduleAppointmentScreen({super.key, required this.appointment});

  @override
  State<RescheduleAppointmentScreen> createState() =>
      _RescheduleAppointmentScreenState();
}

class _RescheduleAppointmentScreenState
    extends State<RescheduleAppointmentScreen> {
  // Initialize with some default values or parsed from current appointment if possible
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = -1;
  int _selectedTypeIndex = 0;

  final List<DateTime> _dates = List.generate(
    14,
    (index) => DateTime.now().add(Duration(days: index)),
  );
  final List<String> _times = [
    "09:00 AM",
    "09:30 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "11:30 AM",
  ];
  final List<Map<String, dynamic>> _appointmentTypes = [
    {"icon": Icons.person, "title": "In Person"},
    {"icon": Icons.videocam, "title": "Video Call"},
    {"icon": Icons.phone, "title": "Phone Call"},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Reschedule"),
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
        ), //
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SELECT DATE ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Date",
                  style: TextStyleManager.interBold16.copyWith(
                    color: GrayColor.grey100,
                  ),
                ), //
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Set Manual",
                    style: TextStyleManager.interMedium12.copyWith(
                      color: PrimaryColor.primary100,
                    ),
                  ), //
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            SizedBox(
              height: 75,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _dates.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) => _buildDateCard(index),
              ),
            ),

            SizedBox(height: size.height * 0.03),

            // --- AVAILABLE TIME ---
            Text(
              "Available Time",
              style: TextStyleManager.interBold16.copyWith(
                color: GrayColor.grey100,
              ),
            ), //
            SizedBox(height: size.height * 0.015),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: size.width * 0.03,
                runSpacing: size.height * 0.015,
                children: List.generate(
                  _times.length,
                  (index) => _buildTimeChip(index, size),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.03),

            // --- APPOINTMENT TYPE ---
            Text(
              "Appointment Type",
              style: TextStyleManager.interBold16.copyWith(
                color: GrayColor.grey100,
              ),
            ), //
            SizedBox(height: size.height * 0.015),
            ...List.generate(
              _appointmentTypes.length,
              (index) => _buildTypeCard(index, size),
            ),

            SizedBox(height: size.height * 0.04),

            // --- RESCHEDULE BUTTON ---
            ButtonWidget(
              text: "Reschedule",
              size: ButtonSize.large,
              width: double.infinity,
              type: ButtonType.primary,
              onTap: () {
                if (_selectedTimeIndex == -1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select a time")),
                  );
                  return;
                }

                // 1. Prepare New Data
                final newDate = _dates[_selectedDateIndex];
                final newTime = _times[_selectedTimeIndex];

                // 2. UPDATE the store (Optional: if you want it to update in the list immediately)
                // AppointmentsStore.updateAppointment(widget.appointment.id, newDate, newTime);

                // 3. Navigate to Details Screen with REAL Data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RescheduleDetailsScreen(
                      // Pass data from the current appointment object
                      doctorName: widget.appointment.doctor?.name ?? "Unknown",
                      doctorSpecialty: widget.appointment.doctor?.specialization?.name ?? "General",
                      doctorLocation: widget.appointment.doctor?.city?.name ?? "Hospital",
                      doctorImage: widget.appointment.doctor?.photo ?? "https://via.placeholder.com/150",

                      // Pass new user selection
                      newDate: newDate,
                      newTime: newTime,
                      appointmentType: _appointmentTypes[_selectedTypeIndex]['title'],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildDateCard(int index) {
    final date = _dates[index];
    final isSelected = _selectedDateIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedDateIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isSelected ? 50.0 : 38.0,
        height: isSelected ? 65.0 : 44.0,
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? PrimaryColor.primary100
              : Secondary.surfaceText, //
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? PrimaryColor.primary100 : Secondary.surfaceText,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEE').format(date),
              style: TextStyle(
                fontSize: isSelected ? 11 : 9,
                color: isSelected ? Colors.white : GrayColor.grey50,
              ),
            ), //
            const SizedBox(height: 2),
            Text(
              date.day.toString().padLeft(2, '0'),
              style: TextStyle(
                fontSize: isSelected ? 16 : 13,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : GrayColor.grey50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeChip(int index, Size size) {
    final isSelected = _selectedTimeIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTimeIndex = index),
      child: Container(
        width: size.width * 0.4, // Approx half width
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? PrimaryColor.primary100 : Colors.white, //
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? PrimaryColor.primary100 : GrayColor.grey20,
          ),
        ),
        child: Text(
          _times[index],
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : GrayColor.grey100,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTypeCard(int index, Size size) {
    final type = _appointmentTypes[index];
    final isSelected = _selectedTypeIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTypeIndex = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              type['icon'],
              color: isSelected ? PrimaryColor.primary100 : GrayColor.grey60,
            ), //
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                type['title'],
                style: TextStyleManager.interMedium14.copyWith(
                  color: GrayColor.grey100,
                ),
              ),
            ), //
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: PrimaryColor.primary100,
                size: 20,
              )
            else
              const Icon(
                Icons.circle_outlined,
                color: GrayColor.grey30,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
