import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherly/core/error/failure.dart';
import 'package:weatherly/domains/usecases/get_forecast.dart';
import 'package:weatherly/models/Coordinates.dart';

import '../../constants/get_forecast_constants.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetForecastUseCase getForecastUseCase;
  late MockForecastRepository mockForecastRepository;

  setUp(() {
    mockForecastRepository = MockForecastRepository();
    getForecastUseCase = GetForecastUseCase(mockForecastRepository);
  });

  final testCity = 'Minneapolis';
  final testLocation = CoordinatesModel(latitude: 44.9778, longitude: -93.2650);
  final testForecast = {
    'city': {
      'name': 'Minneapolis',
    },
    'list': [
      {
        'dt': 1630009200,
        'main': {
          'temp': 20.0,
          'temp_min': 15.0,
          'temp_max': 25.0,
        },
        'weather': [
          {
            'description': 'Cloudy',
            'icon': '04d',
            'main': 'Clouds',
          },
        ],
      },
    ],
  };

  // Test the getForecastByLocation method
  test('should return the forecast by location', () async {
    // Given
    when(mockForecastRepository.getForecastByLocation(testLocation)).thenAnswer((_) async => Right(testForecast));
    // When
    final result = await getForecastUseCase.excecuteByLocation(testLocation);
    // Then
    expect(result, Right(testForecast));
  });

  // Test the getForecastByCity method
  test('should return the forecast by city name', () async {
    // Given
    when(mockForecastRepository.getForecastByCity(testCity)).thenAnswer((_) async => Right(testForecast));
    // When
    final result = await getForecastUseCase.excecuteByCity(testCity);
    // Then
    expect(result, Right(testForecast));
  });

  // Test the getForecastByCity method with an error
  test('should return a failure when the forecast by city name fails', () async {
    // Given
    when(mockForecastRepository.getForecastByCity(testCity)).thenAnswer((_) async => Left(ServerFailure('Failed to fetch forecast data.')));
    // When
    final result = await getForecastUseCase.excecuteByCity(testCity);
    // Then
    expect(result, Left(ServerFailure('Failed to fetch forecast data.')));
  });

  // Test the getForecastByLocation method with an error
  test('should return a failure when the forecast by location fails', () async {
    // Given
    when(mockForecastRepository.getForecastByLocation(testLocation)).thenAnswer((_) async => Left(ServerFailure('Failed to fetch forecast data.')));
    // When
    final result = await getForecastUseCase.excecuteByLocation(testLocation);
    // Then
    expect(result, Left(ServerFailure('Failed to fetch forecast data.')));
  });

  test('should format the data returned from getForecast into a coherent 5-day forecast', () async {
    // Given
    when(mockForecastRepository.formatTo5DayForecast(testForecastData)).thenAnswer((_) async => Right(expectedForecast));

    // When
    final result = await mockForecastRepository.formatTo5DayForecast(testForecastData);

    // Then
    expect(result, Right(expectedForecast));
  });
}
