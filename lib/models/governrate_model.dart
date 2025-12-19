class GovernrateModel{
  final int id ;
  final String name;

  GovernrateModel({required this.id, required this.name});

  factory GovernrateModel.fromJson(Map<String, dynamic> json){
    return GovernrateModel(
    id: json ['id'] ?? 0,
    name:json  ['name'] ?? '',
  );
  }

}