class SpecializationModel {
  final int id;
  final String name;

  SpecializationModel({required this.id, required this.name});

  factory SpecializationModel.fromJson(Map<String, dynamic> json) {
    return SpecializationModel(
      id: _parseInt(json['id']),
      name: json['name'] ?? 'Unknown',
    );
  }


  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}