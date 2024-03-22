import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weatherly/constants/weather_types.dart';
import 'package:weatherly/models/Weather.dart';
import 'package:http/http.dart' as http;

class WeatherViewModel extends ChangeNotifier {
  Weather? _weather;
  Weather? get weather => _weather;

  //fetch the current weather based on provided latitude and longitude
  Future<void> fetchWeather({required WeatherTypes types, required String latitude, required String longitude}) async {
    final apiKey = dotenv.env['WEATHERLY_API_KEY'];
    final apiHost = dotenv.env['CURRENT_WEATHER_URL'];
    final type = types == WeatherTypes.weather ? 'weather' : 'forecast';
    String apiPath = 'data/2.5/$type';
    final apiQueryParams = {'lat': latitude, 'lon': longitude, 'appid': apiKey, 'units': 'metric'};

    final uri = Uri.https(apiHost!, apiPath, apiQueryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      _weather = Weather.fromJson(jsonData);
      print('Weather data loaded successfully');
      print(_weather!.toJson());
      notifyListeners();
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
