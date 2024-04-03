import 'package:dartz/dartz.dart';
import 'package:weatherly/core/error/failure.dart';
import 'package:weatherly/domains/repositories/weather_repository.dart';
import 'package:weatherly/models/Coordinates.dart';
import 'package:weatherly/models/Weather.dart';

class GetCurrentWeatherUseCase {
  final WeatherRepository weatherRepository;

  GetCurrentWeatherUseCase(this.weatherRepository);

  Future<Either<Failure, WeatherModel>> executeByCity(String city) async {
    return await weatherRepository.getCurrentWeatherByCity(city);
  }

  Future<Either<Failure, WeatherModel>> executeByLocation(CoordinatesModel coordinates) async {
    return await weatherRepository.getCurrentWeatherByLocation(coordinates);
  }
}
