class BrandModel {
  String? brandName;
  String? currentIosVersion;
  String? currentAndroidVersion;
  String? brandImage;
  String? brandLocation;

  BrandModel({
    this.brandName,
    this.currentIosVersion,
    this.currentAndroidVersion,
    this.brandImage,
    this.brandLocation,
  });

  // Convert a BrandModel object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'brandName': brandName,
      'currentIosVersion': currentIosVersion,
      'currentAndroidVersion': currentAndroidVersion,
      'brandImage': brandImage,
      'brandLocation': brandLocation,
    };
  }

  // Create a BrandModel object from a JSON map
  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      brandName: json['brandName'] as String?,
      currentIosVersion: json['currentIosVersion'] as String?,
      currentAndroidVersion: json['currentAndroidVersion'] as String?,
      brandImage: json['brandImage'] as String?,
      brandLocation: json['brandLocation'] as String?,
    );
  }

  // Create a copyWith method
  BrandModel copyWith({
    String? brandName,
    String? currentIosVersion,
    String? currentAndroidVersion,
    String? brandImage,
    String? brandLocation,
  }) {
    return BrandModel(
      brandName: brandName ?? this.brandName,
      currentIosVersion: currentIosVersion ?? this.currentIosVersion,
      currentAndroidVersion:
          currentAndroidVersion ?? this.currentAndroidVersion,
      brandImage: brandImage ?? this.brandImage,
      brandLocation: brandLocation ?? this.brandLocation,
    );
  }
}
