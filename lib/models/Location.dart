import 'package:weatherly/constants/constants.dart';
import 'package:weatherly/models/Coordinates.dart';
import 'package:weatherly/models/Weather.dart';

class LocationModel {
  final String? name;
  final CoordinatesModel coordinates;
  final WeatherModel weather;

  LocationModel({this.name, required this.coordinates, required this.weather});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'],
      coordinates: CoordinatesModel.fromJson(json['coordinates']),
      weather: WeatherModel.fromJson(json['weather']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'coordinates': coordinates.toJson(),
      'weather': weather.toJson(),
    };
  }
}
