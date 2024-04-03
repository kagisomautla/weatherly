import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:weatherly/core/error/failure.dart';
import 'package:weatherly/models/Coordinates.dart';
import 'package:weatherly/models/Weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherModel>> getCurrentWeatherByCity(String cityName);
  Future<Either<Failure, WeatherModel>> getCurrentWeatherByLocation(CoordinatesModel coordinates);
}
