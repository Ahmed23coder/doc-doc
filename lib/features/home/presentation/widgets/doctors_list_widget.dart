import 'package:flutter/material.dart';
import 'package:docdoc/core/utils/colors_manager.dart';
import 'package:docdoc/core/utils/text_style_manager.dart';
import 'package:docdoc/models/doctor_model.dart';
import 'package:docdoc/features/home/presentation/screens/doctor_details_screen.dart';

class DoctorsListWidget extends StatelessWidget {
  final List<DoctorModel> doctorsList;

  const DoctorsListWidget({super.key, required this.doctorsList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: doctorsList.length,
      itemBuilder: (context, index) {
        return _buildDoctorCard(context, doctorsList[index]);
      },
    );
  }

  Widget _buildDoctorCard(BuildContext context, DoctorModel doctor) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorDetailsScreen(doctor: doctor),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: size.height * 0.02),
        padding: EdgeInsets.all(size.width * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: GrayColor.grey30),
        ),
        child: Row(
          children: [
            Container(
              width: size.width * 0.25,
              height: size.width * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: GrayColor.grey20,
                image: DecorationImage(
                  image: NetworkImage(
                    doctor.photo ?? 'https://via.placeholder.com/150',
                  ),
                  fit: BoxFit.cover,
                  onError: (e, s) => const Icon(Icons.person, color: GrayColor.grey60),
                ),
              ),
            ),
            SizedBox(width: size.width * 0.04),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: TextStyleManager.interBold16.copyWith(
                      color: GrayColor.grey100,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    "${doctor.degree} | ${doctor.phone}",
                    style: TextStyleManager.interMedium12.copyWith(
                      color: GrayColor.grey60,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      const Icon(
                        Icons.email,
                        color: Warning.warning100,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          doctor.email,
                          style: TextStyleManager.interRegular11.copyWith(
                            color: GrayColor.grey60,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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