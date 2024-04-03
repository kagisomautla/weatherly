import 'package:weatherly/models/Temperature.dart';

class ForecastModel {
  final String dayOfTheWeek;
  final String description;
  final String icon;
  final TemperatureModel? temperature;
  final String main;

  ForecastModel({
    required this.dayOfTheWeek,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.main,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      dayOfTheWeek: json['day_of_the_week'] ?? '',
      description: json['description'],
      icon: json['icon'],
      temperature: TemperatureModel.fromJson(json['temperature']),
      main: json['main'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day_of_the_week': dayOfTheWeek,
      'description': description,
      'icon': icon,
      'temperature': temperature!.toJson(),
      'main': main,
    };
  }
}
