class DoctorFilterModel {
  final int? specializationId;
  final int? cityId;

  DoctorFilterModel({
    this.specializationId,
    this.cityId,
  });


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (specializationId != null && specializationId != 0) {
      data['specialization_id'] = specializationId;
    }
    if (cityId != null && cityId != 0) {
      data['city_id'] = cityId;
    }

    return data;
  }
}