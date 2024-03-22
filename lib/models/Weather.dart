import 'package:weatherly/models/Temperature.dart';

class Weather {
  final String cityName;
  final String description;
  final String icon;
  final Temperature? temperature;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      temperature: Temperature.fromJson(json['main']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'description': description,
      'icon': icon,
      'temperature': temperature!.toJson(),
    };
  }
}
