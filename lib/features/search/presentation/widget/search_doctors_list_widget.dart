import 'package:docdoc/features/home/presentation/screens/doctor_details_screen.dart';
import 'package:docdoc/models/doctor_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/text_style_manager.dart';


class SearchDoctorsListWidget extends StatelessWidget {
  final List<DoctorModel> doctorsList;

  const SearchDoctorsListWidget({super.key, required this.doctorsList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemCount: doctorsList.length,
      itemBuilder: (context, index) {
        final doctor = doctorsList[index];
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 80,
                    width: 80,
                    color: Colors.grey.shade100,
                    child: Image.network(
                      doctor.photo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      // Fallback icon if image fails
                      const Icon(Icons.person, size: 40, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        doctor.name,
                        style: TextStyleManager.interBold18.copyWith(fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      Text(
                        "${doctor.degree} | ${doctor.specialization?.name ?? 'Specialist'}",
                        style: TextStyleManager.interRegular12.copyWith(color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            "4.8", // Placeholder rating if your API doesn't send it yet
                            style: TextStyleManager.interRegular11.copyWith(color: Colors.grey),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "(${doctor.email})",
                              style: TextStyleManager.interRegular11.copyWith(color: Colors.grey),
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
      },
    );
  }
}