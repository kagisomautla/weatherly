import 'package:flutter/material.dart';
import 'package:weatherly/domains/repositories/forecast_repository.dart';
import 'package:weatherly/models/Coordinates.dart';
import 'package:weatherly/models/Forecast.dart';
import 'package:weatherly/utils/convert_forecast.dart';

class ForecastService extends ChangeNotifier {
  //create an instance of the ForestRepository class
  final ForecastRepository _forecastRepository = ForecastRepository();

  List<ForecastModel> _forecast = [];
  List<ForecastModel> get forecast => _forecast;
  set forecast(List<ForecastModel> value) {
    _forecast = value;
    notifyListeners();
  }

  Future<void> getForecastByCity(String cityName) async {
    final result = await _forecastRepository.getForecastByCity(cityName);
    result.fold(
      (error) {
        print('Error: $error');
        throw Exception('Failed to get forecast');
      },
      (forecast) async => _forecast = await formatFiveDayForecast(forecast),
    );
  }

  Future<void> getForecastByLocation(CoordinatesModel coordinates) async {
    final result = await _forecastRepository.getForecastByLocation(coordinates);
    result.fold(
      (error) {
        print('Error: $error');
        throw Exception('Failed to get forecast');
      },
      (forecast) async => _forecast = await formatFiveDayForecast(forecast),
    );
  }

  Future<void> saveForecastToLocalStorage() async {
    await _forecastRepository.saveForecastToLocalStorage(_forecast);
  }

  Future<void> getForecastFromLocalStorage() async {
    final forecast = await _forecastRepository.getForecastFromLocalStorage();
    _forecast = forecast;
  }
}
