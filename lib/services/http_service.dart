import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:weatherly/models/Coordinates.dart';
import 'package:weatherly/models/Response.dart';

class HttpService {
  ///Fetches the forecast data for the next 5 days from the OpenWeatherMap API.
  ///The data is fetched using the coordinates of the location.
  ///The data includes the temperature, weather description, weather icon, and date.
  Future<ResponseModel> getForecast({required CoordinatesModel coordinates}) async {
    // Make a GET request
    final apiKey = dotenv.env['WEATHERLY_API_KEY'];

    //get the forecast data for the next 5 days
    final uri = Uri.parse('https://api.openweathermap.org/data/2.5/forecast?lat=${coordinates.latitude}&lon=${coordinates.longitude}&appid=$apiKey&metric&cnt=40&units=metric');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return ResponseModel(
        content: jsonData,
        success: true,
      );
    } else {
      return ResponseModel(
        content: null,
        success: false,
      );
    }
  }

  // Function to validate the API key
  bool validateApiKey(String? apiKey) {
    if (apiKey == null || apiKey.isEmpty) {
      return false;
    }
    return true;
  }

  ///Fetches the current weather data from the OpenWeatherMap API.
  ///The data is fetched using the coordinates of the location.
  ///The data includes the current temperature, weather description, and weather icon.
  Future<ResponseModel> getWeather({required CoordinatesModel coordinates}) async {
    try {
      // Make a GET request
      final apiKey = dotenv.env['WEATHERLY_API_KEY'];

      if (!validateApiKey(apiKey)) {
        throw Exception('API key is missing or invalid.');
      }

      //get the current weather data
      final uri = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=${coordinates.latitude}&lon=${coordinates.longitude}&appid=$apiKey&units=metric');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return ResponseModel(
          content: jsonData,
          success: true,
        );
      } else {
        return ResponseModel(
          content: null,
          success: false,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      return ResponseModel(
        content: null,
        success: false,
      );
    }
  }

  ///Fetches the coordinates of the location using the location name from the Google Maps Geocoding API.
  ///The data includes the latitude and longitude of the location.
  ///The data is used to fetch the weather and forecast data.
  ///The data is also used to display the location on the map.
  Future<ResponseModel> getCoordinatesUsingGeocoding({required String locationName}) async {
    try {
      // Make a GET request
      final apiKey = dotenv.env['WEATHERLY_API_KEY'];

      //get the coordinates of the location
      final uri = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?address=$locationName&key=$apiKey');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return ResponseModel(
          content: jsonData,
          success: true,
        );
      } else {
        return ResponseModel(
          content: null,
          success: false,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      return ResponseModel(
        content: null,
        success: false,
      );
    }
  }

  ///Fetches the place details using the coordinates from the Google Maps Geocoding API.
  ///The data includes the name, address, and place ID of the location.
  ///The data is used to display the location details on the screen.
  Future<ResponseModel> getPlaceDetailsUsingGeocodingCoordinates({required CoordinatesModel coordinates}) async {
    try {
      // Make a GET request
      final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;
      final reverseGeocodingUrl = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${coordinates.latitude},${coordinates.longitude}&key=$apiKey';
      final reverseGeocodingResponse = await http.get(Uri.parse(reverseGeocodingUrl));

      if (reverseGeocodingResponse.statusCode == 200) {
        final jsonData = jsonDecode(reverseGeocodingResponse.body);
        print('reverseGeocodingResponse: $jsonData');
        return ResponseModel(
          content: jsonData,
          success: true,
        );
      } else {
        return ResponseModel(
          content: null,
          success: false,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      return ResponseModel(
        content: null,
        success: false,
      );
    }
  }

  ///Fetches the place details using the place ID from the Google Maps Places API.
  ///The data includes the name, address, phone number, and photos of the location.
  ///The data is used to display the location details on the screen.

  Future<ResponseModel> getPlaceDetailsUsingPlaceId({required String placeId}) async {
    try {
      // Make a GET request
      final apiKey = dotenv.env['WEATHERLY_API_KEY'];

      //get the place details using the place ID
      final uri = Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,formatted_address,formatted_phone_number,photos&key=$apiKey');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return ResponseModel(
          content: jsonData,
          success: true,
        );
      } else {
        return ResponseModel(
          content: null,
          success: false,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      return ResponseModel(
        content: null,
        success: false,
      );
    }
  }
}
