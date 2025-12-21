import 'package:docdoc/core/utils/colors_manager.dart';
import 'package:docdoc/core/utils/text_style_manager.dart';
import 'package:docdoc/features/appointment/presentation/bookAppointment/book_appointment_screen.dart';
import 'package:docdoc/models/doctor_model.dart';
import 'package:docdoc/presentation/widgets/shared/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final DoctorModel doctor;
  const DoctorDetailsScreen({super.key, required this.doctor});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.doctor.name,
          style: TextStyleManager.interSemiBold18.copyWith(
            color: GrayColor.grey100,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz, color: Colors.black),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.05,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      _buildDoctorHeader(size),
                      SizedBox(height: size.height * 0.03),

                      // Tabs
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: GrayColor.grey30,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            _buildTabButton(0, "About"),
                            _buildTabButton(1, "Location"),
                            _buildTabButton(2, "Reviews"),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),

                      _buildSelectedContent(),
                    ],
                  ),
                ),
              ),
            ),

            // --- BOOK APPOINTMENT BUTTON ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ButtonWidget(
                text: "Book Appointment",
                onTap: () {
                  // NAVIGATE AND PASS DOCTOR
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BookAppointmentScreen(doctor: widget.doctor),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ... (Keep your existing helper widgets: _buildDoctorHeader, _buildTabButton, etc. unchanged)
  Widget _buildDoctorHeader(Size size) {
    return Row(
      children: [
        Container(
          width: size.width * 0.28,
          height: size.height * 0.28,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage(widget.doctor.photo),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: size.width * 0.04),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.doctor.name, style: TextStyleManager.interSemiBold16),
              const SizedBox(height: 8),
              Text(
                "${widget.doctor.specialization?.name ?? 'Specialist'} | ${widget.doctor.degree}",
                style: TextStyleManager.interMedium12.copyWith(
                  color: GrayColor.grey60,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Warning.warning100, size: 18),
                  const SizedBox(width: 4),
                  const Text("4.8", style: TextStyleManager.interMedium14),
                  const SizedBox(width: 4),
                  Text(
                    "(4,279 reviews)",
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

  Widget _buildTabButton(int index, String title) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: isSelected
                ? const Border(
                    bottom: BorderSide(
                      color: PrimaryColor.primary100,
                      width: 3,
                    ),
                  )
                : const Border(
                    bottom: BorderSide(color: Colors.transparent, width: 3),
                  ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyleManager.interSemiBold14.copyWith(
              color: isSelected ? PrimaryColor.primary100 : GrayColor.grey60,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildAboutSection();
      case 1:
        return _buildLocationSection();
      case 2:
        return _buildReviewsSection();
      default:
        return _buildAboutSection();
    }
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("About me", style: TextStyleManager.interSemiBold18),
        const SizedBox(height: 10),
        Text(
          widget.doctor.description.isNotEmpty
              ? widget.doctor.description
              : "No description available.",
          style: TextStyleManager.interRegular12.copyWith(
            color: GrayColor.grey60,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    // Keep your map logic
    final LatLng doctorLocation = LatLng(30.0444, 31.2357);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Practice Place", style: TextStyleManager.interSemiBold16),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: GrayColor.grey30),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.location_on,
                color: PrimaryColor.primary100,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  "${widget.doctor.address} - ${widget.doctor.city?.name ?? ''}",
                  style: TextStyleManager.interRegular12.copyWith(
                    color: GrayColor.grey60,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GrayColor.grey20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: doctorLocation,
                initialZoom: 14.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.docdoc',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: doctorLocation,
                      width: 50,
                      height: 50,
                      child: const Icon(
                        Icons.location_on,
                        size: 40,
                        color: Secondary.fillRed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      children: [
        _buildReviewItem("Ahmed Ali", "Great doctor, very patient!", 5.0),
        const SizedBox(height: 10),
        _buildReviewItem(
          "Sara Mohamed",
          "The clinic is clean and organized.",
          4.5,
        ),
      ],
    );
  }

  Widget _buildReviewItem(String name, String comment, double rating) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GrayColor.grey20,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: TextStyleManager.interBold14),
              Row(
                children: [
                  const Icon(Icons.star, color: Warning.warning100, size: 14),
                  Text(
                    rating.toString(),
                    style: TextStyleManager.interMedium12,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            comment,
            style: TextStyleManager.interRegular12.copyWith(
              color: GrayColor.grey60,
            ),
          ),
        ],
      ),
    );
  }
}
