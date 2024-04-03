import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weatherly/constants/constants.dart';
import 'package:weatherly/models/Location.dart';
import 'package:weatherly/models/Weather.dart';
import 'package:weatherly/services/local_storage_service.dart';

class LocationViewModel extends ChangeNotifier {
  LocationModel? _location;
  LocationModel? get location => _location;
  set location(LocationModel? value) {
    _location = value;
    notifyListeners();
  }

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;
  set isFavorite(bool value) {
    _isFavorite = value;
    notifyListeners();
  }

  List<LocationModel> _favourites = [];
  List<LocationModel> get favourites => _favourites;
  set favourites(List<LocationModel> value) {
    _favourites = value;
    notifyListeners();
  }

  List<LocationModel> _recentlySearched = [];
  List<LocationModel> get recentlySearched => _recentlySearched;
  set recentlySearched(List<LocationModel> value) {
    _recentlySearched = value;
    notifyListeners();
  }

  Future handleOnFavourite({
    required LocationModel location,
    required WeatherModel weather,
  }) async {
    await LocalStorageService.saveFavouriteLocationData(location: location, weather: weather);
  }

  Future checkIfLocationIsFavourite({required LocationModel location}) async {
    print('CHECKING IF LOCATION IS FAVOURITE...');
    //get favourites from local storage
    final favourites = await LocalStorageService.getFavouriteLocationsData();

    //find location in favourites
    bool isFavourite = favourites.any((e) => e.name?.toLowerCase() == location.name?.toLowerCase());

    _isFavorite = isFavourite;
    notifyListeners();
  }

  Future removeLocationFromFavourites({required LocationModel location, required List<LocationModel> locations}) async {
    List<LocationModel> newList = [];
    for (var element in locations) {
      if (location.name != element.name) {
        newList.add(element);
      } else {
        print('REMOVING ${element.name} FROM FAVOURITES');
      }
    }

    final data = jsonEncode(newList.map((e) => e.toJson()).toList());
    await storage.write(key: kFavouriteLocationDataKey, value: data);
  }
}
