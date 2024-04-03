class CoordinatesModel {
  double longitude;
  double latitude;

  CoordinatesModel({
    required this.longitude,
    required this.latitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  factory CoordinatesModel.fromJson(Map<String, dynamic> json) {
    return CoordinatesModel(
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }
}
