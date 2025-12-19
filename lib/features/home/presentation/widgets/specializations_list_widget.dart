import 'package:docdoc/core/utils/colors_manager.dart';
import 'package:docdoc/core/utils/text_style_manager.dart';
import 'package:docdoc/models/home_response_model.dart';
import 'package:flutter/material.dart';

class SpecializationsListWidget extends StatelessWidget {
  final List<SpecializationData> specializations;

  const SpecializationsListWidget({super.key, required this.specializations});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.13,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: specializations.length,
        itemBuilder: (context, index) {
          final item = specializations[index];
          return Padding(
            padding: EdgeInsets.only(right: size.width * 0.04),
            child: Column(
              children: [
                Container(
                  height: size.width * 0.16,
                  width: size.width * 0.16,
                  decoration: BoxDecoration(
                    color: GrayColor.grey20,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.medical_services_outlined,
                      color: PrimaryColor.primary100,
                      size: size.width * 0.07,
                    ),
                  ),
                ),
                SizedBox(height: size.height* 0.01,),
                SizedBox(
                  width: size.width*0.18,
                  child: Text(
                    item.name,
                    style: TextStyleManager.interRegular12,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
