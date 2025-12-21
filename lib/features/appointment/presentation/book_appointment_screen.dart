import 'package:docdoc/core/utils/colors_manager.dart';
import 'package:docdoc/core/utils/text_style_manager.dart';
import 'package:flutter/material.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final int _selectedDateIndex = 0;
  final int _selectedTimeIndex = -1;
  final int _selectedTypeIndex = 0;

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
    "01:00 PM",
    "01:30 PM",
    "02:00 PM",
    "02:30 PM",
    "03:00 PM",
    "03:30 PM",
  ];

  final List<Map<String, dynamic>> _appointmentTypes = [
    {"icon": Icons.person, "title": "In Person", "subtitle": "Doctor's Office"},
    {
      "icon": Icons.videocam,
      "title": "Video Call",
      "subtitle": "Online Meeting",
    },
    {"icon": Icons.phone, "title": "Phone Call", "subtitle": "Voice Only"},
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Book Appointment",
          style: TextStyleManager.interBold18.copyWith(
            color: GrayColor.grey100,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: GrayColor.grey100),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepIndicator(size),
                SizedBox(height: size.height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildStepIndicator(Size size) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _stepItem("1", "Select Time", true),
      _stepItem("1", "Payment", true),
      _stepItem("1", "Summary", true),
    ],
  );
}

Widget _stepItem(String number, String label, bool isActive) {
  return Column(
    children: [
      Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? PrimaryColor.primary100 : GrayColor.grey30,
          shape: BoxShape.circle,
        ),
        child: Text(
          number,
          style: TextStyle(color: isActive ? Colors.white : Colors.grey),
        ),
      ),
      SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: isActive ? PrimaryColor.primary100 : Colors.grey,
        ),
      ),
    ],
  );
}
