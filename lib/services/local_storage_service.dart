import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/constants/constants.dart';
import 'package:weatherly/models/Coordinates.dart';
import 'package:weatherly/models/Forecast.dart';
import 'package:weatherly/models/Location.dart';
import 'package:weatherly/models/Temperature.dart';
import 'package:weatherly/models/Weather.dart';
import 'package:weatherly/viewmodels/locations_view_model.dart';
import 'package:weatherly/viewmodels/theme_view_model.dart';

final FlutterSecureStorage storage = FlutterSecureStorage();

class LocalStorageService {
  /// Saves user's weather data based on their current location
  /// Throws an exception if an error occurs
  /// Returns true if the data was successfully saved
  /// Returns false if an error occurs
  static Future<bool> saveWeatherData({required WeatherModel weather}) async {
    print('SAVING WEATHER DATA TO LOCAL STORAGE');

    final data = jsonEncode(weather.toJson());
    print('weather data: $data');
    await storage.write(key: kWeatherDataKey, value: data);
    return true;
  }

  /// Saves user's coordinates data
  /// Throws an exception if an error occurs
  /// Returns true if the data was successfully saved
  /// Returns false if an error occurs
  /// Returns false if the data was not found
  static Future<bool> saveCoordinatesData({required CoordinatesModel coordinates}) async {
    print('SAVING COORDINATES DATA TO LOCAL STORAGE');

    final data = jsonEncode(coordinates.toJson());
    await storage.write(key: kCoordinatesDataKey, value: data);
    return true;
  }

  /// Saves user's forecast data
  /// Throws an exception if an error occurs
  /// Returns true if the data was successfully saved
  /// Returns false if an error occurs
  /// Returns false if the data was not found
  static Future<bool> saveForecastData({required List<ForecastModel> forecast}) async {
    print('SAVING FORECAST DATA TO LOCAL STORAGE');
    final data = jsonEncode(forecast.map((e) => e.toJson()).toList());
    print('forecast data: $data');
    await storage.write(key: kForecastDataKey, value: data);
    return true;
  }

  /// Saves user's location data
  /// Throws an exception if an error occurs
  /// Returns true if the data was successfully saved
  /// Returns false if an error occurs
  /// Returns false if the data was not found
  static Future<bool> saveLocationData({required LocationModel location}) async {
    print('SAVING LOCATION DATA TO LOCAL STORAGE: ${location.toJson()}');
    final data = jsonEncode(location.toJson());
    await storage.write(key: kLocationDataKey, value: data);
    return true;
  }

  /// Gets user's weather data based on their current location
  /// Returns a [WeatherModel] object
  /// Returns null if no data is found
  /// Throws an exception if an error occurs
  static Future<WeatherModel?> getWeatherData() async {
    try {
      print('GETTING WEATHER DATA FROM LOCAL STORAGE');
      final weatherData = await storage.read(key: kWeatherDataKey);
      // print('weather data: $weatherData');
      if (weatherData == null) return null;

      final decodedWeather = jsonDecode(weatherData);

      final weatherModel = WeatherModel(
        cityName: decodedWeather['city_name'],
        temperature: TemperatureModel.fromJson(decodedWeather['temperature']),
        description: decodedWeather['description'],
        icon: decodedWeather['icon'],
        main: decodedWeather['main'],
        cloudiness: decodedWeather['cloudiness'],
        sunrise: DateTime.parse(decodedWeather['sunrise']),
        sunset: DateTime.parse(decodedWeather['sunset']),
        windSpeed: decodedWeather['wind_speed'],
        lastUpdated: DateTime.parse(decodedWeather['last_updated']),
      );

      return weatherModel;
    } catch (e) {
      print('error getting weather data $e');
      return null;
    }
  }

  /// Gets user's coordinates data
  /// Returns a [CoordinatesModel] object
  /// Returns null if no data is found
  /// Throws an exception if an error occurs
  static Future<CoordinatesModel?> getCoordinatesData() async {
    print('GETTING COORDINATES DATA FROM LOCAL STORAGE');
    final coordinatesData = await storage.read(key: kCoordinatesDataKey);
    // print('coordinates data: $coordinatesData');
    if (coordinatesData == null) return null;

    final decodeCoordinates = jsonDecode(coordinatesData);
    final coordinatesModel = CoordinatesModel(
      latitude: decodeCoordinates['latitude'],
      longitude: decodeCoordinates['longitude'],
    );

    return coordinatesModel;
  }

  /// Gets user's forecast data
  /// Returns a list of [ForecastModel] objects
  /// Returns an empty list if no data is found
  /// Throws an exception if an error occurs
  static Future<List<ForecastModel>> getForecastData() async {
    final forecastData = await storage.read(key: kForecastDataKey);
    if (forecastData == null) return [];
    // print('forecast data: $forecastData');
    final decodedForecast = jsonDecode(forecastData) as List;
    // print('decodedForecast: $decodedForecast');
    final forecast = decodedForecast
        .map((e) => ForecastModel(
              dayOfTheWeek: e['day_of_the_week'],
              description: e['description'],
              icon: e['icon'],
              temperature: TemperatureModel.fromJson(
                e['temperature'],
              ),
              main: e['main'],
            ))
        .toList();

    return forecast;
  }

  /// Gets user's location data
  /// Returns a [LocationModel] object
  /// Returns null if no data is found
  /// Throws an exception if an error occurs
  static Future<LocationModel?> getLocationData() async {
    print('GETTING LOCATION DATA FROM LOCAL STORAGE');

    final locationData = await storage.read(key: kLocationDataKey);
    if (locationData == null) return null;
    // print('location data: $locationData');

    final decodedLocation = jsonDecode(locationData);

    final locationModel = LocationModel(
      name: decodedLocation['name'],
      coordinates: CoordinatesModel(
        latitude: decodedLocation['coordinates']['latitude'],
        longitude: decodedLocation['coordinates']['longitude'],
      ),
      weather: WeatherModel(
        cityName: decodedLocation['weather']['city_name'],
        temperature: TemperatureModel.fromJson(decodedLocation['weather']['temperature']),
        description: decodedLocation['weather']['description'],
        icon: decodedLocation['weather']['icon'],
        main: decodedLocation['weather']['main'],
        lastUpdated: DateTime.parse(decodedLocation['weather']['last_updated']),
      ),
    );

    // print('LOCATION RESULT: ${locationModel.toJson()}');

    return locationModel;
  }

  /// Clears user's weather data based on their current location
  /// Throws an exception if an error occurs
  /// Returns true if the data was successfully cleared
  /// Returns false if the data was not found
  /// Returns false if an error occurs
  static Future<bool> clearWeatherDataBasedOnCurrentLocation() async {
    print('CEARING WEATHER DATA FROM LOCAL STORAGE');

    final weatherData = await storage.read(key: kWeatherDataKey);
    if (weatherData == null) return false;

    await storage.delete(key: kWeatherDataKey);
    await storage.delete(key: kCoordinatesDataKey);
    await storage.delete(key: kForecastDataKey);
    return true;
  }

  /// Clears all user's data from local storage
  /// Throws an exception if an error occurs
  static Future<void> clearAllData() async {
    print('CLEARING ALL DATA FROM LOCAL STORAGE');
    await storage.deleteAll();
  }

  /// Saves a location data to local storage
  /// Throws an exception if an error occurs
  static Future<void> saveFavouriteLocationData({required LocationModel location, required WeatherModel weather}) async {
    //first get the list of all favorite locations from location
    //if the list is empty, create a new list and add the location to it
    //if the list is not empty, add the location to the list
    //save the list back to local storage
    print('SAVING FAVOURITE LOCATION DATA FROM LOCAL STORAGE');
    final locationData = await storage.read(key: kFavouriteLocationDataKey);
    // print('LOCATION DATA::: $locationData');

    if (locationData == null) {
      print('LOCATION DATA DOES NOT EXISTS. STORING IN LS!');
      final locationList = [location];
      final data = jsonEncode(locationList.map((e) => e.toJson()).toList());
      await storage.write(key: kFavouriteLocationDataKey, value: data);
      return;
    } else {
      print('LOCATION DATA EXISTS. CONTINUE!');
      final locationList = (jsonDecode(locationData) as List)
          .map(
            (e) => LocationModel(
              name: e['name'],
              coordinates: CoordinatesModel(
                latitude: e['coordinates']['latitude'],
                longitude: e['coordinates']['longitude'],
              ),
              weather: weather,
            ),
          )
          .toList();

      //check if the location already exists in the list
      //if it does, remove it from the list
      //if it does not, add it to the list
      //the save the list back to local storage

      final locationExists = locationList.any((element) => element.name == location.name);

      if (locationExists) {
        print('REMOVING LOCATION FROM FAVOURITES');
        locationList.removeWhere((element) => element.name == location.name);
      } else {
        print('ADDING LOCATION TO FAVOURITES');
        locationList.add(location);
      }

      final data = jsonEncode(locationList.map((e) => e.toJson()).toList());
      await storage.write(key: kFavouriteLocationDataKey, value: data);
    }
  }

  //get the list of all favorite locations from local storage
  //if the list is empty, return an empty list
  //if the list is not empty, return the list
  static Future<List<LocationModel>> getFavouriteLocationsData() async {
    print('GETTING FAVOURITE LOCATION DATA FROM LOCAL STORAGE');

    final locationData = await storage.read(key: kFavouriteLocationDataKey);
    if (locationData == null) return [];

    // print('FAVOURITE LOCATION DATA: $locationData');

    final decodedLocation = jsonDecode(locationData) as List;
    final locations = decodedLocation
        .map(
          (e) => LocationModel(
            name: e['name'],
            coordinates: CoordinatesModel.fromJson(e['coordinates']),
            weather: WeatherModel(
              cityName: e['weather']['city_name'],
              temperature: TemperatureModel.fromJson(e['weather']['temperature']),
              description: e['weather']['description'],
              icon: e['weather']['icon'],
              main: e['weather']['main'],
              lastUpdated: DateTime.parse(
                e['weather']['last_updated'],
              ),
            ),
          ),
        )
        .toList();

    return locations;
  }

  //save onboarding status to local storage
  static Future<void> saveOnboardingStatus({required bool status}) async {
    print('SAVING ONBOARDING STATUS TO LOCAL STORAGE');
    await storage.write(key: kOnboardingStatusKey, value: status.toString());
  }

  //fetch onboarding status
  static Future<bool> getOnboardingStatus() async {
    print('GETTING ONBOADING DATA FROM LOCAL STORAGE');

    final onboardingData = await storage.read(key: kOnboardingStatusKey);

    if (onboardingData != null) {
      bool onboardingStatus = bool.parse(onboardingData);
      // print('onboardingStatus: $onboardingStatus');
      return onboardingStatus;
    }

    //at this point on boarding status would be null
    return false;
  }

  ///save searched location to list of locations in local storage.
  ///if the list is empty, create a new list and add the location to it.
  ///if the list is not empty, add the location to the list, but first check if the location already exists.
  static Future<void> saveSearchedLocation({required Prediction location}) async {
    print('SAVING SEARCHED LOCATION TO LOCAL STORAGE');
    final locationData = await storage.read(key: kSearchedLocationDataKey);
    // print('LOCATION DATA::: $locationData');

    if (locationData == null) {
      print('LOCATION DATA DOES NOT EXISTS. STORING IN LS!');
      final locationList = [location];
      final data = jsonEncode(locationList.map((e) => e).toList());
      await storage.write(key: kSearchedLocationDataKey, value: data);
      return;
    } else {
      print('LOCATION DATA EXISTS. CONTINUE!');
      final locationList = (jsonDecode(locationData) as List)
          .map(
            (e) => Prediction(
              description: e['description'],
              placeId: e['place_id'],
            ),
          )
          .toList();

      //check if the location already exists in the list
      //if it does, remove it from the list
      //if it does not, add it to the list
      //the save the list back to local storage

      final locationExists = locationList.any((element) => element.description == location.description);

      if (!locationExists) {
        print('ADDING LOCATION TO SEARCHED LOCATIONS');
        locationList.add(location);
      }

      final data = jsonEncode(locationList.map((e) => e.toJson()).toList());
      await storage.write(key: kSearchedLocationDataKey, value: data);
    }
  }

  //get the list of all searched locations from local storage
  //if the list is empty, return an empty list
  //if the list is not empty, return the list
  static Future<List<Prediction>> getSearchedLocationsData() async {
    print('GETTING SEARCHED LOCATION DATA FROM LOCAL STORAGE');

    final locationData = await storage.read(key: kSearchedLocationDataKey);
    if (locationData == null) return [];

    // print('SEARCHED LOCATION DATA: $locationData');

    final decodedLocation = jsonDecode(locationData) as List;
    final locations = decodedLocation
        .map(
          (e) => Prediction(
            description: e['description'],
            placeId: e['place_id'],
          ),
        )
        .toList();

    return locations;
  }

  //remove location from searched locations
  static Future<void> removeLocationFromSearchedLocations({required Prediction location}) async {
    print('REMOVING LOCATION FROM SEARCHED LOCATIONS');
    final locationData = await storage.read(key: kSearchedLocationDataKey);
    if (locationData == null) return;

    final locationList = (jsonDecode(locationData) as List)
        .map(
          (e) => Prediction(
            description: e['description'],
            placeId: e['place_id'],
          ),
        )
        .toList();

    final newList = locationList.where((element) => element.description != location.description).toList();
    final data = jsonEncode(newList.map((e) => e.toJson()).toList());
    await storage.write(key: kSearchedLocationDataKey, value: data);
  }
}
