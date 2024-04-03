import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:weatherly/constants/constants.dart';
import 'package:weatherly/core/error/failure.dart';
import 'package:weatherly/models/Coordinates.dart';
import 'package:weatherly/models/Forecast.dart';
import 'package:http/http.dart' as http;
import 'package:weatherly/utils/convert_forecast.dart';

class ForecastRepository {
  Future saveForecastToLocalStorage(List<ForecastModel> forecast) async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.write(key: kForecastDataKey, value: jsonEncode(forecast));
  }

  Future<List<ForecastModel>> getForecastFromLocalStorage() async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    final forecastData = await storage.read(key: kForecastDataKey);
    if (forecastData != null) {
      final List<dynamic> forecastList = jsonDecode(forecastData);
      return forecastList.map((forecast) => ForecastModel.fromJson(forecast)).toList();
    }

    return [];
  }

  Future<Either<Failure, dynamic>> getForecastByCity(String cityName) async {
    try {
      final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
      final uri = Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey&metric&cnt=40&units=metric');

      // Make a GET request
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = response.body;
        return Right(jsonDecode(jsonData));
      } else {
        return Left(ServerFailure('Failed to fetch forecast data.'));
      }
    } catch (e) {
      debugPrint(e.toString());
      return Left(ServerFailure('Failed to fetch forecast data.'));
    }
  }

  Future<Either<Failure, dynamic>> getForecastByLocation(CoordinatesModel coordinates) async {
    try {
      final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
      final uri = Uri.parse('https://api.openweathermap.org/data/2.5/forecast?lat=${coordinates.latitude}&lon=${coordinates.longitude}&appid=$apiKey&metric&cnt=40&units=metric');

      // Make a GET request
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = response.body;
        return Right(jsonDecode(jsonData));
      } else {
        return Left(ServerFailure('Failed to fetch forecast data.'));
      }
    } catch (e) {
      debugPrint(e.toString());
      return Left(ServerFailure('Failed to fetch forecast data.'));
    }
  }

  Future<Either<Failure, List<ForecastModel>>> formatTo5DayForecast(dynamic data) async {
    try {
      final formattedForecast = await formatFiveDayForecast(data);
      return Right(formattedForecast);
    } catch (e) {
      debugPrint(e.toString());
      return Left(ServerFailure('Failed to format forecast data.'));
    }
  }
}
