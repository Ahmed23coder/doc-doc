import 'package:docdoc/models/governrate_model.dart';

class CityModel {
  final int id;
  final String name;
  final GovernrateModel? governrate;

  CityModel({
    required this.id,
    required this.name,
    this.governrate
  });

  factory CityModel.fromJson (Map<String, dynamic> json){
    return CityModel(
        id: json ['id'] ?? 0,
        name:json  ['name'] ?? '',
      governrate: json ['governrate'] !=null
        ? GovernrateModel.fromJson(json  ['governrate'])
          : null,
    );
  }
  
}
