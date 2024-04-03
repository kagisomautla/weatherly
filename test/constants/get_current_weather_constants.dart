import 'package:weatherly/models/Coordinates.dart';
import 'package:weatherly/models/Temperature.dart';
import 'package:weatherly/models/Weather.dart';

WeatherModel testWeather = WeatherModel(
  cityName: 'Minneapolis',
  temperature: TemperatureModel(
    temp: 20.0,
    tempMin: 15.0,
    tempMax: 25.0,
  ),
  description: 'Cloudy',
  icon: '04d',
  main: 'Clouds',
  lastUpdated: DateTime.now(),
);

const testCity = 'Minneapolis';
final testLocation = CoordinatesModel(latitude: 44.9778, longitude: -93.2650);
