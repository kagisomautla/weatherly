import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import 'package:weatherly/models/Coordinates.dart';
import 'package:weatherly/models/Forecast.dart';
import 'package:weatherly/models/Location.dart';
import 'package:weatherly/models/Weather.dart';
import 'package:weatherly/services/google_service.dart';
import 'package:weatherly/services/http_service.dart';
import 'package:weatherly/services/local_storage_service.dart';
import 'package:weatherly/utils/convert_forecast.dart';
import 'package:weatherly/viewmodels/coordinates_view_model.dart';
import 'package:weatherly/viewmodels/locations_view_model.dart';
import 'package:weatherly/viewmodels/theme_view_model.dart';
import 'package:weatherly/widgets/snackbar.dart';

class WeatherViewModel extends ChangeNotifier {
  WeatherModel? _weather;
  WeatherModel? get weather => _weather;
  set weather(WeatherModel? value) {
    _weather = value;
    notifyListeners();
  }

  List<ForecastModel>? _forecast;
  List<ForecastModel>? get forecast => _forecast;
  set forecast(List<ForecastModel>? value) {
    _forecast = value;
    notifyListeners();
  }

  bool _offlineDataValid = false;
  bool get offlineDataValid => _offlineDataValid;

  bool _hasOnboarded = false;
  bool get hasOnboarded => _hasOnboarded;
  set hasOnboarded(bool value) {
    _hasOnboarded = value;
    notifyListeners();
  }

  bool _showLastUpdated = false;
  bool get showLastUpdated => _showLastUpdated;
  set showLastUpdated(bool value) {
    _showLastUpdated = value;
    notifyListeners();
  }

  bool _isOnline = false;
  bool get isOnline => _isOnline;
  set isOnline(bool value) {
    _isOnline = value;
    notifyListeners();
  }

  bool _showLoading = true;
  bool get showLoading => _showLoading;
  set showLoading(bool value) {
    _showLoading = value;
    notifyListeners();
  }

  ///Fetches the weather data from the OpenWeatherMap API.
  Future<void> fetchWeather({
    required CoordinatesModel coordinates,
    required BuildContext context,
  }) async {
    try {
      final response = await HttpService().getWeather(coordinates: coordinates);

      if (!response.success) {
        debugPrint('Failed to load weather data');
        snackBar(message: 'Failed to load weather data', context: context);
      }

      _weather = WeatherModel.fromJson(response.content);
      await LocalStorageService.saveWeatherData(weather: _weather!);

      print('response.content: ${response.content}');

      //set theme
      final themeVM = Provider.of<ThemeViewModel>(context, listen: false);
      themeVM.setTheme(_weather!);
      notifyListeners();
    } catch (e) {
      debugPrint('error loadind weather data $e');
      throw Exception(e);
    }
  }

  ///Fetches the forecast data from the OpenWeatherMap API.
  Future<void> fetchForecast({
    required CoordinatesModel coordinates,
    required BuildContext context,
  }) async {
    final response = await HttpService().getForecast(coordinates: coordinates);

    if (!response.success) {
      debugPrint('Failed to load forecast data');
      snackBar(message: 'Failed to load forecast data', context: context);
    }

    _forecast = await formatFiveDayForecast(response.content);
    LocalStorageService.saveForecastData(forecast: _forecast!);
    notifyListeners();
  }

  ///This function is called when the user is onboarding the app.
  ///It fetches the current location of the user, fetches the weather data based on the coordinates,
  ///fetches the forecast data based on the coordinates, reverse geocodes the coordinates to get the place details,
  ///saves the location data to local storage, and sets the theme based on the weather data.
  Future performOnboard({required BuildContext context}) async {
    _showLoading = true;
    final coordinatesViewModel = Provider.of<CoordinatesViewModel>(context, listen: false);
    final weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
    final locationViewModel = Provider.of<LocationViewModel>(context, listen: false);

    //get permissions and current location
    await coordinatesViewModel.getPermissions(context);

    //check if permission is granted
    print('Permission granted: ${coordinatesViewModel.permissionGranted}');

    if (coordinatesViewModel.permissionGranted) {
      if (!context.mounted) return;
      await coordinatesViewModel.fetchCurrentPosition(context);

      if (coordinatesViewModel.coordinates != null) {
        if (!context.mounted) return;
        await fetchWeather(
          context: context,
          coordinates: coordinatesViewModel.coordinates!,
        );

        // if (!context.mounted) return;
        // await GoogleService().fetchPlaceDetailsUsingCoordinates(
        //   context: context,
        //   coordinates: coordinatesViewModel.coordinates!,
        // );

        if (!context.mounted) return;
        //fetch forecast
        await weatherViewModel.fetchForecast(
          context: context,
          coordinates: coordinatesViewModel.coordinates!,
        );

        if (!context.mounted) return;
        locationViewModel.location = LocationModel(
          weather: weatherViewModel.weather!,
          name: _weather!.cityName,
          coordinates: coordinatesViewModel.coordinates!,
        );
        LocalStorageService.saveLocationData(location: locationViewModel.location!);

        locationViewModel.checkIfLocationIsFavourite(location: locationViewModel.location!);
      }
    }

    _showLoading = false;
    _hasOnboarded = true;
    LocalStorageService.saveOnboardingStatus(status: true);
    notifyListeners();
  }

  ///fetches offline  data from local storage
  ///returns a [WeatherModel], [CoordinatesModel], [List<ForecastModel>] and [LocationModel] objects and assigns them to their respective variables
  ///throws an exception if an error occurs
  Future<void> fetchOfflineWeatherInformation({required BuildContext context}) async {
    try {
      if (!context.mounted) return;
      //providers
      final coordinatesViewModel = Provider.of<CoordinatesViewModel>(context, listen: false);
      final locationViewModel = Provider.of<LocationViewModel>(context, listen: false);
      final themeViewModel = Provider.of<ThemeViewModel>(context, listen: false);
      _showLoading = true;

      final weather = await LocalStorageService.getWeatherData();
      final coordinates = await LocalStorageService.getCoordinatesData();
      final forecast = await LocalStorageService.getForecastData();
      final location = await LocalStorageService.getLocationData();

      if (weather != null) {
        _weather = weather;
        themeViewModel.setTheme(weather);
      }

      if (coordinates != null) {
        coordinatesViewModel.coordinates = coordinates;
      }

      if (forecast.isNotEmpty) {
        _forecast = forecast;
      }

      if (location != null) {
        locationViewModel.location = location;
      }

      ///offline data is valid if all the data is not null
      ///if any of the data is null, then the offline data is not valid
      _offlineDataValid = weather != null && coordinates != null && forecast.isNotEmpty && location != null;
      _showLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('error fetching offline data $e');
      throw Exception(e);
    }
  }

  Future onSearch({required Prediction searchItem, required BuildContext context}) async {
    if (!context.mounted) return;
    CoordinatesModel? coordinates;
    final googleService = GoogleService();
    final weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
    final locationViewModel = Provider.of<LocationViewModel>(context, listen: false);

    if (searchItem.lat == null || searchItem.lng == null) {
      //reverse engineer and fetch coordinates using placeId
      coordinates = await googleService.fetchPlaceDetailsUsingPlaceId(searchItem.placeId!);
    }

    //these details should now contain coordinates and a photo reference
    //fetch weather
    if (!context.mounted) return;
    await weatherViewModel.fetchWeather(
      context: context,
      coordinates: coordinates ?? CoordinatesModel(latitude: double.parse(searchItem.lat!), longitude: double.parse(searchItem.lng!)),
    );

    //fetch forecast
    if (!context.mounted) return;
    await weatherViewModel.fetchForecast(
      context: context,
      coordinates: coordinates ?? CoordinatesModel(latitude: double.parse(searchItem.lat!), longitude: double.parse(searchItem.lng!)),
    );

    locationViewModel.location = LocationModel(
      weather: weatherViewModel.weather!,
      name: _weather!.cityName,
      coordinates: coordinates ?? CoordinatesModel(latitude: double.parse(searchItem.lat!), longitude: double.parse(searchItem.lng!)),
    );
    LocalStorageService.saveLocationData(location: locationViewModel.location!);

    //check if location is favourite
    locationViewModel.checkIfLocationIsFavourite(location: locationViewModel.location!);
    _showLoading = false;
    notifyListeners();
  }

  Future<void> sync({required BuildContext context}) async {
    try {
      if (!context.mounted) return;
      final weatherViewModel = Provider.of<WeatherViewModel>(context, listen: false);
      final coordinatesViewModel = Provider.of<CoordinatesViewModel>(context, listen: false);
      final locationViewModel = Provider.of<LocationViewModel>(context, listen: false);
      if (!context.mounted) return;
      _showLoading = true;
      await coordinatesViewModel.fetchCurrentPosition(context);

      //fetch weather
      if (!context.mounted) return;
      await weatherViewModel.fetchWeather(
        context: context,
        coordinates: coordinatesViewModel.coordinates!,
      );

      //fetch forecast
      if (!context.mounted) return;
      await weatherViewModel.fetchForecast(
        context: context,
        coordinates: coordinatesViewModel.coordinates!,
      );

      locationViewModel.location = LocationModel(
        weather: weatherViewModel.weather!,
        name: _weather!.cityName,
        coordinates: coordinatesViewModel.coordinates!,
      );
      LocalStorageService.saveLocationData(location: locationViewModel.location!);
      

      // if (!context.mounted) return;
      // await GoogleService().fetchPlaceDetailsUsingCoordinates(
      //   context: context,
      //   coordinates: coordinatesViewModel.coordinates!,
      // );

      //check if location is in favourites
      if (!context.mounted) return;
      locationViewModel.checkIfLocationIsFavourite(location: locationViewModel.location!);
      _showLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('error syncing data $e');
      throw Exception(e);
    }
  }
}
