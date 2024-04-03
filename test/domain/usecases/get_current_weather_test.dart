import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherly/core/error/failure.dart';
import 'package:weatherly/domains/usecases/get_current_weather.dart';
import 'package:weatherly/models/Coordinates.dart';
import 'package:weatherly/models/Temperature.dart';
import 'package:weatherly/models/Weather.dart';

import '../../constants/get_current_weather_constants.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetCurrentWeatherUseCase getCurrentWeatherUseCase;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    getCurrentWeatherUseCase = GetCurrentWeatherUseCase(mockWeatherRepository);
  });

  test('should return the current weather by city name', () async {
    // Given
    when(mockWeatherRepository.getCurrentWeatherByCity(testCity)).thenAnswer((_) async => Right(testWeather));

    // When
    final result = await getCurrentWeatherUseCase.executeByCity(testCity);

    // Then
    expect(result, Right(testWeather));
  });

  test('should return the current weather by location', () async {
    // Given
    when(mockWeatherRepository.getCurrentWeatherByLocation(testLocation)).thenAnswer((_) async => Right(testWeather));

    // When
    final result = await getCurrentWeatherUseCase.executeByLocation(testLocation);

    // Then
    expect(result, Right(testWeather));
  });
}
