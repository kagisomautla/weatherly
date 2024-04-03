import 'package:weatherly/models/Temperature.dart';

class WeatherModel {
  final String cityName;
  final String description;
  final String icon;
  final TemperatureModel? temperature;
  final String main;
  final DateTime lastUpdated;
  final double? windSpeed;
  final DateTime? sunrise;
  final DateTime? sunset;
  final int? cloudiness;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.main,
    required this.lastUpdated,
    this.windSpeed,
    this.sunrise,
    this.sunset,
    this.cloudiness,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return WeatherModel(
        main: json['weather'][0]['main'],
        cityName: json['name'],
        description: json['weather'][0]['description'],
        icon: json['weather'][0]['icon'],
        temperature: TemperatureModel.fromJson(json['main']),
        windSpeed: json['wind']['speed'],
        lastUpdated: DateTime.now(),
        sunrise: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000),
        sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000),
        cloudiness: json['clouds']['all']);
  }

  Map<String, dynamic> toJson() {
    return {
      'city_name': cityName,
      'description': description,
      'icon': icon,
      'temperature': temperature!.toJson(),
      'main': main,
      'last_updated': lastUpdated.toString(),
      'wind_speed': windSpeed,
      'sunrise': sunrise.toString(),
      'sunset': sunset.toString(),
      'cloudiness': cloudiness,
    };
  }
}
