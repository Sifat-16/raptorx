class TRexConstantModel {
  String name;
  Map<String, String> data;

  TRexConstantModel({required this.name, required this.data});

  // Convert from JSON
  factory TRexConstantModel.fromJson(Map<String, dynamic> json) {
    return TRexConstantModel(
      name: json['name'],
      data: Map<String, String>.from(json['data']), // Ensure type safety
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data': data,
    };
  }
}
