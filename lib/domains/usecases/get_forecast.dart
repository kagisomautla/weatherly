import 'package:dartz/dartz.dart';
import 'package:weatherly/core/error/failure.dart';
import 'package:weatherly/domains/repositories/forecast_repository.dart';
import 'package:weatherly/domains/repositories/weather_repository.dart';
import 'package:weatherly/models/Coordinates.dart';
import 'package:weatherly/models/Weather.dart';

class GetForecastUseCase {
  final ForecastRepository forecastRepository;

  GetForecastUseCase(this.forecastRepository);

  Future<Either<Failure, dynamic>> excecuteByCity(String city) async {
    return await forecastRepository.getForecastByCity(city);
  }

  Future<Either<Failure, dynamic>> excecuteByLocation(CoordinatesModel coordinates) async {
    return await forecastRepository.getForecastByLocation(coordinates);
  }
}
